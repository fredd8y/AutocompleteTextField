//
//  Utils.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 17/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import Foundation

class Utils {
	
	class func randomString(range: Range<Int>) -> String {
		let length: Int = Int.random(in: range)
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).compactMap{ _ in letters.randomElement() })
	}
	
}
