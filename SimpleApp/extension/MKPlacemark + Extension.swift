//
//  MKPlacemark + Extension.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 20.01.2021.
//

import MapKit

extension MKPlacemark {
    var formattedAddresS: String? {
        guard
            let streetNumber = subThoroughfare,
            let streetName = thoroughfare,
            let city = locality,
            let state = administrativeArea,
            let zip = postalCode
        else {
            if let title = title {
                return "\(title)"
            }
            else {
                return nil
            }
        }
        
        let address = "\(streetNumber) \(streetName), \(city), \(state) \(zip)"
        return address
    }
}
