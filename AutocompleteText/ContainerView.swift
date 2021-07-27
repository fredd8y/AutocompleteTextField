//
//  ContainerView.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 03/07/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

protocol ContainerViewDelegate: AnyObject {
	func containerViewMustDismiss(_ containerView: ContainerView)
}

// MARK: - Container view

class ContainerView: UIView {
	
	weak var delegate: ContainerViewDelegate?
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if !self.bounds.contains(point) {
			delegate?.containerViewMustDismiss(self)
		}
		return super.hitTest(point, with: event)
	}
	
}
