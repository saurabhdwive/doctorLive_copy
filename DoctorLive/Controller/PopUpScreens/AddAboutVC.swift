//
//  AddExperiencePopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit

protocol updateAboutDelegateProtocol {
    func updateAboutExperience()
}

class AddAboutVC: ParentViewController, AnimationProviding {
    
    var addExperienceCallBack: (() -> ())?
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnAddExperience : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var aboutTextField: UITextField!
    var experinceDict1 = [String: String]()
    var experencecallback: ((String?)->())?
    var navController: UINavigationController?
    var updateExpeince: Bool?
    var updateBank:Bool?
    var exprienceId: String?
    var addExperience: Bool?
    var updateProffesional1 = [String: String]()
    var delegate: updateAboutDelegateProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        aboutTextField.text = updateProffesional1["about"]
    }
    
    //MARK:- IBAction
    @IBAction func btnAddExperiencePressed(_ sender: UIButton){
        performUpdateExpiernce()
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)
            
        }else{
            self.dismiss(animated: true, completion: nil)
      }
    }
 }

extension AddAboutVC {
    func updateExpiernce(param: [String: String]){
        firstly {
            service!.updateProfessionalDetails(parameters: param, header: "DeviceToken")
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
        let year = updateProffesional1["year"]
        let month = updateProffesional1["month"]
        let speciality = updateProffesional1["speciality"]
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "specialty": "\(speciality ?? "")",
                     "id": "\(id ?? "")",
                     "year": "\(year ?? "")",
                     "month": "\(month ?? "")",
                     "about" :"\(aboutTextField.text ?? "")"]
        updateExpiernce(param: parameter)
    }
    
    func performUpdateExpienence(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            print(model)
            self.delegate?.updateAboutExperience()
            self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
