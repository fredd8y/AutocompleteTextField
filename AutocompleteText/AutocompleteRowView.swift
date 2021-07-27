//
//  AutocompleteRowView.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

// MARK: - Autocomplete row view delegate

protocol AutocompleteRowViewDelegate: AnyObject {
	func autocompleteRowView(_ autocompleteRowView: AutocompleteRowView, didSelect index: Int)
}

// MARK: - Autocomplete row view

class AutocompleteRowView: UIView {
	
//	MARK: - Private properties
	
	/// Label that contain the given text
	private let label: UILabel = UILabel()
	
	/// Top and bottom inset
	private let verticalInset: CGFloat = 10
	
	/// Trailing and leading inset
	private let horizontalInset: CGFloat = 10
	
	/// Tap gesture to detect which row has been tapped
	private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
		target: self,
		action: #selector(handleTap)
	)
	
//	MARK: - Public properties
	
	/// Autocomplete row view delegate
	weak var delegate: AutocompleteRowViewDelegate?
	
	/// The Word that has to be shown
	var text: String = "" {
		didSet {
			label.text = text
			label.sizeToFit()
		}
	}
	
	/// Row index, this index is used to track where the user has tapped
	var index: Int!
	
	/// Rows font
	var font: UIFont {
		set { label.font = newValue }
		get { return label.font }
	}
	
//	MARK: - Public initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		commonInit()
	}
	
//	MARK: - Private methods
	
	private func commonInit() {
		addSubview(label)
		
		translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		addGestureRecognizer(tapGesture)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: topAnchor, constant: verticalInset),
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			label.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	@objc private func handleTap() {
		delegate?.autocompleteRowView(self, didSelect: index)
	}
	
//	MARK: - Override methods
	
	override var intrinsicContentSize: CGSize {
		return CGSize(
			width: label.frame.width + (2 * horizontalInset),
			height: label.frame.height + (2 * verticalInset)
		)
	}
	
}
