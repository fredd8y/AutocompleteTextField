//
//  AutocompleteControllerTests.swift
//  AutocompleteTextTests
//
//  Created by Federico Arvat on 22/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import XCTest
@testable import AutocompleteText

class AutocompleteControllerTests: XCTestCase {

	var autocompleteTextField: Autocompletable!
	var autocompleteController: AutocompleteController!
	let values = [
		"Green Lantern",
		"Sinestro",
		"Batman",
		"Joker",
		"Flash",
		"Captain Cold",
		"Superman",
		"Lex Luthor",
		"Wonder Woman",
		"Ares"
	]
	
    override func setUp() {
		autocompleteTextField = AutocompleteTextField()
        autocompleteController = AutocompleteController(autocompleteTextField: autocompleteTextField)
		autocompleteController.values = values
    }
	
//	MARK: - Test filter values
	
	/// Test the algorithm with a levenshtein distance equal to 0
	/// Case Sensitive set to False, giving an input that MUST NOT return a value.
	func testFilterValuesZeroDistanceInsensitiveEmpty() {

		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "Kite Man")
		
		XCTAssert(filteredValues.count == 0, "This array must be empty")
	}
	
	/// Test the algorithm with a levenshtein distance equal to 0
	/// Case Sensitive set to False, giving an input that MUST return a single value.
	func testFilterValuesZeroDistanceInsensitiveSingleResult() {

		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "su")
		
		guard let value = filteredValues.first?.element else {
			XCTFail("This array must not be empty")
			return
		}
		XCTAssert(filteredValues.count == 1 && value == "Superman", "This array must contain one value")
	}
	
	/// Test the algorithm with a levenshtein distance equal to 0
	/// Case Sensitive set to False, giving an input that MUST return a single value.
	func testFilterValuesZeroDistanceInsensitiveMultipleResult() {

		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "s")
		
		XCTAssert(filteredValues.allSatisfy({ ["Superman", "Sinestro"].contains($0.element) }), "This array must contain two values")
	}
	
	/// Test the algorithm with a levenshtein distance equal to 0
	/// Case Sensitive set to True, giving an input that MUST return a single value.
	func testFilterValuesZeroDistanceSensitiveSingleResult() {

		autocompleteController.isCaseSensitive = true
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "Su")
		
		guard let value = filteredValues.first?.element else {
			XCTFail("This array must not be empty")
			return
		}
		XCTAssert(filteredValues.count == 1 && value == "Superman", "This array must contain one value")
	}
	
	/// Test the algorithm with a levenshtein distance equal to 0
	/// Case Sensitive set to True, giving an input that MUST NOT return value.
	func testFilterValuesZeroDistanceSensitiveEmpty() {

		autocompleteController.isCaseSensitive = true
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "su")
		
		XCTAssert(filteredValues.count == 0, "This array must be empty")
	}
	
	/// Test the algorithm with a levenshtein distance equal to the amount of
	/// character inserted by the user, the algorithm must return always all
	/// the values contained in the list
	func testFilterValuesWithDistanceEqualToInput() {

		autocompleteController.isCaseSensitive = true
		
		for i in 1..<10 {
			autocompleteController.maximumLevenshteinDistance = i
			
			let filteredValues = autocompleteController.filterValues(input: Utils.randomString(range: 0..<i))
			
			guard filteredValues.count == values.count else {
				XCTFail("The filtered array must have the same element amount of the given array")
				return
			}
		}
	}
	
	/// Test the algorithm with a levenshtein distance equal to 1
	/// Case Sensitive set to True, giving an input that MUST return a single value.
	func testFilterValuesDistanceOneSensitiveSingleResult() {

		autocompleteController.isCaseSensitive = true
		autocompleteController.maximumLevenshteinDistance = 1
		
		for i in 0..<1 {
			let filteredValues = autocompleteController.filterValues(input: i == 0 ? "Fl" : "Fs")
			
			guard let value = filteredValues.first?.element else {
				XCTFail("This array must not be empty")
				return
			}
			XCTAssert(filteredValues.count == 1 && value == "Flash", "This array must contain one value")
		}
		
	}
	
	/// Test the algorithm with a levenshtein distance equal to 1
	/// Case Sensitive set to False, giving an input that MUST return a single value.
	func testFilterValuesDistanceOnInsensitiveSingleResult() {

		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 1
		
		for i in 0..<1 {
			let filteredValues = autocompleteController.filterValues(input: i == 0 ? "fl" : "fs")
			
			guard let value = filteredValues.first?.element else {
				XCTFail("This array must not be empty")
				return
			}
			XCTAssert(filteredValues.count == 1 && value == "Flash", "This array must contain one value")
		}
		
	}
	
	/// Test the algorithm with a levenshtein distance equal to 1
	/// Case Sensitive set to True, giving an input that MUST return a single value.
	func testFilterValuesDistanceOneSensitiveMultipleResult() {
		
		autocompleteController.isCaseSensitive = true
		autocompleteController.maximumLevenshteinDistance = 1
		
		for i in 0..<2 {
			var input: String = ""
			switch i {
			case 0:
				input = "Su"
			case 1:
				input = "Si"
			case 2:
				input = "Sa"
			default:
				XCTFail("There was a problem with the test")
			}
			
			let filteredValues = autocompleteController.filterValues(input: input)
			
			XCTAssert(filteredValues.allSatisfy({ ["Superman", "Sinestro"].contains($0.element) }), "This array must contain two values")
		}
		
	}
	
	/// Test the algorithm with a levenshtein distance equal to 1
	/// Case Sensitive set to False, giving an input that MUST return a single value.
	func testFilterValuesDistanceOneInsensitiveMultipleResult() {
		
		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 1
		
		for i in 0..<2 {
			var input: String = ""
			switch i {
			case 0:
				input = "su"
			case 1:
				input = "si"
			case 2:
				input = "sa"
			default:
				XCTFail("There was a problem with the test")
			}
			
			let filteredValues = autocompleteController.filterValues(input: input)
			
			XCTAssert(filteredValues.allSatisfy({ ["Superman", "Sinestro"].contains($0.element) }), "This array must contain two values")
		}
		
	}
	
//	MARK: - Test filter indexes
	
	func testFilterValuesIndex() {
		autocompleteController.isCaseSensitive = false
		autocompleteController.maximumLevenshteinDistance = 0
		
		let filteredValues = autocompleteController.filterValues(input: "s")
				
		XCTAssert(filteredValues.allSatisfy({ ["Superman", "Sinestro"].contains($0.element) }), "This array must contain two values")
		XCTAssert(filteredValues.allSatisfy({ [1, 6].contains($0.offset) }), "Wrong indexes")
	}
	
}
