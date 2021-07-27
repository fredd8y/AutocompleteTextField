//
//  Shadow.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 18/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

// MARK: - Shadow

public enum Shadow {
	case none
	case bottomRight
	case bottomLeft
	case full
	case custom(ShadowConfiguration)
}

// MARK: - Methods

extension Shadow {
	
	/// This method return the configuration associated to the given Shadow case
	/// - Parameter view: The view on which the shadow has to be calculated
	func configuration(forView view: UIView, shadowRadius: CGFloat) -> ShadowConfiguration {
		switch self {
		case .none:
			return ShadowConfiguration.none
		case .custom(let shadowConfiguration):
			return shadowConfiguration
		default:
			return calculateRadius(self, view: view, shadowRadius: shadowRadius)
		}
	}
	
}

// MARK: - Methods (default configurations)

extension Shadow {
	
	/// This method calculate and return a shadow based on the case on which is called.
	/// - Parameters:
	///   - shadow: Shadow case
	///   - view: View on which the shadow has to be calculated
	///   - shadowRadius: Shadow radius
	func calculateRadius(_ shadow: Shadow, view: UIView, shadowRadius: CGFloat) -> ShadowConfiguration {
		let path: UIBezierPath = UIBezierPath()
		let x: CGFloat = view.bounds.origin.x
		let y: CGFloat = view.bounds.origin.y + shadowRadius + 1
		let width: CGFloat = view.bounds.width
		let height: CGFloat = view.bounds.height - shadowRadius - 1
		
		switch shadow {
		case .bottomRight:
			path.move(to: CGPoint(x: x, y: y + height))
			path.addLine(to: CGPoint(x: x + width, y: y + height))
			path.addLine(to: CGPoint(x: x + width, y: y))
			path.close()
		case .bottomLeft:
			path.move(to: CGPoint(x: x, y: y))
			path.addLine(to: CGPoint(x: x, y: y + height))
			path.addLine(to: CGPoint(x: x + width, y: y + height))
			path.close()
		case .full:
			path.move(to: CGPoint(x: x, y: y))
			path.addLine(to: CGPoint(x: x, y: y + height))
			path.addLine(to: CGPoint(x: x + width, y: y + height))
			path.addLine(to: CGPoint(x: x + width, y: y))
			path.close()
		default:
			assertionFailure("I can't calculate the radius of the given Shadow")
			return ShadowConfiguration.none
		}
		
		return ShadowConfiguration(
			shadowColor: UIColor.gray.cgColor,
			shadowOffset: CGSize.zero,
			shadowPath: path.cgPath,
			shadowRadius: shadowRadius,
			shadowOpacity: 0.7
		)
	}
	
}
