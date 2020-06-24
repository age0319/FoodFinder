//
//  Utility.swift
//  MapFinder
//
//  Created by haru on 2020/06/17.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import MapKit

class Utility {
    
    var categoryList = [(code: "RSFST09000", name: "居酒屋"), (code: "RSFST02000", name: "日本料理・郷土料理"), (code: "RSFST03000", name: "すし・魚料理・シーフード"), (code: "RSFST04000", name: "鍋"), (code: "RSFST05000", name: "焼肉・ホルモン"), (code: "RSFST06000", name: "焼き鳥・肉料理・串料理"), (code: "RSFST01000", name: "和食"), (code: "RSFST07000", name: "お好み焼き・粉物"), (code: "RSFST08000", name: "ラーメン・麺料理"), (code: "RSFST14000", name: "中華"), (code: "RSFST11000", name: "イタリアン・フレンチ"), (code: "RSFST13000", name: "洋食"), (code: "RSFST12000", name: "欧米・各国料理"), (code: "RSFST16000", name: "カレー"), (code: "RSFST15000", name: "アジア・エスニック料理"), (code: "RSFST17000", name: "オーガニック・創作料理"), (code: "RSFST10000", name: "ダイニングバー・バー・ビアホール"), (code: "RSFST21000", name: "お酒"), (code: "RSFST18000", name: "カフェ・スイーツ"), (code: "RSFST19000", name: "宴会・カラオケ・エンターテイメント"), (code: "RSFST20000", name: "ファミレス・ファーストフード"), (code: "RSFST90000", name: "その他の料理")]
    
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

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
