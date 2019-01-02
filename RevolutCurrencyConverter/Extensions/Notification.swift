//
//  Notification.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 1/1/19.
//  Copyright © 2019 Nikolay Derkach. All rights reserved.
//

import Foundation

extension Notification.Name {
	struct Revolut {
		private static let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
		private static let notificationNamePrefix = ".notification.name.revolut"

		static let DidChangeBaseCurrencyValue = Notification.Name(rawValue: "\(bundleIdentifier)\(notificationNamePrefix).currencyValueChangedNotification")
		static let DidRecalculateExchangeRates = Notification.Name(rawValue: "\(bundleIdentifier)\(notificationNamePrefix).currencyExchangeRateRecalculatedNotification")
	}
}
