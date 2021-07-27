//
//  AutocompleteControllerDelegate.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 05/07/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import Foundation

// MARK: - Autocomplete controller delegate

public protocol AutocompleteControllerDelegate: AnyObject {
	/// Called when the textField has lost focus and the dropdown has been dismissed
	/// - Parameter autocompleteController: Autocomplete Controller that handle the textField
	func autocompleteControllerDismissed(_ autocompleteController: AutocompleteController)
	
	/// Called when the user tap a hint
	/// - Parameters:
	///   - autocompleteController: Autocomplete Controller that handle the textField
	///   - index: Absoulte index referring the complete list of values given in input
	///   - text: The String tapped by the user
	func autocompleteController(_ autocompleteController: AutocompleteController, didTapIndex index: Int, textAtIndex text: String)
	
	/// Called every time the dropdown change it's values
	/// - Parameters:
	///   - autocompleteController: Autocomplete Controller that handle the textField
	///   - match: Boolean value that indicates if a match has been founded
	func autocompleteController(_ autocompleteController: AutocompleteController, didFindMatch match: Bool)
	
	/// The value returned by this method tell the dropdown if has to be shown or not
	/// - Parameter autocompleteController: Autocomplete Controller that handle the textField
	func autocompleteControllerShouldAutocomplete(_ autocompleteController: AutocompleteController) -> Bool
}

public extension AutocompleteControllerDelegate {
	func autocompleteControllerDismissed(_ autocompleteController: AutocompleteController) {}
	
	func autocompleteController(_ autocompleteController: AutocompleteController, didTapIndex index: Int, textAtIndex text: String) {}
	
	func autocompleteController(_ autocompleteController: AutocompleteController, didFindMatch match: Bool) {}
}
