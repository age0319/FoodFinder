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
    
    var fpc: FloatingPanelController!
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
        navController = tabBarController?.viewControllers![1] as! UINavigationController
        mapvc = navController.topViewController as! MapVC
        mapvc.foodChoise = categoryList[0]
        
        fpc = FloatingPanelController()
        
        fpc.delegate = self
        
        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
        let semiModalViewController = SemiModalVC()
        fpc.set(contentViewController: semiModalViewController)
                
        // セミモーダルビューを表示する
        fpc.addPanel(toParent: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セミモーダルビューを非表示にする
        fpc.removePanelFromParent(animated: true)
        
    }
    
    
}

// MARK: - FloatingPanel Delegate
extension SettingVC: FloatingPanelControllerDelegate {
   
   // カスタマイズしたレイアウトに変更
   func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
       return CustomFloatingPanelLayout()
   }
}

// MARK: - FloatingPanel Layout
class CustomFloatingPanelLayout: FloatingPanelLayout {
   
   // 初期位置
   var initialPosition: FloatingPanelPosition {
        return .tip
   }
   
   // カスタマイズした高さ
   func insetFor(position: FloatingPanelPosition) -> CGFloat? {
       switch position {
       case .full: return 16.0
       case .half: return 216.0
       case .tip: return 44.0
       default: return nil
       }
   }
   
   // サポートする位置
   var supportedPositions: Set<FloatingPanelPosition> {
    return [.tip,.half]
   }
}
