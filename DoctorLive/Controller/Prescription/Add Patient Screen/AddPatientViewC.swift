//
//  AddPatientViewC.swift
//  DoctorLive
//
//  Created by Kv on 06/11/24.
//

import UIKit
import DropDown

class AddPatientViewC: UIViewController {
    
    @IBOutlet weak var genderTxt, ageTxt, relationShipTxt, nameTxt: UITextField!
    @IBOutlet weak var genderVw, nameVw, ageVw, relationShipVw, bottomVw: UIView!
    @IBOutlet weak var addPatientBtn, cancelBtn: UIButton!
    
    var dropDown = DropDown()
    var viewmodel = ViewModel()
    var addPatientCallBack: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    private func setUpViews(){
        GlobalMethods.shared.provideThreeCornerRadius(view: self.bottomVw, cornerRadius: 20, cornerArray: [CORNER_DIRECTION_LEFT, CORNER_DIRECTION_RIGHT])
        GlobalMethods.shared.provideCornerRadius(view: self.cancelBtn, cornerRadius: 12, borderColor: UIColor.systemBlue.cgColor, borderWidth: 1)
        GlobalMethods.shared.provideCornerRadius(view: self.addPatientBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.nameVw, self.genderVw, self.ageVw, self.relationShipVw], cornerRadius: 12, borderColor: UIColor.lightGray.cgColor, borderWidth: 1)
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func genderBtn_Action(_ sender: Any) {
        dropDown.dataSource = ["Male".localized(),"Female".localized(),"Other".localized()]
        dropDown.anchorView = sender as? AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.genderTxt.text = item
        }
    }
    
    @IBAction func cancelBtn_Action(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addPatientBtn_Action(_ sender: Any) {
        guard self.nameTxt.text ?? EMPTY == EMPTY else {
            guard self.ageTxt.text ?? EMPTY == EMPTY else {
                guard self.genderTxt.text ?? EMPTY == EMPTY else {
                    guard self.relationShipTxt.text ?? EMPTY == EMPTY else {
//                        self.addMember()
                        return
                    }
                    self.showToast(message: "Please enter relationship")
                    return
                }
                self.showToast(message: "Please select gender")
                return
            }
            self.showToast(message: "Please enter age")
            return
        }
        self.showToast(message: "Please enter name")
        return
    }
    
}
