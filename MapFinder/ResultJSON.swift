//
//  ResultJSON.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

struct Categorie:Codable {
    let name:String
}

struct Location:Codable {
    let lat:Double
    let lng:Double
}

struct Venue:Codable {
    let name:String
    let location:Location
    let categories:[Categorie]
}

struct Item:Codable {
    let venue: Venue
}

struct Group: Codable{
    // Recommended Places
    let type:String
    let items:[Item]
}

struct Response: Codable {
    let query:String
    let totalResults:Int
    let groups:[Group]
}

struct ResultJson: Codable{
    let response:Response
}


