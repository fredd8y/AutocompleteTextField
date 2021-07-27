//
//  TableViewCell.swift
//  AutocompleteTextExamples
//
//  Created by Federico Arvat on 02/07/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit
import AutocompleteText

// MARK: - Table view cell

class TableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var autocompleteTextField: AutocompleteTextField!
	
	private var autocompleteController: AutocompleteController?
	
	private var title: String!
	private var maximumLevenshteinDistance: Int!
	private var minAmountOfCharacter: Int!
	private var shadow: Shadow!
	private var cornerRadius: CGFloat!
	private var cornersToRound: UIRectCorner!
	
	func config(
		title: String,
		maximumLevenshteinDistance: Int,
		minAmountOfCharacter: Int,
		shadow: Shadow,
		cornerRadius: CGFloat,
		cornersToRound: UIRectCorner
	) {
		self.maximumLevenshteinDistance = maximumLevenshteinDistance
		self.minAmountOfCharacter = minAmountOfCharacter
		self.shadow = shadow
		self.cornerRadius = cornerRadius
		self.cornersToRound = cornersToRound
		
		label.text = title
		
		autocompleteController = AutocompleteController(autocompleteTextField: autocompleteTextField)
		guard let _autocompleteController = self.autocompleteController else { return }
		
		_autocompleteController.delegate = self
		_autocompleteController.values = ExampleData.superheroes.sorted()
		_autocompleteController.maximumLevenshteinDistance = maximumLevenshteinDistance
		_autocompleteController.minimumAmountOfCharacter = minAmountOfCharacter
		_autocompleteController.shadow = shadow
		_autocompleteController.cornerRadius = cornerRadius
		_autocompleteController.cornersToRound = cornersToRound
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension TableViewCell: AutocompleteControllerDelegate {
	func autocompleteControllerShouldAutocomplete(_ autocompleteController: AutocompleteController) -> Bool {
		return true
	}
}
