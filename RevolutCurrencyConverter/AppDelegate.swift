//
//  AppDelegate.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		window?.tintColor = .underlineActiveColor

		return true
	}
}
