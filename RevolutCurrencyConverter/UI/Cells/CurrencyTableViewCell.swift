//
//  CurrencyTableViewCell.swift
//  RevolutCurrencyConverter
//
//  Created by Nikolay Derkach on 12/20/18.
//  Copyright © 2018 Nikolay Derkach. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

	// MARK: - IB Outlets
	@IBOutlet weak var currencyImageView: UIImageView!
	@IBOutlet weak var currencyShortLabel: UILabel!
	@IBOutlet weak var currencyLongLabel: UILabel!
	@IBOutlet weak var currencyValueTextField: UITextField!
	@IBOutlet weak var currencyUnderlineView: UIView!
	@IBOutlet weak var underlineHeightConstraint: NSLayoutConstraint!

	@IBAction func valueChanged(_ sender: UITextField) {
		NotificationCenter.default.post(name: Notification.Name.Revolut.DidChangeBaseCurrencyValue, object: nil, userInfo: ["value": sender.text ?? ""])
	}

	var currencyViewModel: CurrencyViewModel! {
		didSet {
			currencyImageView.image = currencyViewModel.currencyImage
			currencyShortLabel.text = currencyViewModel.shortName
			currencyLongLabel.text = currencyViewModel.fullName
			currencyValueTextField.text = currencyViewModel.value
		}
	}

	// Is the cell designated to the current base currency?
	var isUpdating = false

	override func awakeFromNib() {
		super.awakeFromNib()

		currencyImageView.layer.cornerRadius = currencyImageView.bounds.height/2.0
		currencyImageView.layer.masksToBounds = true
		currencyImageView.layer.borderWidth = 1.0
		currencyImageView.layer.borderColor = UIColor.underlineInactiveColor.cgColor

		selectionStyle = .none
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		currencyImageView.image = nil
		currencyShortLabel.text = ""
		currencyLongLabel.text = ""
		currencyValueTextField.text = ""

		endEditing()
	}

	// MARK: - Responders

	func startEditing() {
		isUpdating = true
		currencyValueTextField.isUserInteractionEnabled = true
		currencyValueTextField.becomeFirstResponder()
		currencyUnderlineView.backgroundColor = .underlineActiveColor
		underlineHeightConstraint.constant = 2.0
		currencyUnderlineView.layoutIfNeeded()
	}

	func endEditing() {
		isUpdating = false
		currencyValueTextField.resignFirstResponder()
		currencyValueTextField.isUserInteractionEnabled = false
		currencyUnderlineView.backgroundColor = .underlineInactiveColor
		underlineHeightConstraint.constant = 1.0
		self.currencyUnderlineView.layoutIfNeeded()
	}
}
