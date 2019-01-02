//
//  Bundle+Dictionary.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 1/1/19.
//  Copyright © 2019 Nikolay Derkach. All rights reserved.
//

import Foundation

extension Bundle {
	func dictionary(for name: String) -> [String: AnyObject] {
		guard
			let plistUrl = url(forResource: name, withExtension: "plist"),
			let data = try? Data(contentsOf: plistUrl),
			let properties = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
			let list = properties as? [String: AnyObject]
			else { return [:] }
		return list
	}
}
