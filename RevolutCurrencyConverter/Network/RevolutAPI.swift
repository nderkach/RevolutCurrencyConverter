//
//  RevolutAPI.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import Siesta
import Alamofire

class RevolutAPI {

	// MARK: - Configuration
	private let service = Service(
		baseURL: Constants.apiBaseURL,
		standardTransformers: [.text, .image],
		networking: SessionManager.default
	)

	weak var delegate: RevolutAPIDelegate?

	// MARK: - Private

	private var timer = Timer()

	// MARK: - Initialziers

	init() {
		#if DEBUG
		// Bare-bones logging of which network calls Siesta makes:
		SiestaLog.Category.enabled = [.network]
		#endif

		// –––––– Global configuration ––––––

		let jsonDecoder = JSONDecoder()

		// –––––– Mapping from specific paths to models ––––––

		service.configureTransformer("/latest", requestMethods: [.get]) {
			try jsonDecoder.decode(ExchangeRateResult.self, from: $0.content)
		}

		timer = Timer.scheduledTimer(withTimeInterval: Constants.exchangeRateRefreshRate, repeats: true, block: { [weak self] _ in
			self?.getCurrencyList()
		})
	}

	deinit {
		timer.invalidate()
	}

	// MARK: - Endpoint Accessors

	func getCurrencyList(withBaseCurrency baseCurrency: String = Constants.defaultBaseCurrency) {
		service.resource("/latest")
			.withParam("base", baseCurrency)
			.addObserver(self).load()
	}
}

// MARK: - ResourceObserver

extension RevolutAPI: ResourceObserver {
	func resourceChanged(_ resource: Resource, event: ResourceEvent) {
		switch event {
		case .error:
			break
		case .newData:
			if let result = resource.typedContent() as ExchangeRateResult? {
				delegate?.didFinishFetchingCurrencies(result.rates)
			}
		default:
			break
		}
	}
}

protocol RevolutAPIDelegate: class {
	func didFinishFetchingCurrencies(_ result: ExchangeRates)
}
