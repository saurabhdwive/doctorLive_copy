//
//  MyProfileExtension.swift
//  DoctorLive
//
//  Created by call soft on 10/09/21.
//

import Foundation
import UIKit
import PromiseKit
import SDWebImage

extension MyProfileVC {
    
     func doctorProfile(param: [String: String]) {
        firstly {
            service!.doctorProfile(parameters: param, header: "DeviceToken")
        }.done { (model: DoctorProfileModel) in
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
    func PerformDoctorProfile() {
        let token = UserDefaults.standard.string(forKey: Constants.accessToken)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": "\(token ?? "")"]
        
        doctorProfile(param: parameter)
    }
    
    func handleResponse(model: DoctorProfileModel) {
        var gender1 = String()
        let item = model.personaldetail?.gender ?? ""
        if item == "m" {
            gender1 = "Male"
        }else if model.personaldetail?.gender == "f" {
            gender1 = "Female"
        } else {
            gender1 = "Other"
        }
        if model.status == "SUCCESS" {
            dict = ["name" : model.personaldetail?.name ?? "",
                    "phone": model.personaldetail?.mobile ?? "",
                    "email": model.personaldetail?.email ?? "",
                    "dob": model.personaldetail?.dob ?? "",
                    "gender": gender1,
                    "adress": model.personaldetail?.address ?? "",
                    "passNum": model.personaldetail?.passportNum ?? "",
                    "docNum": model.personaldetail?.registrationNum ?? "",
                    "image": model.personaldetail?.image ?? ""]
            
            doctorName.text = model.personaldetail?.name
            email.text = model.personaldetail?.email
            dob.text = model.personaldetail?.dob
            phone.text = model.personaldetail?.mobile
            gender.text = gender1
            adress.text = model.personaldetail?.address
            passNum.text = model.personaldetail?.passportNum
            docNum.text = model.personaldetail?.registrationNum
            dateOfJoin.text = model.personaldetail?.joiningDate
            if let imageUrl = model.personaldetail?.image {
                self.profileImage.sd_setImage(with: URL(string:imageUrl))
                self.profileImage.contentMode = .scaleAspectFill
                self.profileImage.layer.cornerRadius = 10
                
            }
            totalConsultation.text = "\((model.personaldetail?.totalConsult) ?? 0)"
            visit.text = "\(model.personaldetail?.totalVisitConsult ?? 0)"
            totalCall.text = "\(model.personaldetail?.totalCallConsult ?? 0)"
        
        } else {
            AppToast.showMessage(message: model.message ?? "")
            
        }
    }
}

extension MyProfileVC: CellSubclassDelegate, DeleteExperinceDelegate {
    func buttonTapped(cell: QualificationTableViewCell) {
        if qualification.count == 1 {
            Utils.shared.displayAlert(title: "", message: "Add one more to delete the Qualification".localized(), viewController: self)
        }
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.qualificationTableView.indexPath(for: cell) else {
                return
            }
           // self.qualification.remove(at: indexPath.)
           // self?.qualificationTableView.beginUpdates()
            self?.qualification.remove(at: indexPath.row)
//            self?.qualificationTableView.deleteRows(at: [indexPath], with: .bottom)
//            self?.qualificationTableView.endUpdates()
            self?.performDeleteQulification()
            self?.qualificationTableView.reloadData()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self]_ in
            self.qualificationTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    func buttonTapped(cell: ExperinceTableViewCell) {
        if experience.count == 1 {
            Utils.shared.displayAlert(title: "", message: "Add one more to delete the Experience".localized(), viewController: self)
        }
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.experinceTableView.indexPath(for: cell) else {
                return
            }
            //self?.experinceTableView.beginUpdates()
            self?.experience.remove(at: indexPath.row)
            //self?.experinceTableView.deleteRows(at: [indexPath], with: .bottom)
            //self?.experinceTableView.endUpdates()
            self?.performDeleteExperience()
            self?.experinceTableView.reloadData()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self]_ in
            self.experinceTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
}

extension MyProfileVC {
    func deleteQualification(param: [String: String]){
        firstly {
            service!.deleteQualification(parameters: param, header: "DeviceToken")
        }.done { (model: DeleteQualification) in
            self.dltQualification(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performDeleteQulification() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        var parameter = [String: String]()
        parameter = ["doctor_id": "\(id ?? "")",
                     "id": "\(self.qualifiId ?? "")",
                     "language_type": code]
        deleteQualification(param: parameter)
    }
    
    func dltQualification(model: DeleteQualification){
        if model.status == "SUCCESS" {
            print(model)
            if self.qualification.count <= 3 {
                self.qualificationViewHeight.constant = CGFloat(self.qualification.count * 110)+120
                self.view.layoutIfNeeded()
                self.qualificationTableView.reloadData()


            }else{
               
                self.qualificationViewHeight.constant = CGFloat(3 * 110)+120
                self.view.layoutIfNeeded()
                self.qualificationTableView.reloadData()
            }
            
            
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension MyProfileVC {
    func deleteExperience(param: [String: String]){
        firstly {
            service!.deleteExperince(parameters: param, header: "DeviceToken")
        }.done { (model: DeleteQualification) in
            self.dltExperience(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performDeleteExperience() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        parameter = ["doctor_id": "\(id ?? "")",
                     "id": "\(self.exprienceId ?? "")"]
        deleteExperience(param: parameter)
    }
    
    func dltExperience(model: DeleteQualification) {
        if model.status == "SUCCESS" {
            print(model)
            if self.experience.count <= 3 {
                
                self.expienceViewHeight.constant = CGFloat(self.experience.count * 80)+120
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()


            }else{
               
                self.expienceViewHeight.constant = CGFloat(3 * 80)+120
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension MyProfileVC {
    func doctorSpeciality(param: [String: String]) {
        firstly {
            service!.speciality(parameters: param, header: "DeviceToken")
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
    
    func validationsList(){
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code]
        doctorSpeciality(param: parameter)
    }
    
    func handleResponse(model: DoctorSpeciality){
        if model.status == "SUCCESS"{
            if let specialData = model.specialtyList{
                //self.specialtyListArray = specialData//model.specialtyList ?? [SpecialtyList]()
                specialtyArray = specialData
                for person in specialData {
                    specialtyListArray.append(person.name ?? "")
                    //specialtyListIdArray.append(person.id ?? "")
                }
            }else{
                AppToast.showMessage(message: model.message ?? "")
            }
            }
          
    }
}

struct specialtyDataModel {
    var name: String?
    var id : String?
}
