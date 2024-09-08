//
//  CurrentCityPresenter.swift
//  CurrentCity
//
//  Created by Denis on 07.09.2024.
//

import UIKit

protocol ICurrentCityPresenter: AnyObject {
	func getLocation()
}

final class CurrentCityPresenter {
	private var locationService: ILocationService
	private var locationObserver: NSObjectProtocol?
	weak var view: ICurrentCityView?
	
	init(locationService: ILocationService, view: ICurrentCityView) {
		self.locationService = locationService
		self.view = view
		view.updateLabel(with: makePlaceString())
		locationObserver = NotificationCenter.default.addObserver(
			forName: .locationDidUpdated,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				if let self {
					view.updateLabel(with: makePlaceString())
				}
			}
		)
	}
	
	private func makePlaceString() -> NSMutableAttributedString {
		var attributedText = NSMutableAttributedString(string: "")
		
		if let icon = UIImage(systemName: "location.fill") {
			let textAttachment = NSTextAttachment(image: icon)
			attributedText = NSMutableAttributedString(attachment: textAttachment)
		}
		
		if 
			let currentCity = locationService.currentCity,
			let currentCountry = locationService.currentCountry
		{
			attributedText.append(.init(string: "\(currentCity), \(currentCountry)"))
			return attributedText
		} else if let currentOcean = locationService.currentOcean {
			attributedText.append(.init(string: currentOcean))
			return attributedText
		}
		attributedText.append(.init(string: "Loading..."))
		return attributedText
	}
}

extension CurrentCityPresenter: ICurrentCityPresenter {
	func getLocation() {
		locationService.getLocation()
	}
}
