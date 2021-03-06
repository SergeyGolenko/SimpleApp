//
//  POI.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 20.01.2021.
//
import MapKit

enum POIType: String {
    case restaurant,coffee,pin
}

class POI: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let poiType: POIType
    
    
    var tintColor: UIColor {
        switch poiType {
        case .restaurant:
            return .orange
        case .coffee:
            return .init(red: 51/255, green: 131/255, blue: 51/255, alpha: 1.0)
        case .pin:
            return .black
        }
    }
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D, poiType: POIType) {
        self.title = title
        self.subtitle = address
        self.coordinate = coordinate
        self.poiType = poiType
        
        super.init()
    }
}

