//
//  PublicMethods.swift
//  CurrentCity
//
//  Created by Denis on 07.09.2024.
//

import UIKit

public final class CurrentCity {
	
	public static let icon: UIImage? = UIImage(systemName: "location.fill")
	public static let appName: String = "CurrentCity"
	
	public static func assembly() -> UIViewController {
		let view = CurrentCityViewController()
		let presenter = CurrentCityPresenter(
			locationService: LocationService(),
			view: view
		)
		view.presenter = presenter
		return view
	}
}
