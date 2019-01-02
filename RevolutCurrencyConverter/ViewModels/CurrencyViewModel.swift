//
//  CurrencyViewModel.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/31/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit
import FlagKit

struct CurrencyViewModel {

	// MARK: - Private
	private let currency: Currency!

	// MARK: - Public
	let fullName: String!
	let shortName: String!
	let value: String!
	var currencyImage: UIImage?

	// MARK: - Initializers
	init(currency: Currency) {
		self.currency = currency
		self.fullName = Constants.shortCurrencyNameToFullNameMapping[currency.name]
		self.shortName = currency.name
		if currency.value.isZero {
			self.value = ""
		} else {
			self.value = String(format: "%.2f", currency.value)
		}
		if let flag = Flag(countryCode: String(self.shortName.prefix(2))) {
			currencyImage = flag.image(style: .circle)
		}
	}
}
