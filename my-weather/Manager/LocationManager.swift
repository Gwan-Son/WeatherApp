//
//  LocationManager.swift
//  my-weather
//
//  Created by 심관혁 on 8/28/24.
//

import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
    }
    
    func checkUserDeviceLocationServiceAuthorization() async {
        let authorizationStatus = locationManager.authorizationStatus
        
        if authorizationStatus == .authorizedAlways {
        }
        else if authorizationStatus == .authorizedWhenInUse {
        }
        else if authorizationStatus == .denied {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        else if authorizationStatus == .restricted || authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        stopUpdateLocation()
    }
    
    func sendLocation() -> [String] {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        return ["\(latitude!)","\(longitude!)"]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) async {
        await checkUserDeviceLocationServiceAuthorization()
    }
}
