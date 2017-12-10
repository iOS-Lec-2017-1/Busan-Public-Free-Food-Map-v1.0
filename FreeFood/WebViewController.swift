//
//  WebViewController.swift
//  FreeFood
//
//  Created by 김종현 on 2017. 12. 4..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webView.uiDelegate = self as WKUIDelegate
        self.webView.navigationDelegate = self as WKNavigationDelegate
        
        let myURL = URL(string: "https://youtu.be/R8ijnUJY-2Q")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
     
    }
    */
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self as WKUIDelegate
//        self.webView.navigationDelegate = self as WKNavigationDelegate
        
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self as WKNavigationDelegate
        
        let myURL = URL(string: "https://youtu.be/R8ijnUJY-2Q")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //indicator.hidesWhenStopped = false
        //indicator.startAnimating()
        print("1")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        indicator.hidesWhenStopped = true
//        indicator.stopAnimating()
        print("2")
    }
    /*
     override func loadView() {
     let webConfiguration = WKWebViewConfiguration()
     webView = WKWebView(frame: .zero, configuration: webConfiguration)
     webView.uiDelegate = self
     view = webView
     }
     override func viewDidLoad() {
     super.viewDidLoad()
 
     let myURL = URL(string: "https://www.apple.com")
     let myRequest = URLRequest(url: myURL!)
     webView.load(myRequest)
     }}
     */
}


