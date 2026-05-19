//
//  AddExperiencePopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit
import DropDown

protocol updateYearsExpiernceDelegateProtocol {
    func updateYearsExperience()
}

class YearsExperienceVC: ParentViewController, AnimationProviding {
   
    var addExperienceCallBack: (() -> ())?
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnAddExperience : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var years : UITextField!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var monthTxtField: UITextField!
    var experinceDict1 = [String: String]()
    var experencecallback: ((String?)->())?
    var navController: UINavigationController?
    var updateExpeince: Bool?
    var updateBank:Bool?
    var month = "months".localized()
    var year = "year".localized()
    var delegate: updateYearsExpiernceDelegateProtocol?
    var exprienceId: String?
    var addExperience: Bool?
   
    var updateProffesional1 = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        years.text = updateProffesional1["year"]?.localized()
        monthTxtField.text = updateProffesional1["month"]?.localized()
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!

        
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
    
    @IBAction func monthButton(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["0 month","1 month","2 month","3 month","4 month","5 month","6 month","7 month","8 month","9 month","10 month","11 month"]
        dropDown.show()
        dropDown.direction = .bottom
       
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            let choosevalue = item
            self.monthTxtField.text =  "\(choosevalue)"
            
        }
    }
    
    @IBAction func yearsButton(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource =   ["0 year","1 year","2 years","3 years" ,"4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years","13 years",
                                 "14 years","15 years","16 years","17 years","18 years","19 years","20 years","21 years","22 years","23 years","24 years","25 years","26 years","27 years","28 years","29 years","30 years","31 years","32 years",
                                 "33 years","34 years","35 years","36 years","37 years","38 years","39 years","40 years","41 years","42 years","43 years","44 years","45 years","46 years","47 years","48 years","49 years","50 years","50+ years"]
        
        dropDown.show()
        dropDown.direction = .bottom
        
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            let choosevalue = item
            self.years.text =  "\(choosevalue)"
        }
    }
}

extension YearsExperienceVC {
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
    let about = updateProffesional1["about"]
    let speciality = updateProffesional1["speciality"]
        var parameter = [String: String]()
    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
    parameter = ["language_type": code,
                     "specialty": "\(speciality ?? "")",
                     "id": "\(id ?? "")",
                     "year": "\(years.text ?? "")",
                     "month": "\(monthTxtField.text ?? "")",
                     "about" :"\(about ?? "")"]
       updateExpiernce(param: parameter)
     }
    
    func performUpdateExpienence(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            print(model)
            self.delegate?.updateYearsExperience()
            self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
       }
    }
 }
