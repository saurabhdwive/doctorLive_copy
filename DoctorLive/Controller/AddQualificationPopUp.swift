//
//  AddQualificationPopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit
import DropDown

protocol updateTableViewDelegateProtocol {
    func sendDataToFirstViewController()
}

class AddQualificationPopUp: ParentViewController, AnimationProviding {
    //MARK:- Variable
    var controller = UIViewController()
    var isCameFrom: String?
    var addQuliCallBack: (() -> ())?
    var countries: [String] = []
    var callback: ((String?)->())?
    let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    var qualificationId: String?
    var updateQualification: Bool?
    var addQualification: Bool?
    var delegate: updateTableViewDelegateProtocol? = nil
    let years = (1930...2025).map { String($0) }
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnAddQualification : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var txtNameOfDegree : UITextField!
    @IBOutlet weak var txtNameOfInstitue : UITextField!
    @IBOutlet weak var txtNameOfCountry : UITextField!
    @IBOutlet weak var txtPassYear : UITextField!
    @IBOutlet weak var popView: UIView!
    var qualficationDict1 = [String: String]()
    var navController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        txtNameOfDegree.text = qualficationDict1["degreeTxt"]
        txtNameOfInstitue.text = qualficationDict1["collegeTxt"]
        txtPassYear.text = qualficationDict1["yearLable"]
        txtNameOfCountry.text = qualficationDict1["country"]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUpView() {
        lblHeading.text = "Add Qualification".localized()
        txtNameOfDegree.placeholder = "Name Of Degree".localized()
        txtNameOfInstitue.placeholder = "Institution Name".localized()
        txtNameOfCountry.placeholder = "Country".localized()
        txtPassYear.placeholder = "Passing Year".localized()
        btnAddQualification.setTitle("Add Qualification".localized(), for: .normal)
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func passingYearTxt(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = years
        dropDown.show()
        dropDown.direction = .any
        //dropDown.backgroundColor = .white
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
          //  let choosevalue = item
         self.txtPassYear.text =  item
        }
    }
    
    @IBAction func countryPressed(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = countryList
        dropDown.anchorView = sender as? AnchorView
        dropDown.direction = .top
       // dropDown.backgroundColor = .white
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        //self.dropDownButton.isHidden = true
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            //(sender as AnyObject).setTitle(item, for: .normal)
            self?.txtNameOfCountry.text = item
        }
    }
    
    //MARK:- IBAction
    @IBAction func btnAddQualificationPressed(_ sender: UIButton) {
        if updateQualification == true {
            performUpdateQulification()
        } else if addQualification == true {
            validations()
        } else {
            validations()
        }
    }
}

extension AddQualificationPopUp {
    func addQualification(param: [String: String]) {
        firstly {
            service!.qualification(parameters: param, header: "DeviceToken")
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
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        if self.txtNameOfDegree.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Degree Name".localized(), self)
        } else if self.txtNameOfInstitue.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your institude Name".localized(), self)
        } else if self.txtNameOfCountry.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please select your country Name".localized(), self)
        } else if self.txtPassYear.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your passingYear".localized(), self)
        } else {
            var parameter = [String: String]()
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "id": "\(id ?? "")",
                         "degree": "\(txtNameOfDegree.text ?? "")",
                         "institute": "\(txtNameOfInstitue.text ?? "")",
                         "country": "\(txtNameOfCountry.text ?? "")",
                         "passing_year": "\(txtPassYear.text ?? "")"]
            addQualification(param: parameter)
        }
    }
    func handleResponse(model: DoctorSpeciality) {
        if model.status == "SUCCESS"{
            if addQualification == true {
                self.delegate?.sendDataToFirstViewController()
            } else {
                print(model)
                callback?(txtNameOfDegree.text)
                //self.addQuliCallBack?()
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension AddQualificationPopUp {
    func updateQualification(param: [String: String]){
        firstly {
            service!.updateQualification(parameters: param, header: "DeviceToken")
        }.done { (model: UpdateQualificationModel) in
            self.updateQualification(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performUpdateQulification() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "id": "\(self.qualificationId ?? "")",
                     "degree": "\(txtNameOfDegree.text ?? "")",
                     "institute": "\(txtNameOfInstitue.text ?? "")",
                     "country": "\(txtNameOfCountry.text ?? "")",
                     "passing_year": "\(txtPassYear.text ?? "")"]
        updateQualification(param: parameter)
    }
    
    func updateQualification(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            self.delegate?.sendDataToFirstViewController()
            // self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
