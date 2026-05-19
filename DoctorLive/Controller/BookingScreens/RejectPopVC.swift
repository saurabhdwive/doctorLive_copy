//
//  WrongEmailPopVC.swift
//  AfriPayChat
//  Created by Ashok kumar on 3/5/21.
//  Copyright © 2020 Apponward Technologies Pvt Ltd. All rights reserved.

import UIKit
import PromiseKit

class RejectPopVC: UIViewController , AnimationProviding , UITextViewDelegate{
   
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnAddExperience : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var subLableHeading: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    var bookingId: String?
    var navController: UINavigationController?
    var rejectCallBack: (() -> ())?
    
     @objc func superViewTapped(sender: UITapGestureRecognizer) {
         self.dismiss(animated: true, completion: nil)
     }
     override func viewDidLoad() {
        super.viewDidLoad()
        popView.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C1E26").withAlphaComponent(0.62)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        view.addGestureRecognizer(tapGesture)
        textView.text = "Please write here..."
        textView.textColor = UIColor.lightGray
        mainView.dropShadow(scale: true)
        GlobalMethods.shared.provideCornerRadius(view: self.textView, cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 1)
//        textView.text.borderWidth = 1
//        textView.borderColor = .gray
        textView.delegate = self
        textView.layer.cornerRadius = 6
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "TextColour")
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if textView.text == "" || textView.text == "Please write here..." {
            AppToast.showMessage(message: "Please Provide Reason For Reject".localized())
        } else {
            performRejectBooking()
        }
     }
  }

extension RejectPopVC {
    func confirmBooking(param: [String: String]){
        firstly {
            service!.bookingStatus(parameters: param, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.confirmBoking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performRejectBooking() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": "\(bookingId ?? "")",
                     "status": "2",
                     "reason": textView.text]
        confirmBooking(param: parameter)
    }
    
    func confirmBoking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
            self.rejectCallBack!()
            self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
