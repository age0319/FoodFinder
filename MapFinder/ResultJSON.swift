//
//  ResultJSON.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

struct Categorie:Codable {
    let name:String?
}


struct Location:Codable {
    let lat:Float
    let lng:Float
}

struct Venue: Codable{
    let name:String
    let location:Location
    let categories:[Categorie]?
}

struct Response: Codable {
    let venues:[Venue]
}

struct ResultJson: Codable{
    let response:Response
}


