//
//  MapViewModel.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-08.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	var region = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 43.4690055847168, longitude: -79.69988250732422), // Default to Oakville
		span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
	)

	@Published var destination = Place(name: "Sheridan Oakville SugaRush", coordinate: CLLocationCoordinate2D(latitude: 43.4690055847168, longitude: -79.69988250732422)) // Sheridan

	private let locationManager = CLLocationManager()

	func checkLocationAuthorization() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			locationManager.startUpdatingLocation()
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			region.center = location.coordinate
		}
	}

	func openInMaps() {
		let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
		let mapItem = MKMapItem(placemark: destinationPlacemark)
		mapItem.name = destination.name
		mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}
}

struct Place: Identifiable {
	let id = UUID()
	let name: String
	let coordinate: CLLocationCoordinate2D
}
