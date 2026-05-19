//
//  FeesDetailViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 16/09/24.
//

import Foundation
import PromiseKit
import UIKit

extension FeesDetailViewC {
    func drFeeEdit(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.drFeeUpdate(parameters: param, header: "DeviceToken")
        }.done { (model: DRFeeModel) in
            self.handleeditFee(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func editDrFee() {
        var parameter = [String: String]()
        guard let id = UserDefaults.standard.string(forKey: Constants.userId) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["doctor_id": id,
                     "call": "1",
                     "call_fees": self.patientFeeTxt.text ?? "",
                     "visit_fees": "0",
                     "visit": "0",
                     "followup_fees": self.followUpPatientFeesTxt.text ?? "",
                     "language_type": code]
        self.drFeeEdit(param: parameter)
    }
    
    func handleeditFee(model: DRFeeModel) {
        if model.status == "SUCCESS" {
            self.delegate?.feesDetailProtocol()
            self.navigationController?.popViewController(animated: true)
            LoaderController.sharedInstance.removeLoader()
        } else {
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
