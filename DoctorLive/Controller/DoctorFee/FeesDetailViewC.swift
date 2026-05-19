//
//  FeesDetailViewC.swift
//  DoctorLive
//
//  Created by Kv on 16/09/24.
//

import UIKit

class FeesDetailViewC: UIViewController {
    
    @IBOutlet weak var patientFeeTxt, vatFeeTxt, followUpPatientFeesTxt, followUpVatFeesTxt: UITextField!
    @IBOutlet weak var videoFeesVw, patientFeesVw, vatFeesVw, followUpVw, followUpPatientFeesVw, followUpVatFeesVw, followUpFeesVw, videoBottomVw, followUpBottomVw: UIView!
    @IBOutlet weak var videoPriceLbl, followUpPriceLbl: UILabel!
    @IBOutlet weak var followUpBtn, updateBtn: UIButton!
    
    var status: Bool = true
    var feesDetailData: FeesDetailData?
    var delegate: FeesDetailProtocol?
    var callPercentage = 0
    var followUpPercentage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setUpFeesDetailData()
    }
    
    private func setupView(){
        self.followUpVw.isHidden = true
        self.patientFeeTxt.delegate = self
        self.followUpPatientFeesTxt.delegate = self
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.patientFeesVw, self.vatFeesVw, self.followUpPatientFeesVw, self.followUpVatFeesVw, self.updateBtn], cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 0.5)
        GlobalMethods.shared.provideShadowMultipleView(vw: [self.videoFeesVw, self.followUpFeesVw], shadowColor: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width: -5, height: 5), shadowRadius: 12)
        GlobalMethods.shared.provideThreeCornerRadius(view: self.videoBottomVw, cornerRadius: 12, cornerArray: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        GlobalMethods.shared.provideThreeCornerRadius(view: self.followUpBottomVw, cornerRadius: 12, cornerArray: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followUpCheckBtn_Action(_ sender: Any) {
        guard self.status else {
            self.status = true
            self.followUpVw.isHidden = true
            self.followUpBtn.setImage(UIImage(named: "Rectangle 676"), for: .normal)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            return
        }
        self.status = false
        self.followUpVw.isHidden = false
        self.followUpBtn.setImage(UIImage(named: "checked"), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func updateBtn_Action(_ sender: Any) {
        guard self.patientFeeTxt.text ?? EMPTY == EMPTY else {
            guard self.followUpPatientFeesTxt.text ?? EMPTY == EMPTY else {
                self.editDrFee()
                return
            }
            self.showToast(message: "Please enter follow Up fees")
            return
        }
        self.showToast(message: "Please enter video call fees")
        return
    }
}

extension FeesDetailViewC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let callPercentage = Float(self.feesDetailData?.callPercentage ?? EMPTY) ?? Float(0)
        let followUpPercentage = Float(self.feesDetailData?.followUpPercentage ?? EMPTY) ?? Float(0)
        if textField == self.patientFeeTxt {
            var textFieldData = String()
            if string == "" {
                if self.patientFeeTxt.text ??  EMPTY != EMPTY {
                    textFieldData = String((self.patientFeeTxt.text ??  EMPTY).dropLast())
                }
            }else{
                textFieldData = String((self.patientFeeTxt.text ??  EMPTY) + string)
            }
            if callPercentage == Float(0){
                self.vatFeeTxt.text = textFieldData
            }else{
                let videoPrice = Float(textFieldData) ?? Float(0)
                let finalPrice = (videoPrice * callPercentage) / 100.0
                self.vatFeeTxt.text = String(Int(videoPrice - finalPrice))
            }
        }else{
            var textFieldData = String()
            if string == "" {
                if self.followUpPatientFeesTxt.text ??  EMPTY != EMPTY {
                    textFieldData = String((self.followUpPatientFeesTxt.text ??  EMPTY).dropLast())
                }
            }else{
                textFieldData = String((self.followUpPatientFeesTxt.text ??  EMPTY) + string)
            }
            if followUpPercentage == Float(0){
                self.followUpVatFeesTxt.text = textFieldData
            }else{
                let followPrice = Float(textFieldData) ?? Float(0)
                let finalPrice = (followPrice * followUpPercentage) / 100.0
                self.followUpVatFeesTxt.text = String(Int(followPrice - finalPrice))
            }
        }
        return true
    }
}

protocol FeesDetailProtocol {
    func feesDetailProtocol()
}
