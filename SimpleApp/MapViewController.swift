//
//  ViewController.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 19.01.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var mapView: MapView!
    private let locationService = LocationService()
    
    
    //MARK: - Action
    @IBAction func didTapUserLocation(_ sender: Any) {
        centerToUSerLocation()
    }
    
    //MARK: - Private Function
    private func centerToUSerLocation(){
        let mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    
    
    // alert controller
    private lazy var locationAlert: UIAlertController = {
        let alertController = UIAlertController(title: "Location Authorization", message: "Quest can provide the points of interest based on your current location. To change the location permission please update your Privacy setting.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let settingAction = UIAlertAction(title: "Update Setting", style: .default, handler: { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alertController.addAction(okAction)
        alertController.addAction(settingAction)
        
        return alertController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        mapView.delegate = self
        controlView.layer.cornerRadius = 8
        mapView.showsCompass = true
         
    }
}

// MARK: LocationServiceDelegate

extension MapViewController: LocationServiceDelegate {
    
    
    func setMapRegion(center: CLLocation) {
        let mapRegion = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        DispatchQueue.main.async { [weak self] in
            self!.mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    func authorizationDenied() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.present(weakSelf.locationAlert, animated: true, completion: nil)
        }
    }
    
    
}
