//
//  LocationManager.swift
//  my-weather
//
//  Created by 심관혁 on 8/28/24.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
//    func requestLocation() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    func startUpdateLocation() {
//        locationManager.startUpdatingLocation()
//    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
    }
    
    func sendLocation() -> [String] {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        return ["\(latitude!)","\(longitude!)"]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
