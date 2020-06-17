//
//  SettingVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/17.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class SettingVC: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
    
    private let dataSource = ["寿司","蕎麦","うどん","ラーメン","カレー","焼肉","ピザ"]
    
    var selected = ""
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    override func viewDidLoad() {
        pickerView.dataSource = self
        pickerView.delegate = self

        let hander = NetworkGurunaviService()
        hander.getCategory(completion:{(hoge) in
            print(hoge)
       })
    }
    
    
    
}
