//
//  RevolutCurrencyConverterTests.swift
//  RevolutCurrencyConverterTests
//
//  Created by Nikolay Derkach on 1/2/19.
//  Copyright © 2019 Nikolay Derkach. All rights reserved.
//

import XCTest
@testable import RevolutCurrencyConverter

class RevolutCurrencyConverterTests: XCTestCase {

	private var currencyList: CurrencyList!
	private let exchangeRatesMock = ["AUD": 1.624, "MXN": 22.471, "ILS": 4.1903, "BRL": 4.8144, "NOK": 9.8221, "BGN": 1.965, "ISK": 128.4, "SEK": 10.641, "NZD": 1.7716, "CNY": 7.9826, "HKD": 9.1755, "DKK": 7.4919, "MYR": 4.8347, "TRY": 7.6642, "JPY": 130.16, "RUB": 79.95, "INR": 84.112, "GBP": 0.90247, "THB": 38.31, "CZK": 25.836, "PLN": 4.3387, "RON": 4.6604, "USD": 1.1689, "CAD": 1.541, "IDR": 17405.0, "KRW": 1310.9, "SGD": 1.6075, "CHF": 1.1328, "HUF": 328.03, "HRK": 7.4691, "PHP": 62.887, "ZAR": 17.907]

    override func setUp() {
		currencyList = CurrencyList()
		let exchangeRateResult = ExchangeRateResult(rates: exchangeRatesMock, date: Date(), base: "EUR")

		currencyList.recalculate(exchangeRates: exchangeRateResult.rates)
    }

	func testCurrencyViewModelRegular() {
		let currencyModel = Currency(name: "EUR", value: 999)
		let currencyViewModel = CurrencyViewModel(currency: currencyModel)

		XCTAssertEqual(currencyViewModel.fullName, "Euro")
		XCTAssertEqual(currencyViewModel.shortName, "EUR")
		XCTAssertEqual(currencyViewModel.value, "999.00")
	}

	func testCurrencyViewModelZero() {
		let currencyModel = Currency(name: "RUB", value: 0.0)
		let currencyViewModel = CurrencyViewModel(currency: currencyModel)

		XCTAssertEqual(currencyViewModel.fullName, "Russian ruble")
		XCTAssertEqual(currencyViewModel.shortName, "RUB")
		XCTAssertEqual(currencyViewModel.value, "")
	}

	func testCurrencyListInitialState() {
		XCTAssertEqual(currencyList.baseValue, Constants.defaultBaseValue)
		XCTAssertEqual(currencyList.baseCurrency, Constants.defaultBaseCurrency)

		XCTAssertEqual(currencyList.findCurrencyByName("EUR")?.value, Constants.defaultBaseValue)
	}

	func testCurrencyListZeroState() {
		// Emulate erasing all contents of the base value textfield
		NotificationCenter.default.post(name: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, userInfo: ["value": ""])

		currencyList.currencies.forEach { currency in
			XCTAssertEqual(currency.value, 0.0)
		}
	}

	func testSetDifferentBaseCurrency() {
		// Setting base currency to ILS
		let ILSIndex = (currencyList.currencies.index(where: { $0.name == "ILS" }))!
		currencyList.setBaseCurrency(withIndex: ILSIndex)

		XCTAssertEqual(currencyList.baseValue, Constants.defaultBaseValue * (exchangeRatesMock["ILS"])!)
		XCTAssertEqual(currencyList.baseCurrency, "ILS")
		XCTAssertEqual(currencyList.findCurrencyByName("EUR")?.value, Constants.defaultBaseValue)

		NotificationCenter.default.post(name: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, userInfo: ["value": "10"])

		XCTAssertEqual(currencyList.findCurrencyByName("EUR")?.value, 10.0/(exchangeRatesMock["ILS"])!)
	}

	func testErroneousInput() {
		NotificationCenter.default.post(name: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, userInfo: ["value": ".0"])

		XCTAssertEqual(currencyList.baseValue, 0.0)

		NotificationCenter.default.post(name: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, userInfo: ["value": "065.3"])

		XCTAssertEqual(currencyList.baseValue, 65.3)
	}
}
