//
//  DetailVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/22.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailVC: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: self.link){
            let request = URLRequest(url: url)
            self.webview.load(request)
        }
    }
}
