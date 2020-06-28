//
//  ViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

protocol RestMapDelegate {
    func selectAnnotation(index:Int)
    func showMe(shop:Restaurant)
}

class MapVC: UIViewController, MKMapViewDelegate, FloatingPanelControllerDelegate,RestMapDelegate{
    
    @IBOutlet weak var dispMap: MKMapView!

    var fpc:FloatingPanelController!
    var currentLocation:CLLocation?
    var foodChoise = (code:String(),name:String())
    var restList = [Restaurant]()
    var annotations = [RestAnnotation]()
    
    func showMe(shop: Restaurant) {
        let regionDistance:CLLocationDistance = 1000
        let loc = shop.location.coordinate
        let coordinates = CLLocationCoordinate2DMake(loc.latitude, loc.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)

        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]

        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shop.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func selectAnnotation(index: Int) {
        dispMap.selectAnnotation(annotations[index], animated: true)
    }
    
    @IBAction func locationButton(_ sender: Any) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else { return }

            self.currentLocation = currentLocation
            dispMap.region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        }
    }
    
    // レストラン検索ボタンが押された時に呼ばれる
    @IBAction func searchButton(_ sender: Any) {
        
        if dispMap.annotations.count > 0{
            let allAnnotations = self.dispMap.annotations
            self.dispMap.removeAnnotations(allAnnotations)
        }
        
        if let now = currentLocation{
            let handler = NetworkGurunaviService()
            handler.searchAroundVenue(loc: now.coordinate, category: self.foodChoise, completion: {(restList) in
                
                if restList.count > 0 {
                    for rest in restList{
                        if let lat = Double(rest.latitude){
                            if let long = Double(rest.longitude){
                                let location = CLLocation(latitude: lat, longitude: long)
                                self.setRestPin(loc: location.coordinate, title: rest.name, rest: rest)
                            }
                        }
                    }
                    self.restList = self.calcDistance(restList: restList)
                    self.showSemiModal(restList: self.restList,storyBoardID: "all")
                    self.showToast(message: "「" + String(restList.count) + "」件見つかりました。", font: .systemFont(ofSize: 12.0))
                }else{
                    self.showToast(message: "お店は一件も見つかりませんでした。", font: .systemFont(ofSize: 12.0))
                }
            })
        }else{
            showToast(message: "位置情報を設定してください。", font: .systemFont(ofSize: 12.0))
        }
    }
    
    func calcDistance(restList:[Restaurant]) -> [Restaurant]{
        for rest in restList{
            rest.setDistance(loc: currentLocation!)
        }
        return restList
    }
    
    // viewのライフイベント
    override func viewDidLoad() {
        super.viewDidLoad()
        dispMap.delegate = self
     }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.dispMap.removeAnnotations(annotations)
        annotations.removeAll()
        removeSemiModal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let message:String
        if foodChoise.name .isEmpty{
            message = "カテゴリを選択してください。"
        }else{
            message = foodChoise.name + "を検索します。"
        }
    
        showToast(message: message, font: .systemFont(ofSize: 12.0))
    }
    
    func setRestPin(loc:CLLocationCoordinate2D,title:String,rest:Restaurant){
        let pin = RestAnnotation()
        pin.coordinate = loc
        pin.title = title
        pin.rest = rest
        annotations.append(pin)
        self.dispMap.addAnnotation(pin)
    }
    
    // ピンが選択された時に呼ばれる
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        removeSemiModal()
        if let annotation = view.annotation as? RestAnnotation {
            self.showSemiModal(restList: [annotation.rest],storyBoardID: "selected")
        }
        
    }
    
    //ピンが選択解除された時に呼ばれる
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeSemiModal()
        showSemiModal(restList: restList,storyBoardID: "all")
    }
    
    func showSemiModal(restList:[Restaurant],storyBoardID:String){
                           
        fpc = FloatingPanelController()
        
        fpc.delegate = self
           
        fpc.surfaceView.cornerRadius = 24.0
    
        if storyBoardID == "all"{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID) as? SemiModalVC else {
                return
            }
            vc.restList = restList
            vc.delegate = self
            fpc.set(contentViewController: vc)
        } else if storyBoardID == "selected"{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID) as? SelectedVC else {
                return
            }
            vc.delegate = self
            vc.shop = restList[0]
            fpc.set(contentViewController: vc)
        }
                           
        fpc.addPanel(toParent: self)
    }
    
    func removeSemiModal(){
        if fpc != nil {
            fpc.removePanelFromParent(animated: false)
        }
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
           return MyFloatingPanelLayout()
       }
}

