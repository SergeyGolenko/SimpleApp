//
//  POIMarkerAnnotationView.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 21.01.2021.
//

import MapKit

class POIMarkerAnnotationView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation? {
        willSet {
            guard let poi = newValue as? POI else { return }
            
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            
            if let poiImage = UIImage(named: "poi-\(poi.poiType.rawValue)"), let pinImage = UIImage(named: "\(poi.poiType.rawValue)") {
                button.setBackgroundImage(poiImage, for: .normal)
                glyphImage = pinImage
            }
            
           clusteringIdentifier = "cluster"
            canShowCallout = true
            markerTintColor = poi.tintColor
            leftCalloutAccessoryView = button
            
            let addressLabel = UILabel()
            addressLabel.numberOfLines = 0
            addressLabel.text = poi.subtitle
            addressLabel.font = UIFont.systemFont(ofSize: 12)
            
            detailCalloutAccessoryView = addressLabel
        }
    }
    
}
