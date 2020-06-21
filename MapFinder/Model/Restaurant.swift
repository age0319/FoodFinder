//
//  Restaurant.swift
//  MapFinder
//
//  Created by haru on 2020/06/21.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

// for save to Restaurant API Result
class Restaurant {
    var name:String
    var latitude:String
    var longitude:String
    var url:String
    var image_url:ImageClass
    var opentime:String
    var access:AccessClass
    var budget:Int
    
    init() {
        self.name = String()
        self.latitude = String()
        self.longitude = String()
        self.url = String()
        self.image_url = ImageClass()
        self.opentime = String()
        self.access = AccessClass()
        self.budget = Int()
    }
    
    func set(name:String,latitude:String,longitude:String,url:String,image_url:ImageClass,opentime:String,access:AccessClass,budget:Int){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.image_url = image_url
        self.opentime = opentime
        self.access = access
        self.budget = budget
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
