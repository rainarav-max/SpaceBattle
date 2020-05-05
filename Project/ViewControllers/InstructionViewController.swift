//
//  InstructionViewController.swift
//  Project


import UIKit
import WebKit

class InstructionViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet var wbPage: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!

    
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            activity.isHidden = false
            activity.startAnimating()
        }
        
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            activity.isHidden = true
            activity.stopAnimating()
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let urlAddress = URL(string: "http://closetosuccess.com/iosproject/")
            let url = URLRequest(url: urlAddress!)
            wbPage.load(url)
            wbPage.navigationDelegate = self
        }
    

  

}
