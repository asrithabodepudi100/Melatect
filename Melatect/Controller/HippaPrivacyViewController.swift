//
//  HippaPrivacyViewController.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 2/5/21.
//

import UIKit
import WebKit

class HippaPrivacyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate{
    @IBOutlet weak var webView: WKWebView!
   
    var requestUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        let url = URL(string: "https://tnlrtechnologies.com/legal.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
