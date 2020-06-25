//
//  Restaurant.swift
//  MapFinder
//
//  Created by haru on 2020/06/21.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import MapKit

// for save to Restaurant API Result
class Restaurant {
    var id:Int
    var name:String
    var latitude:String
    var longitude:String
    var url:String
    var image_url:ImageClass
    var opentime:String
    var access:AccessClass
    var budget:Int
    var location:CLLocation
    var distance:Double
    
    var category:String
    var address:String
    var tel:String
    var holiday:String
    var pr:PRClass
    
    init() {
        self.id = Int()
        self.name = String()
        self.latitude = String()
        self.longitude = String()
        self.url = String()
        self.image_url = ImageClass()
        self.opentime = String()
        self.access = AccessClass()
        self.budget = Int()
        self.location = CLLocation()
        self.distance = Double()
        
        self.category = String()
        self.address = String()
        self.tel = String()
        self.holiday = String()
        self.pr = PRClass()
    }
    
    func set(id:Int,name:String,latitude:String,longitude:String,url:String,image_url:ImageClass,opentime:String,access:AccessClass,budget:Int,category:String,address:String,tel:String,holiday:String,pr:PRClass){
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.image_url = image_url
        self.opentime = opentime
        self.access = access
        self.budget = budget
        
        if let lat = Double(latitude){
            if let lon = Double(longitude){
                self.location = CLLocation(latitude: lat, longitude: lon)
            }
        }
        
        self.category = category
        self.address = address
        self.holiday = holiday
        self.pr = pr
        
    }
    
    func setDistance(loc:CLLocation){       
        self.distance = loc.distance(from: self.location)
        self.distance.round()
    }
}

class PRClass {
    var pr_short:String
    var pr_long:String
    
    init(){
        self.pr_short = String()
        self.pr_long = String()
    }
}

class ImageClass {
    var shop_image1:String
    var shop_image2:String
    
    init() {
        self.shop_image1 = String()
        self.shop_image2 = String()
    }
}

class AccessClass {
    var line:String
    var station:String
    var station_exit:String
    var walk:String
    
    init() {
        self.line = String()
        self.station = String()
        self.station_exit = String()
        self.walk = String()
    }
}
