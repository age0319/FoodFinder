//
//  Utility.swift
//  MapFinder
//
//  Created by haru on 2020/06/17.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import MapKit

class Utility {
    func coordinateToString(loc:CLLocationCoordinate2D) -> String{
        return String(loc.latitude)+","+String(loc.longitude)
    }

    func doubleToCoordinate(lat:Double,lng:Double) -> CLLocationCoordinate2D{
        var loc = CLLocationCoordinate2D()
        loc.latitude = lat
        loc.longitude = lng
        return loc
    }
}
