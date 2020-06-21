//
//  ResultJSON.swift
//  MapFinder
//
//  Created by haru on 2020/06/21.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

// FourSquareAPI

struct ResultJson: Codable{
    let response:Response
}

struct Response: Codable {
    let query:String
    let totalResults:Int
    let groups:[Group]
}

struct Group: Codable{
    // Recommended Places
    let type:String
    let items:[Item]
}

struct Item:Codable {
    let venue: Venue
}
struct Venue:Codable {
    let name:String
    let location:Location
    let categories:[Categorie]
}

struct Location:Codable {
    let lat:Double
    let lng:Double
}

struct Categorie:Codable {
    let name:String
}
