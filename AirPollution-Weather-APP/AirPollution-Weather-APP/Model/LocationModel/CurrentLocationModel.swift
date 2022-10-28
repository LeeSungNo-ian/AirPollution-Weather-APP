//
//  CurrentLocationModel.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/28.
//

import Foundation
import CoreLocation

class CurrentLocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = CurrentLocationModel()
    var locationManager = CLLocationManager()
    
    @Published var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0
    
    @Published var currentLocationCity: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        requestGPSPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let findLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let geocoder = CLGeocoder()
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            let locale = Locale(identifier: "Ko-kr")
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [weak self] (place, error) in
                if let address: [CLPlacemark] = place {
                    let locality = "\(address.last?.locality ?? "")"
                    let subLocality = "\(address.last?.subLocality ?? "")"
                    self!.currentLocationCity = "\(locality) \(subLocality)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
    
    func requestGPSPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        case .denied:
            print("GPS: 권한 없음")
        default:
            print("GPS: Default")
        }
    }
}

