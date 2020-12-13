//
//  DNAnnotation.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

import MapKit

final class DNAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}
