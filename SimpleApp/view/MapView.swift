//
//  MapView.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 19.01.2021.
//

import MapKit

class MapView: MKMapView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let compassView = subviews.filter({ $0.isKind(of: NSClassFromString("MKCompassView")!) }).first {
            compassView.frame = CGRect(x: 16, y: 40, width: 40, height:40)
            
    }
    
    
}
}
