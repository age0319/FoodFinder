//
//  ResultJSON.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

//Gurunavi Restaurant API

struct RestaurantJSON:Codable {
    let total_hit_count:Int
    let rest:[Rest]
}

struct Rest:Codable {
    let name:String
    let latitude:String
    let longitude:String
    let url:String
    let image_url:Image
    let opentime:String
    let access:Access
    let budget:Int
    
    let category:String
    let address:String
    let tel:String
    let holiday:String
    let pr:PR
    
    private enum CodingKeys : String, CodingKey {
        case name
        case latitude
        case longitude
        case url
        case image_url
        case opentime
        case access
        case budget
        case category
        case address
        case tel
        case holiday
        case pr
     }

     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(String.self, forKey: .latitude)
        self.longitude = try container.decode(String.self, forKey: .longitude)
        self.url = try container.decode(String.self, forKey: .url)
        self.image_url = try container.decode(Image.self, forKey: .image_url)
        self.opentime = try container.decode(String.self, forKey: .opentime)
        self.access = try container.decode(Access.self, forKey: .access)
        
        let budgetInt = try? container.decode(Int.self, forKey: .budget)
        let budgetString = try? container.decode(String.self, forKey: .budget)
        
        self.budget = budgetInt ?? (budgetString == "" ? 0 : 0)
        
        self.category = try container.decode(String.self, forKey: .category)
        self.address = try container.decode(String.self, forKey: .address)
        self.tel = try container.decode(String.self, forKey: .tel)
        self.holiday = try container.decode(String.self, forKey: .holiday)
        self.pr = try container.decode(PR.self, forKey: .pr)
     }
}

struct PR:Codable {
    let pr_short:String
    let pr_long:String
}

struct Image:Codable {
    let shop_image1:String
    let shop_image2:String
}

struct Access:Codable {
    let line:String
    let station:String
    let station_exit:String
    let walk:String
}

//Gurunavi Category API

struct CategoryJSON: Codable{
    let category_l:[Category]
}

struct Category: Codable{
    let category_l_code:String
    let category_l_name:String
}


