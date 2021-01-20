//
//  POI.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 20.01.2021.
//
import MapKit

enum POIType: String {
    case restaurant, starbucks
}

class POI: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let poiType: POIType
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D, poiType: POIType) {
        self.title = title
        self.subtitle = address
        self.coordinate = coordinate
        self.poiType = poiType
        
        super.init()
    }
}

