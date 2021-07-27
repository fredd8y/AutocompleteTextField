//
//  AutocompleteController.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 12/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

// MARK: - Autocomplete controller

public class AutocompleteController {
	
//	MARK: - Properties
	
	/// Autocomplete controller delegate
	public weak var delegate: AutocompleteControllerDelegate?
	
	/// The textfield handled by the controller
	public var autocompleteTextField: Autocompletable
	
	/// Minimum amount of character required to trigger the autocompletion
	public var minimumAmountOfCharacter: Int = 2
	
	/// Maximum amount of rows that can be displayed under the textfield
	public var maximumAmountOfDisplayableRows: Int = 5
	
	/// Maximum levenshtein distance, this distance is defined as the
	/// minimum amount of single changes (insert, delete, substitution)
	/// required to change one word into the other
	public var maximumLevenshteinDistance: Int = 0
	
	/// List of words that can be shown
	public var values: [String] = []
	
	/// Flag that indicates if the match has to be case sensitive or not
	public var isCaseSensitive: Bool = false
	
	/// Corner radius of the container view
	public var cornerRadius: CGFloat = 0
	
	/// Corners that has to be rounded
	public var cornersToRound: UIRectCorner = []
	
	/// Shadow configuration of the container view
	public var shadow: Shadow = .none
	
	/// Shadow radius of the container view
	public var shadowRadius: CGFloat = 5
	
	/// Width of the list container border
	public var borderWidth: CGFloat = 1.0
	
	/// Border color of the list container
	public var borderColor: UIColor = UIColor.gray
	
	/// Width of the rows separator
	public var rowSeparatorHeight: CGFloat = 1.0
	
	/// Color of the rows separator
	public var rowSeparatorColor: UIColor = UIColor.gray
	
	/// Background color of the hint rows
	public var backgroundColor: UIColor = UIColor.white
	
	/// Rows font
	public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
	
//	MARK: - Private properties
	
	/// The autocomplete view handled by this controller
	private var containerView: ContainerView = ContainerView()
	
	/// The view that hold the shadow
	private var shadowView: UIView = UIView()
	
	/// Rows currently displayed
	private var rowViews: [AutocompleteRowView] = []
	
	/// Absolute indexes of the current displayed rows
	private var currentAbsoluteIndexes: [Int] = []
	
	/// The topmost view controller of current window, if exists
	private lazy var topMostViewController: UIViewController? = {
		return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
	}()
	
	/// The nearest scrollView that contains the autocompleteTextField, if exists
	private lazy var nearestScrollView: UIScrollView? = {
		var superScrollView: UIScrollView? = nil
		
		var superview: UIView? = autocompleteTextField.superview
		while superview != nil {
			if let scrollView = superview as? UIScrollView {
				superScrollView = scrollView
				break
			}
			superview = superview?.superview
		}
		
		return superScrollView
	}()
	
	/// Computed properties that returns the wiew that will contain our autocompleteTextField
	private var viewThatWillContainDropdown: UIView? {
		return nearestScrollView ?? topMostViewController?.view
	}
	
//	MARK: - Public initializers
	
	/// Initializer
	/// - Parameters:
	///   - autocompleteTextField: Textfield handled by the controller
	public init(autocompleteTextField: Autocompletable) {
		self.autocompleteTextField = autocompleteTextField
		
		addObserversTo(autocompleteTextField)
		addDelegates()
	}
	
}

// MARK: - Private methods (lifecycle)

extension AutocompleteController {
	
	/// Called when the textfield gain focus
	private func autocompleteTextFieldDidBegin() {
		guard
			let _delegate = delegate,
			_delegate.autocompleteControllerShouldAutocomplete(self),
			let textValue = autocompleteTextField.text,
			textValue.count >= minimumAmountOfCharacter
		else { return }
		let filteredValues: [(offset: Int, element: String)] = Array(filterValues(input: textValue).prefix(maximumAmountOfDisplayableRows))
		_delegate.autocompleteController(self, didFindMatch: filteredValues.count > 0)
		if filteredValues.count > 0 {
			currentAbsoluteIndexes = filteredValues.map({ $0.offset })
			rowViews = getRowViews(fromValues: filteredValues.map({ $0.element }))
			resizeContainer()
		} else {
			cleanContainer()
		}
	}
	
	/// Called when the textfield change it's content
	private func autocompleteTextFieldDidChange() {
		guard
			let _delegate = delegate,
			_delegate.autocompleteControllerShouldAutocomplete(self),
			let textValue = autocompleteTextField.text
		else { return }
		
		if textValue.count >= minimumAmountOfCharacter {
			let filteredValues: [(offset: Int, element: String)] = Array(filterValues(input: textValue).prefix(maximumAmountOfDisplayableRows))
			_delegate.autocompleteController(self, didFindMatch: filteredValues.count > 0)
			if filteredValues.count > 0 {
				currentAbsoluteIndexes = filteredValues.map({ $0.offset })
				rowViews = getRowViews(fromValues: filteredValues.map({ $0.element }))
				resizeContainer()
			} else {
				cleanContainer()
			}
		} else {
			cleanContainer()
		}
	}
	
	/// Called when the textfield lose focus
	private func autocompleteTextFieldDidEnd() {
		cleanContainer()
		delegate?.autocompleteControllerDismissed(self)
	}
	
}

// MARK: - Private methods (utilities)

extension AutocompleteController {
	
	/// Utility method that remove all the views from the container
	private func cleanContainer() {
		rowViews.forEach({ $0.removeFromSuperview() })
		containerView.subviews.forEach({ $0.removeFromSuperview() })
		containerView.removeFromSuperview()
		shadowView.removeFromSuperview()
	}
	
	/// Method that resize the given container according to the parameters
	private func resizeContainer() {
		containerView.frame = getFrameBasedOnTextField()
		roundCorners()
		let stackView = createStackWithRowViews()
		containerView.addSubview(stackView)
		setBorderTo(stackView)
		setShadowToShadowView()
				
		viewThatWillContainDropdown?.addSubview(containerView)
	}
	
}

// MARK: - Private methods (UI)

extension AutocompleteController {
	
	/// This method add a border to the view with width and color set
	/// - Parameters:
	///   - stackView: The view on which the border has to be draw
	private func setBorderTo(_ stackView: UIView) {
		let borderLayer: CAShapeLayer = CAShapeLayer()
		borderLayer.path = UIBezierPath(
			roundedRect: containerView.bounds,
			byRoundingCorners: cornersToRound,
			cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
		).cgPath
		borderLayer.lineWidth = borderWidth
		borderLayer.strokeColor = borderColor.cgColor
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.frame = containerView.bounds
		stackView.layer.addSublayer(borderLayer)
	}
	
	/// This method add the corners radius to the corners that has to be rounded
	private func roundCorners() {
		containerView.layer.masksToBounds = true
		
		let maskLayer: CAShapeLayer = CAShapeLayer()
		maskLayer.path = UIBezierPath(
			roundedRect: containerView.bounds,
			byRoundingCorners: cornersToRound,
			cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
		).cgPath
		containerView.layer.mask = maskLayer
	}
	
	/// This method set the shadow to the container view
	private func setShadowToShadowView() {
		shadowView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
		let configuration: ShadowConfiguration = shadow.configuration(
			forView: containerView,
			shadowRadius: shadowRadius
		)
		shadowView.frame = containerView.frame
		shadowView.layer.shadowOpacity = configuration.shadowOpacity
		shadowView.layer.shadowColor = configuration.shadowColor
		shadowView.layer.shadowOffset = configuration.shadowOffset
		shadowView.layer.shadowPath = configuration.shadowPath
		shadowView.layer.shadowRadius = configuration.shadowRadius
		shadowView.layer.shouldRasterize = true
		containerView.removeFromSuperview()
		shadowView.addSubview(containerView)
		
		viewThatWillContainDropdown?.addSubview(shadowView)
	}
	
	/// Return a CGRect whose measure is calculated so that it is below the textfield,
	/// and is high enough to fit all the row views
	private func getFrameBasedOnTextField() -> CGRect {
		// Here we convert the frame to match the frame of the view controller
		// that will contain the accordion
				
		let convertedFrame = autocompleteTextField.convert(autocompleteTextField.bounds, to: viewThatWillContainDropdown)
		return CGRect(
			x: convertedFrame.origin.x,
			y: convertedFrame.origin.y + convertedFrame.height,
			width: convertedFrame.width,
			height: rowViews.reduce(0) { sum, item in
				return sum + item.intrinsicContentSize.height
			} + ((CGFloat(rowViews.count) * rowSeparatorHeight) - 1)
		)
	}
	
	/// Create and return a UIStackView containing all the rowViews,
	/// and set it's bounds equal to the containerView
	private func createStackWithRowViews() -> UIStackView {
		let stackView: UIStackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		rowViews.enumerated().forEach({ index, item in
			if index > 0 {
				let separator: SeparatorView = SeparatorView(
					frame: CGRect(
						x: item.frame.origin.x,
						y: item.frame.origin.y,
						width: containerView.bounds.width,
						height: rowSeparatorHeight
					)
				)
				separator.backgroundColor = rowSeparatorColor
				stackView.addArrangedSubview(separator)
			}
			stackView.addArrangedSubview(item)
		})
		stackView.frame = containerView.bounds
		return stackView
	}
	
}

// MARK: - Private methods (business logic)

extension AutocompleteController {
	
	/// This function filter the given list based on the given input,
	/// it return a list of element that contains the input as a prefix.
	/// The levenshtein distance is a parameter that indicates the tolerance
	/// that this filter has.
	/// Examples:
	/// -	levenshtein distance = 0, "word" != "lord"
	/// -	levenshtein distance = 1, "word" = "lord"
	///
	/// - Parameters:
	///   - input: Text used for the filter
	func filterValues(input: String) -> [(offset: Int, element: String)] {
		return values.enumerated().filter({ index, currentItem in
			var _currentItem = currentItem
			var _input = input
			if !isCaseSensitive {
				_currentItem = _currentItem.lowercased()
				_input = _input.lowercased()
			}
			return String(_currentItem.prefix(_input.count)).levenshtein(_input) <= maximumLevenshteinDistance
		})
	}
	
	/// Return an Array of AutocompleteRowView configured with the given values
	/// - Parameter values: List of String used to configure the views
	func getRowViews(fromValues values: [String]) -> [AutocompleteRowView] {
		return values.enumerated().map({ index, element in
			let newRow = AutocompleteRowView()
			newRow.delegate = self
			newRow.index = index
			newRow.font = font
			newRow.backgroundColor = backgroundColor
			newRow.text = element
			return newRow
		})
	}
	
}

// MARK: - Private methods (observers)

extension AutocompleteController {
	
	/// Utils method to add all the delegates that are useful
	private func addDelegates() {
		containerView.delegate = self
	}
	
	/// Setup all the listeners to handle all the events emitted by the textField
	private func addObserversTo(_ textField: UITextField) {
		addBeginEditingObserverTo(textField, method: { self.autocompleteTextFieldDidBegin() })
		addDidChangeObserverTo(textField, method: { self.autocompleteTextFieldDidChange() })
		addEndEditingObserverTo(textField, method: { self.autocompleteTextFieldDidEnd() })
	}
	
	/// Bind the given method to the given textfield textDidChangeNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addDidChangeObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidChangeNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
		}
	}
	
	/// Bind the given method to the given textfield textDidBeginEditingNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addBeginEditingObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidBeginEditingNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
		}
	}
	
	/// Bind the given method to the given textfield textDidEndEditingNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addEndEditingObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidEndEditingNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
		}
	}
	
}

// MARK: - Autocomplete row view delegate

extension AutocompleteController: AutocompleteRowViewDelegate {
	func autocompleteRowView(_ autocompleteRowView: AutocompleteRowView, didSelect index: Int) {
		delegate?.autocompleteController(
			self,
			didTapIndex: currentAbsoluteIndexes[index],
			textAtIndex: values[currentAbsoluteIndexes[index]]
		)
	}
}

// MARK: - Container view delegate

extension AutocompleteController: ContainerViewDelegate {
	func containerViewMustDismiss(_ containerView: ContainerView) {
		cleanContainer()
	}
}
