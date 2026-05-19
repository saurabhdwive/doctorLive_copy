//
//  AddClinicVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit
import KYDrawerController
import SideMenu

protocol updateClinicDataDelegate {
    func updateProfile()
}

class AddClinicVC: UIViewController, MyDataSendingDelegateProtocol {
    
    //MARK:- Outlets
    @IBOutlet weak var addClincLbl: UILabel!
    @IBOutlet weak var btnAddClinic : UIButton!
    @IBOutlet weak var txtClinicName : UITextField!
    @IBOutlet weak var txtClinicShortName : UITextField!
    @IBOutlet weak var txtClinicContactNo : UITextField!
    @IBOutlet weak var txtClinicAddressPing : UITextField!
    var menu: SideMenuNavigationController?
    @IBOutlet weak var notificationCountTxt: UILabel!
    @IBOutlet weak var adressButton: UIButton!
    var delegate:updateClinicDataDelegate?
    var clinicId = String()
    var adressText: String?
    var latitude: String?
    var longitude: String?
    var editClinc: Bool?
    var editClincDict = [String: String]()
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    override func viewDidLoad() {
        super.viewDidLoad()
        txtClinicName.placeholder = "Clinic Name".localized()
        txtClinicAddressPing.placeholder = "Address Details".localized()
        txtClinicContactNo.placeholder = "Contact Number".localized()
        txtClinicShortName.placeholder = "Address".localized()
        btnAddClinic.setTitle("Add Clinic".localized(), for: .normal)
        addClincLbl.text = "Add New Clinic".localized()
        txtClinicName.text = editClincDict["clinicName"]
        txtClinicAddressPing.text = editClincDict["adressTxt"]
        txtClinicContactNo.text = editClincDict["contactNumber"]
        txtClinicShortName.text = editClincDict["shortName"]
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if editClinc == true {
            addClincLbl.text = "Edit Clinic".localized()
            btnAddClinic.setTitle("Update Clinic".localized(), for: .normal)
        }
        notificationCountTxt.text = String(count)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func btnAddClinicPressed(_ sender: UIButton){
        if editClinc == true {
            self.performEditClinic()
        } else {
            performAddClinic()
        }
    }
    
    @IBAction func adressButtonTapped(_ sender: Any) {
        let location = LocationViewController()
        location.delegate = self
        self.navigationController?.pushViewController(location, animated: true)
    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func sendDataToFirstViewController(lat: String) {
        self.latitude = lat
        print(lat)
    }
    
    func sendDataToFirstViewController(long: String) {
        self.longitude = long
        print(long)
    }
    
    func sendDataToFirstViewController(adress: String) {
        self.adressText = adress
        print(adress)
        txtClinicAddressPing.text = adress
    }
    @IBAction func sideMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  }

extension AddClinicVC {
    func addClinic(param: [String: String]) {
        firstly {
            service!.AddclinicList(parameters: param, header: "DeviceToken")
        }.done { (model: AddClinicList) in
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
    
    func performAddClinic() {
        if self.txtClinicName.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Clinic Name".localized(), self)
        } else if self.txtClinicShortName.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Clinic Short Name".localized(), self)
//        } else if self.txtClinicContactNo.text?.isEmpty ?? false {
//            AppToast.showMessage1(message: "Please select your Contact Number".localized(), self)
        } else if self.txtClinicAddressPing.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Address".localized(), self)
        } else {
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "clinic_name": "\(txtClinicName.text ?? "")",
                     "short_name": "\(txtClinicShortName.text ?? "")",
                     "contact_number": "\(txtClinicContactNo.text ?? "")",
                     "address": "\(txtClinicAddressPing.text ?? "")",
                     "latitude": "\(self.latitude ?? "")",
                     "longitude": "\(self.longitude ?? "")"]
        addClinic(param: parameter)
    }
    }
    func handleResponse(model: AddClinicList){
        if model.status == "SUCCESS"{
            self.navigationController?.popViewController(animated: true)
            self.delegate?.updateProfile()
          
        } else {
            //AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension AddClinicVC {
    func editClinic(param: [String: String]) {
        firstly {
            service!.editClinic(parameters: param, header: "DeviceToken")
        }.done { (model: AddClinicList) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
               
            }
        }
    }
   
    func performEditClinic() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "clinic_id": self.clinicId,
                     "clinic_name": "\(txtClinicName.text ?? "")",
                     "short_name": "\(txtClinicShortName.text ?? "")",
                     "contact_number": "\(txtClinicContactNo.text ?? "")",
                     "address": "\(txtClinicAddressPing.text ?? "")",
                     "latitude": "\(self.latitude ?? "")",
                     "longitude": "\(self.longitude ?? "")"]
        editClinic(param: parameter)
    }
 }
