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
import FloatingPanel

class SettingVC: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
    
    var categoryList:[(code:String, name:String)] = []
    @IBOutlet weak var pickerView: UIPickerView!
    var navController = UINavigationController()
    var mapvc = MapVC()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mapvc.foodChoise = categoryList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
    }
    
    override func viewDidLoad() {
        pickerView.dataSource = self
        pickerView.delegate = self
        categoryList = Utility().categoryList
        navController = tabBarController?.viewControllers![2] as! UINavigationController
        mapvc = navController.topViewController as! MapVC
        mapvc.foodChoise = categoryList[0]
    }    
    
}

