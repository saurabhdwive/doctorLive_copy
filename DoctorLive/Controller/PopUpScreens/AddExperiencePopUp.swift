//
//  AddExperiencePopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit

protocol updateExpiernceDelegateProtocol {
    func updateExperience()
}

class AddExperiencePopUp: ParentViewController, AnimationProviding {
   
    var addExperienceCallBack: (() -> ())?
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnAddExperience : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var txtDesignation : UITextField!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var txtNameOfInstitue : UITextField!
    var experinceDict1 = [String: String]()
    var experencecallback: ((String?)->())?
    var navController: UINavigationController?
    var updateExpeince: Bool?
    var updateBank:Bool?
    var exprienceId: String?
    var addExperience: Bool?
    var delegate: updateExpiernceDelegateProtocol? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        txtDesignation.text = experinceDict1["designationTxt"]
        txtNameOfInstitue.text = experinceDict1["collegeTxt"]
    }

    //MARK:- IBAction
    @IBAction func btnAddExperiencePressed(_ sender: UIButton){
        if updateExpeince == true {
            performUpdateExpiernce()
        } else if addExperience == true {
            self.validations()
        } else {
            validations()
        }
      }
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)

        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
   }

extension AddExperiencePopUp {
    func addExperience(param: [String: String]) {
        firstly {
            service!.experince(parameters: param, header: "DeviceToken")
        }.done { (model: DoctorSpeciality) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
              
        }
           
        }.finally {
            DispatchQueue.main.async {
               // Loader.hide()
            }
        }
    }
    
    func validations() {
        if self.txtDesignation.text?.isEmpty ?? false {
            AppToast.showMessage(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Designation", comment: ""))
        } else if self.txtNameOfInstitue.text == nil  {
            AppToast.showMessage(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "institude", comment: ""))
        } else {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
           parameter = ["language_type": "en",
                        "id": "\(id ?? "")",
                        "designation": "\(txtDesignation.text ?? "")",
                        "institute": "\(txtNameOfInstitue.text ?? "")"]
        addExperience(param: parameter)
    }
 }
    func handleResponse(model: DoctorSpeciality){
        if model.status == "SUCCESS"{
            print(model)
            self.delegate?.updateExperience()
            experencecallback?(txtDesignation.text)
           // self.addExperienceCallBack?()
        }else{
            //AppToast.showMessage(message: model.message ?? "")
        }
   }
}

extension AddExperiencePopUp {
    func updateExpiernce(param: [String: String]){
        firstly {
            service!.updateExpience(parameters: param, header: "DeviceToken")
        }.done { (model: UpdateQualificationModel) in
            self.performUpdateExpienence(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            
        }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
   func performUpdateExpiernce() {
    let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        parameter = ["language_type": "en",
                     "doctor_id": "\(id ?? "")",
                     "id": "\(self.exprienceId ?? "")",
                     "designation": "\(txtDesignation.text ?? "")",
                     "institute": "\(txtNameOfInstitue.text ?? "")"]
       updateExpiernce(param: parameter)
     }
    
    func performUpdateExpienence(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            self.delegate?.updateExperience()
            self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
       }
    }
}
