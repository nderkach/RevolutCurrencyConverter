//
//  ViewController.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit

class CurrencyListViewController: UITableViewController {

	// MARK: - Private
	private let cellIdentifier = "CurrencyTableViewCell"

	private let revolutAPI = RevolutAPI()
	private let currencyList = CurrencyList()
	private var currencies: [CurrencyViewModel] = [] {
		didSet {
			// Load data initially, but only refresh visible cells to keep first responder status of the base currency cell
			if oldValue.isEmpty {
				tableView.reloadData()
			} else {
				refreshVisibleCells()
			}
		}
	}

	// MARK: - View Controller Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		revolutAPI.delegate = self

		tableView.tableFooterView = UIView()
		tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView.separatorStyle = .none

		_ = NotificationCenter.default.addObserver(forName: Notification.Name.Revolut.DidRecalculateExchangeRates, object: nil, queue: OperationQueue.main) { _ in
			self.currencies = self.currencyList.currencies.map { CurrencyViewModel(currency: $0) }
			self.refreshVisibleCells()
		}
	}

	// MARK: - Cell configuration

	private func configure(_ cell: CurrencyTableViewCell, atIndexPath indexPath: IndexPath) {
		cell.currencyViewModel = currencies[indexPath.row]
		cell.currencyValueTextField.delegate = self
	}

	private func refreshVisibleCells() {
		for cell in tableView.visibleCells {
			let currencyCell = cell as! CurrencyTableViewCell
			// Update all visible cells except the top cell which sets the base currency
			if currencyCell.isUpdating {
				continue
			}
			let cellIndexPath = tableView.indexPath(for: currencyCell)!
			configure(currencyCell, atIndexPath: cellIndexPath)
		}
	}
}

// MARK: - UITableViewDataSource

extension CurrencyListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CurrencyTableViewCell
		configure(cell, atIndexPath: indexPath)
		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.cellHeight
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let firstIndexPath = IndexPath(row: 0, section: 0)
		let firstCell = tableView.cellForRow(at: firstIndexPath) as? CurrencyTableViewCell
		firstCell?.endEditing()

		// Set base currency to the selected one
		currencyList.setBaseCurrency(withIndex: indexPath.row)

		tableView.performBatchUpdates({
			tableView.moveRow(at: indexPath, to: firstIndexPath)
		}, completion: { _ in
			UIView.animate(withDuration: 0.5, animations: {
			tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
			}, completion: { _ in
			let firstCell = tableView.cellForRow(at: firstIndexPath) as? CurrencyTableViewCell
			firstCell?.startEditing()
			})
		})
	}
}

// MARK: - RevolutAPIDelegate

extension CurrencyListViewController: RevolutAPIDelegate {
	func didFinishFetchingCurrencies(_ newExchangeRates: ExchangeRates) {
		// Pass new exchange rates to the model
		currencies = currencyList.recalculate(exchangeRates: newExchangeRates).map { CurrencyViewModel(currency: $0) }
	}
}

// MARK: - UITextFieldDelegate

extension CurrencyListViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text else { return true }

		// Only allow a single decimal separator for the currency value
		let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
		let isDecimalSeparatorCountCorrect = (text.components(separatedBy: decimalSeparator).count - 1 + string.components(separatedBy: decimalSeparator).count - 1) <= 1

		let newLength = text.count + string.count - range.length

		// Limit currency value length
		return isDecimalSeparatorCountCorrect && (newLength <= 6 || newLength < text.count)
	}
}
