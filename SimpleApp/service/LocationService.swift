//
//  LocationService.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 19.01.2021.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func authorizationDenied()
    func setMapRegion(center:CLLocation)
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
           nowStartUpdatingLocation()
        default:
            break
        }
    }
    
    private func nowStartUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       locationManager.stopUpdatingLocation()
        let locationM = locations.last
        delegate?.setMapRegion(center: locationM!)
      
    }
}
