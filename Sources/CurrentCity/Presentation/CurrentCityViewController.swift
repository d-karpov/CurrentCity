//
//  CurrentCityViewController.swift
//  CurrentCity
//
//  Created by Denis on 06.09.2024.
//

import UIKit

protocol ICurrentCityView: AnyObject {
	func updateLabel(with text: NSMutableAttributedString)
}

final class CurrentCityViewController: UIViewController {
	var presenter: ICurrentCityPresenter?
	private let label = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .lightGray
		setUpLabel()
		presenter?.getLocation()
	}
	
	private func setUpLabel() {
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		NSLayoutConstraint.activate(
			[
				label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			]
		)
	}
}

extension CurrentCityViewController: ICurrentCityView {
	func updateLabel(with text: NSMutableAttributedString) {
		label.attributedText = text
	}
}
