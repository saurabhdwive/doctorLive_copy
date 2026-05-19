//
//  AddExperiencePopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit
import DropDown

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
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearTxtField: UITextField!
    var experinceDict1 = [String: String]()
    var experencecallback: ((String?)->())?
    var navController: UINavigationController?
    var updateExpeince: Bool?
    var updateBank:Bool?
    var exprienceId: String?
    var addExperience: Bool?
    var controller = UIViewController()
    var delegate: updateExpiernceDelegateProtocol? = nil
    let years = (1930...2025).map { String($0) }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        txtDesignation.text = experinceDict1["designationTxt"]
        txtNameOfInstitue.text = experinceDict1["collegeTxt"]
        lblHeading.text = "Add Experience".localized()
        txtNameOfInstitue.placeholder = "Institution Name".localized()
        txtDesignation.placeholder = "Designation".localized()
        btnAddExperience.setTitle("Add Experience".localized(), for: .normal)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    @IBAction func yearBtnTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = years
        dropDown.show()
        dropDown.direction = .any
        //dropDown.backgroundColor = .white
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
          //  let choosevalue = item
            self.yearTxtField.text =  item
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
            AppToast.showMessage1(message: "Please Fill your Designation Name".localized(), self)
        } else if self.txtNameOfInstitue.text?.isEmpty ?? false  {
            AppToast.showMessage1(message: "Please Fill your institute Name".localized(), self)
        } else {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                        "id": "\(id ?? "")",
                        "designation": "\(txtDesignation.text ?? "")",
                        "institute": "\(txtNameOfInstitue.text ?? "")",
                         "year": yearTxtField.text ?? ""]
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
    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
    parameter = ["language_type": code,
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
