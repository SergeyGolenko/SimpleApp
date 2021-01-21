//
//  POIClusterAnnotationView.swift
//  SimpleApp
//
//  Created by Сергей Голенко on 21.01.2021.
//

import MapKit
    
    class POIClusterAnnotationView: MKAnnotationView {
        override var annotation: MKAnnotation? {
            willSet {
                if let cluster = newValue as? MKClusterAnnotation {
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                    let count = cluster.memberAnnotations.count
                    
                    if let poi = cluster.memberAnnotations.first as? POI {
                        image = renderer.image(actions: { (_) in
                            poi.tintColor.setFill()
                            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                            
                            UIColor.white.setFill()
                            UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 30, height: 30)).fill()
                            
                            let attributes = [
                                NSAttributedString.Key.foregroundColor: poi.tintColor,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
                            ]
                            
                            let text = "\(count)"
                            let size = text.size(withAttributes: attributes)
                            let rect = CGRect(x: 20-size.width/2, y: 20-size.height/2, width: size.width, height: size.height)
                            text.draw(in: rect, withAttributes: attributes)
                        })
                    }
                }
            }
        }
    }
