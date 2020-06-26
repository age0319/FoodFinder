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
    func showRoute(dest:CLLocation)
    func showMe(shop:Restaurant)
}

class MapVC: UIViewController, MKMapViewDelegate, FloatingPanelControllerDelegate,RestMapDelegate{
    
    @IBOutlet weak var dispMap: MKMapView!

    var fpc:FloatingPanelController!
    var currentLocation = CLLocation()
    var foodChoise = (String(),String())
    var restList = [Restaurant]()
    var annotations = [RestAnnotation]()
    var route:MKRoute!
    
    func showRoute(dest: CLLocation) {
        let sourcePlaceMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: dest.coordinate)
          
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
        guard let directionResonse = response else {
            if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
            }
                return
            }
            let route = directionResonse.routes[0]
            self.route = route
            self.dispMap.addOverlay(route.polyline, level: .aboveRoads)
            let time = route.expectedTravelTime / 60
            self.showToast(message: "所要時間は「" + String(time.rounded()) + "」分です。", font: .systemFont(ofSize: 12.0))
           }
    }
    
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
        
        let allAnnotations = self.dispMap.annotations
        self.dispMap.removeAnnotations(allAnnotations)
        
        let handler = NetworkGurunaviService()
        handler.searchAroundVenue(loc: self.currentLocation.coordinate, category: self.foodChoise, completion: {(restList) in
            
            for rest in restList{
                let lat = Double(rest.latitude)
                let long = Double(rest.longitude)
                let location = CLLocation(latitude: lat!, longitude: long!)
                self.setRestPin(loc: location.coordinate, title: rest.name, rest: rest)
            }
            self.restList = self.calcDistance(restList: restList)
            self.showSemiModal(restList: self.restList,storyBoardID: "all")
            self.showToast(message: "「" + String(restList.count) + "」件見つかりました。", font: .systemFont(ofSize: 12.0))
        })
    }
    
    func calcDistance(restList:[Restaurant]) -> [Restaurant]{
        for rest in restList{
            rest.setDistance(loc: currentLocation)
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
        removeSemiModal()
        annotations.removeAll()
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
        if self.route != nil{
            self.dispMap.removeOverlay(self.route.polyline)
        }
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

