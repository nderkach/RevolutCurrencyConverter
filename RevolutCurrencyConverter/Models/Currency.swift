//
//  Currency.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/31/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import Foundation

class Currency {
	let name: String
	var value: Double

	init(name: String, value: Double) {
		self.name = name
		self.value = value
	}
}
