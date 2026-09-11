//
//  PrescriptionViewVC.swift
//  DoctorLive
//
//  Created by cst on 12/10/21.
//

import UIKit
import WebKit

protocol PrescriptionPdfData {
    func prescriptionPdf(_ prescriptionPdf: String)
}


class PrescriptionViewVC: UIViewController, WKNavigationDelegate {
    
    let downloadManager = DownloadManager()
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var downloadButton: UIButton!
    var urlString: String?
    var comeFromVideo = Bool()
    var comeFromChat = Bool()
    
    var delegate:PrescriptionPdfData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.isHidden = false
        downloadButton.layer.cornerRadius = 10
        webView.layer.backgroundColor = UIColor.white.cgColor
        self.webView.navigationDelegate = self
        if let url = URL(string: urlString ?? "") {
            webView.load(URLRequest(url: url))
            LoaderController.sharedInstance.showLoader(view: self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LoaderController.sharedInstance.removeLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoaderController.sharedInstance.removeLoader()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        if comeFromVideo == true {
//            let prescriptionUrl:[String: String] = ["pdf": self.urlString ?? ""]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: prescriptionUrl)
//            self.navigationController?.popViewController(animated: true)
//        } else if comeFromChat == true {
//            self.navigationController?.popViewController(animated: true)
//        } else{
//            let view = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = view.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
//            vc.isCameScreen = "ChatScreen"
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        if let urlStr = NSURL(string: urlString ?? "") {
                  let objectsToShare = urlStr
          [UIApplication.shared.openURL(objectsToShare as URL)]
         }
     }
 }


extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
