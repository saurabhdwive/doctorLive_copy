//
//  FullProfileExtension.swift
//  DoctorLive
//
//  Created by call soft on 12/09/21.
//

import Foundation
import UIKit
import PromiseKit


extension FullCompleteProfileVC: CellSubclassDelegate, DeleteExperinceDelegate {
    func buttonTapped(cell: QualificationTableViewCell) {
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.qualificationTableView.indexPath(for: cell) else {
                return
            }
            self?.qualificationTableView.beginUpdates()
            self?.qualification.remove(at: indexPath.row)
            self?.qualificationTableView.deleteRows(at: [indexPath], with: .bottom)
            self?.qualificationTableView.endUpdates()
            self?.performDeleteQulification()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.qualificationTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    func buttonTapped(cell: ExperinceTableViewCell) {
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.experinceTableView.indexPath(for: cell) else {
                return
            }
            self?.experinceTableView.beginUpdates()
            self?.experience.remove(at: indexPath.row)
            self?.experinceTableView.deleteRows(at: [indexPath], with: .bottom)
            self?.experinceTableView.endUpdates()
            self?.performDeleteExperience()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.experinceTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
}

extension FullCompleteProfileVC {
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
        var parameter = [String: String]()
        parameter = ["doctor_id": "\(id ?? "")",
                     "id": "\(self.qualifiId ?? "")"]
        deleteQualification(param: parameter)
    }
    
    func dltQualification(model: DeleteQualification){
        if model.status == "SUCCESS" {
            print(model)
            if qualification.count == 1 {
                self.qualificationViewHeight.constant = 100
                self.qualificationTableView.reloadData()
            } else {
                self.qualificationViewHeight.constant -= 100
                self.qualificationTableView.reloadData()
            }
            
            
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension FullCompleteProfileVC {
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
            if experience.count == 1 {
                self.expienceViewHeight.constant = 100
                self.experinceTableView.reloadData()
            } else {
                self.expienceViewHeight.constant -= 100
                self.experinceTableView.reloadData()
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
