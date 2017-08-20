//
//  webViewController.swift
//  ofoRide
//
//  Created by 🍋 on 2017/6/11.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let wkWebView = WKWebView(frame: self.view.frame)
//        wkWebView.autoresizingMask = [.flexibleHeight]
        self.view.addSubview(wkWebView)
        let url = URL(string: "http://m.ofo.so/active.html")
        let requert = URLRequest(url: url!)
        wkWebView.load(requert)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
