//
//  String.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 17/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

extension String {
	func levenshtein(_ other: String) -> Int {
		
        let selfCount = self.count
        let otherCount = other.count
        
		// Initial check, if one of the two words is empty return the amount of character of the other one
        if selfCount == 0 { return otherCount }
        if otherCount == 0 { return selfCount }
        
		// Setup the matrix to perform the calculation
        let line : [Int]  = Array(repeating: 0, count: otherCount + 1)
        var matrix : [[Int]] = Array(repeating: line, count: selfCount + 1)
        for i in 0...selfCount { matrix[i][0] = i }
        for j in 0...otherCount { matrix[0][j] = j }
        
		// Perform the calculation
        for j in 1...otherCount {
            for i in 1...selfCount {
                if self[self.index(self.startIndex, offsetBy: i - 1)] as Character == other[other.index(other.startIndex, offsetBy: j - 1)] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                }
                else {
                    let delete = matrix[i - 1][j] + 1
                    let insert = matrix[i][j - 1] + 1
                    let subtraction = matrix[i - 1][j - 1] + 1
                    matrix[i][j] = min(min(delete, insert), subtraction)
                }
            }
        }
        
        return matrix[selfCount][otherCount]
    }
	
}
