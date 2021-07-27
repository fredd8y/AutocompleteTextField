//
//  ViewController.swift
//  AutocompleteTextExamples
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit
import AutocompleteText

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		
		tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
		
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
	}

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
		switch indexPath.row {
		case 0:
			cell.config(
				title: "levenshteinDistance: 0\nminAmountOfCharacter: 0\nshadow: bottom and right\ncornerRadius: 8\nroundedCorners: bottomRight and bottomLeft",
				maximumLevenshteinDistance: 0,
				minAmountOfCharacter: 0,
				shadow: Shadow.bottomRight,
				cornerRadius: 8,
				cornersToRound: [.bottomRight, .bottomLeft]
			)
		case 1:
			cell.config(
				title: "levenshteinDistance: 0\nminAmountOfCharacter: 2\nshadow: bottom, left and right\ncornerRadius: 8\nroundedCorners: bottomRight and bottomLeft",
				maximumLevenshteinDistance: 0,
				minAmountOfCharacter: 2,
				shadow: Shadow.full,
				cornerRadius: 8,
				cornersToRound: [.bottomRight, .bottomLeft]
			)
		case 2:
			cell.config(
				title: "levenshteinDistance: 1\nminAmountOfCharacter: 0\nshadow: bottom and left\ncornerRadius: 8\nroundedCorners: bottomRight and bottomLeft",
				maximumLevenshteinDistance: 1,
				minAmountOfCharacter: 0,
				shadow: Shadow.bottomLeft,
				cornerRadius: 8,
				cornersToRound: [.bottomRight, .bottomLeft]
			)
		case 3:
			cell.config(
				title: "levenshteinDistance: 0\nminAmountOfCharacter: 0\nshadow: bottom, left and right\ncornerRadius: 8\nroundedCorners: all",
				maximumLevenshteinDistance: 0,
				minAmountOfCharacter: 0,
				shadow: Shadow.full,
				cornerRadius: 8,
				cornersToRound: .allCorners
			)
		default:
			break
		}
		return cell
	}
}
