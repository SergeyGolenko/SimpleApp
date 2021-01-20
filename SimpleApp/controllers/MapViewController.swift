//
//  ViewController.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 19.01.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    //MARK: - Property
    // Это enum (для выбора ресторана или кофейни)
    private var poiType : POIType?
    //Это класс который наследуется от MKAnnotation, с дополнительными свойствами poiType
    private var pois = [POI]()
    
    //Экземпляр класса для отслеживания маркера
    private let locationService = LocationService()
    //Сохраняет местоположение маркера, нужно для отслеживания изменения
    var mapCenterLocation: CLLocation?
    
    //MARK: - Outlet
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: MapView!
    
    //MARK: - Action
    //Присваивает переменной poiType значение для поиска. Потом запускает функцию searchPoi
    @IBAction func didTapPoiButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            poiType = .restaurant
            print("restaurant")
        case 1:
            poiType = .starbucks
            print("coffee")
        default:
        break
        }
        searchPOI()
    }
    
    @IBAction func didTapUserLocation(_ sender: Any) {
        //центрирует по отношению к положению маркера
        centerToUSerLocation()
    }
    
    @IBAction func didTapCloseSlideView(_ sender: Any) {
        searchView(shown: false)
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        searchView(shown: true)
    }
    
    //Меняет вид карты
    @IBAction func didTapMapButton(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .hybridFlyover
        } else {
            mapView.mapType = .standard
        }
    }
    
    //MARK: - Private Function
    // Эта функция подтягивает(центрирует) вид карты по отношению к маркеру
    private func centerToUSerLocation(){
        let mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: true)
    }
    
    // Показывает или скрывает searchView
    private func searchView(shown: Bool) {
        UIView.animate(withDuration: 3) { [weak self] in
            guard let weakSelf = self else { return }
            
            let viewHeight = weakSelf.searchView.frame.size.height
            
            weakSelf.searchViewTopConstraint.constant = shown
                ? -1 * viewHeight
                : 0 + 200
            weakSelf.view.layoutIfNeeded()
        }
    }
    
    
    private func searchPOI(){
        guard let poiType = poiType else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchService.poiSearch(for: poiType, around: mapView.centerCoordinate) {[weak self] (mapItems) in
        self?.updateSearchResult(with: mapItems)
        }
    }
    
    private func updateSearchResult(with mapItems: [MKMapItem]) {
        pois.removeAll()
        
        for mapItem in mapItems {
            if let name = mapItem.name, let address = mapItem.placemark.formattedAddresS, let poiType = poiType {
                let poi = POI(title: name, address: address, coordinate: mapItem.placemark.coordinate, poiType: poiType)
                pois.append(poi)
            }
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(pois)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
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
    
// MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        mapView.delegate = self
        controlView.layer.cornerRadius = 8
        mapView.showsCompass = true
        searchView.layer.cornerRadius = 20.0
        mapCenterLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
    }
}

// MARK: LocationServiceDelegate

extension MapViewController: LocationServiceDelegate {
    
    
    func setMapRegion(center: CLLocation) {
        let mapRegion = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
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

// MARK: -TableViewDataSource and Delegate

extension MapViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellResult", for: indexPath)
        let poi = pois[indexPath.row]
        cell.textLabel?.text = poi.title
        cell.detailTextLabel?.text = poi.subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if let poiType = poiType {
            let newCenterLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            if let prevMapCenterLocation = mapCenterLocation {
                // Refresh the POI search if center moves 500 m from previous center
                if newCenterLocation.distance(from: prevMapCenterLocation) > 500{
                    mapCenterLocation = newCenterLocation
                    searchPOI()
                }
            }
        }
    }
}

