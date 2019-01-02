//
//  Constants.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit

class Constants {
	static let apiBaseURL = "https://revolut.duckdns.org"
	static let exchangeRateRefreshRate = 1.0 // in seconds

	static let shortCurrencyNameToFullNameMapping: [String: String] = {
		guard let dictionary = Bundle.main.dictionary(for: "CurrencyNames") as? [String: String] else { return [:] }
		return dictionary
	}()

	static let defaultBaseCurrency = "EUR"
	static let defaultBaseValue = 100.0

	// MARK: - UI

	static let cellHeight: CGFloat = 80.0
}
