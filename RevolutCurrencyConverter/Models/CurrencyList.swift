//
//  CurrencyList.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 1/1/19.
//  Copyright © 2019 Nikolay Derkach. All rights reserved.
//

import Foundation

class CurrencyList {

	// MARK: - Private
	private(set) var baseCurrency = Constants.defaultBaseCurrency
	private(set) var baseValue = Constants.defaultBaseValue

	private(set) var currencies: [Currency] = []

	private var exchangeRates: ExchangeRates?

	init() {
		currencies = Constants.shortCurrencyNameToFullNameMapping.keys.map { Currency(name: $0, value: baseValue) }

		_ = NotificationCenter.default.addObserver(forName: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, queue: OperationQueue.main) { (notification) -> Void in

			let stringValue = notification.userInfo?["value"] as! String
			let doubleValue = Double(stringValue) ?? 0.0

			self.updateBaseValue(doubleValue)
		}
	}

	// Recalculate currencies based on current exchange rates
	@discardableResult func recalculate(exchangeRates newExchangeRates: ExchangeRates? = nil) -> [Currency] {
		if let newExchangeRates = newExchangeRates {
			exchangeRates = newExchangeRates
		}

		if let exchangeRateResult = exchangeRates {
			currencies.forEach { currency in
				var newMultiplier = exchangeRateResult[currency.name] ?? 1.0
				if baseCurrency != Constants.defaultBaseCurrency {
					newMultiplier = newMultiplier / (exchangeRateResult[baseCurrency] ?? 1.0)
				}
				currency.value = baseValue * newMultiplier
			}
		}

		return currencies
	}

	func setBaseCurrency(withIndex index: Int) {
		// Base currency is always the first one in the model
		currencies.swapAt(0, index)

		guard let firstCurrency = currencies.first else { return }
		baseCurrency = firstCurrency.name
		baseValue = firstCurrency.value

		recalculate()
	}

	private func updateBaseValue(_ value: Double) {
		baseValue = value

		recalculate()

		// Notify the view controller to redraw the visible currencies after a recalculation
		NotificationCenter.default.post(name: Notification.Name.Revolut.DidRecalculateExchangeRates, object: nil)
	}

	func findCurrencyByName(_ currencyName: String) -> Currency? {
		return currencies.filter { $0.name == currencyName }.first
	}
}
