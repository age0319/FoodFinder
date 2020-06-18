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
    
    var categoryList:[(code:String, name:String)] = []
    @IBOutlet weak var pickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//        let sec = self.tabBarController?.viewControllers![0] as! ViewController
//        sec.foodChoise = categoryList[row]
        
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! ViewController
        vc.foodChoise = categoryList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
    }
    
    override func viewDidLoad() {
        pickerView.dataSource = self
        pickerView.delegate = self

        let hander = NetworkGurunaviService()
        hander.getCategory(completion:{(category) in
            self.categoryList = category
            self.pickerView.reloadAllComponents()
       })
    }
    
    
    
}
