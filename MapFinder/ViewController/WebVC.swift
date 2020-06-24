//
//  WebVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/24.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class WebVC: UIViewController{
    var link:String!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: link){
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
