//
//  ShadowConfiguration.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 18/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

//MARK: - Shadow configuration

public struct ShadowConfiguration {
	var shadowColor: CGColor?
	var shadowOffset: CGSize
	var shadowPath: CGPath?
	var shadowRadius: CGFloat
	var shadowOpacity: Float
}

extension ShadowConfiguration {
	
	/// Default value for .none case
	public static var none: ShadowConfiguration {
		get {
			return ShadowConfiguration(
				shadowColor: nil,
				shadowOffset: CGSize.zero,
				shadowPath: nil,
				shadowRadius: 0,
				shadowOpacity: 0
			)
		}
	}
	
}
