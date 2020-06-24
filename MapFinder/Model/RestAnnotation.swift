//
//  RestAnnotation.swift
//  MapFinder
//
//  Created by haru on 2020/06/24.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import MapKit

class RestAnnotation: NSObject,MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var rest:Restaurant
    
    override init(){
        self.title = String()
        self.coordinate = CLLocationCoordinate2D()
        self.rest = Restaurant()
    }
}
