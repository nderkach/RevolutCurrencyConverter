//
//  ExchangeRateResult.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import Foundation

typealias ExchangeRates = [String: Double]

struct ExchangeRateResult: Codable {
	let base: String
	let date: String
	let rates: ExchangeRates

	init(rates: ExchangeRates, date: Date, base: String) {
		self.rates = rates
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		self.date = dateFormatter.string(from: date)
		self.base = base
	}
}
