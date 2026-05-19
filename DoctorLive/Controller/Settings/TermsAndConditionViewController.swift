//
//  TermsAndConditionViewController.swift
//  Health+
//
//  Created by Vivek on 16/09/20.
//  Copyright © 2020 Apponward. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionViewController: UIViewController, WKNavigationDelegate {
    var titleTxt: String?
    @IBOutlet weak var webkit: WKWebView!
    @IBOutlet weak var titleLable: UILabel!
    var text: String?
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = self.titleTxt
        self.webkit.navigationDelegate = self
        webkit.isOpaque = false
        webkit.backgroundColor = UIColor.clear
        if let url = URL(string: urlString ?? "") {
            webkit.load(URLRequest(url: url))
            LoaderController.sharedInstance.showLoader(view: self.view)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LoaderController.sharedInstance.removeLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoaderController.sharedInstance.removeLoader()
    }
    
}
