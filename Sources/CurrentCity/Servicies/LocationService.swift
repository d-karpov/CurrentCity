//
//  LocationService.swift
//  CurrentCity
//
//  Created by Denis on 04.09.2024.
//

import CoreLocation
import UIKit

protocol ILocationService: AnyObject {
	var currentCity: String? { get }
	var currentCountry: String? { get }
	var currentOcean: String? { get }
	func getLocation()
}

enum LocationServiceErrors: Error, LocalizedError {
	case noLocation, notAllowed, noPlaceMark
	
	var errorDescription: String? {
		switch self {
		case .noLocation:
			return "Error while getting current location"
		case .notAllowed:
			return "Location tracking aren't allowed"
		case .noPlaceMark:
			return "Error during PlaceMark creation"
		}
	}
}

final class LocationService: NSObject, ILocationService, CLLocationManagerDelegate {
	private let locationManager = CLLocationManager()
	private var currentLocation: Result<CLLocation, LocationServiceErrors>?
	var currentCity: String?
	var currentCountry: String?
	var currentOcean: String?
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.distanceFilter = 1500
		locationManager.startUpdatingLocation()
	}
	
	func getLocation() {
		if let location = locationManager.location {
			currentLocation = .success(location)
		}
	}
	
	private func getCurrentPlace() {
		if let currentLocation {
			switch currentLocation {
			case .success(let location):
				CLGeocoder().reverseGeocodeLocation(location) { [weak self] placeMarks, error in
					if let error {
						NSLog(error.localizedDescription)
					}
					if let self, let placeMark = placeMarks?.first {
						currentOcean = placeMark.ocean
						currentCity = placeMark.locality
						currentCountry = placeMark.country
						NotificationCenter.default.post(name: .locationDidUpdated, object: self)
					}
				}
			case .failure(let error):
				NSLog(error.localizedDescription)
			}
		}
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch locationManager.authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse: getLocation()
		case .denied, .restricted: currentLocation = .failure(.notAllowed)
		case .notDetermined: NSLog("Not determined LocationManagerAuth State - Auth were requested")
		@unknown default: NSLog("Not determined error from LocationService")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		getLocation()
		getCurrentPlace()
	}
	
}
