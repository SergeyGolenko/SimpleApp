//
//  LocationService.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 19.01.2021.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func authorizationDenied()
}



class LocationService: NSObject{
    
    var locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkAuthorizationStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            delegate?.authorizationDenied()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
