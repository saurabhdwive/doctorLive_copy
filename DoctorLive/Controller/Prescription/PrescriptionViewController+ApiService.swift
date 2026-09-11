//
//  PrescriptionViewController+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 06/11/24.
//

import Foundation
import PromiseKit

extension PrescriptionViewController{
    func savePrescription(param:[String:Any]?) {
        LoaderController.sharedInstance.showLoader(view: self.view)
        ApiManager.instance.fetchApiService(method: .post, url: APIEndpoint.savePrescription, passDict: param, header: ApiManager.instance.getHeadeWithJwtToken())  { [self] (result) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
            switch result {
            case .success(let data):
                let modelData = try? JSONDecoder().decode(SavePrescriptionModel.self, from: data)
                print(modelData!)
                self.pastHistoryTxt.text = ""
                self.provisionTxt.text = ""
                self.tempLable.text = ""
                self.bloodSugar1.text = ""
                self.bloodSugar2.text = ""
                self.systolicBp.text = ""
                self.diaystolicLable.text = ""
                self.ChiefTxtComplain.text = ""
                self.pulseTxt.text = ""
                self.genralTxt.text = ""
                self.followUpDays.text = ""
                self.investigationTxt.text = ""
                self.arrayData.removeAll()
                if self.comeFrom == "videoCallViaChat" {
                    let vc = PrescriptionViewVC()
                    vc.comeFromVideo = true
                    LoaderController.sharedInstance.removeLoader()
                    vc.urlString = modelData?.filePdf ?? ""
                   
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if isComingFromChat{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let vc = PrescriptionViewVC()
                        LoaderController.sharedInstance.removeLoader()
                        vc.urlString = modelData?.filePdf ?? ""
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                break
            case .failure(let error):
                print("error.........\(error.localizedDescription)")
                
                LoaderController.sharedInstance.removeLoader()
                break
            }
        }
    }
    
    func performSavePrescription(){
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let bookingId = bookingId else { return}
        guard let cheifComplain = ChiefTxtComplain.text else { return}
        let pastHistory = pastHistoryTxt.text
        guard let general = genral else { return}
        guard let userid = UserDefaults.standard.string(forKey: Constants.userId) else { return}
        let temprature = tempLable.text
        let systolicBps = systolicBp.text
        let diaystolicBp = diaystolicLable.text
        let pulse = pulseTxt.text
        let bloodSugarFast = bloodSugar1.text
        let bloodSugar2nd = bloodSugar2.text
        let diagnosis = provisionTxt.text
        let generalAdvice = genralTxt.text
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        let followup = followUpDays.text
        
        var medicineArray = [[String: Any]]()
        
        self.arrayData.forEach { slot in
            
            medicineArray.append(["name": "\(slot.name)", "id" : "\(slot.id)", "dosage": "\(slot.dosage)", "frequency_first": "\(slot.frequencyFirst)","duration":"\(slot.duration)", "meals": "\(slot.meals)"])
            
        }
        
        var parameter = [String: Any]()
        parameter = ["token": token,
                     "language_type": code,
                     "booking_id": bookingId,
                     "user_id": userid,
                     "chief_complain": cheifComplain,
                     "past_history": pastHistory ?? "",
                     "general": general,
                     "temperature" : temprature ?? "",
                     "blood_first": systolicBps ?? "",
                     "blood_second": diaystolicBp ?? "",
                     "pulse": pulse ?? "",
                     "blood_sugar_first": bloodSugarFast ?? "",
                     "blood_sugar_second": bloodSugar2nd ?? "",
                     "diagnosis": diagnosis ?? "",
                     "investigation": self.investigationTxt.text ?? "",
                     "general_advice": generalAdvice ?? "",
                     "followup": self.avilability ?? "",
                     "followup_value": followup ?? "",
                     "medicine": medicineArray]
        savePrescription(param: parameter)
    }
}

extension PrescriptionViewController {
    func doctorSpeciality(param: [String: String]) {
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.investigationList(parameters: param, header: "DeviceToken")
        }.done { (model: TestListModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func validations() {
        var parameter = [String: String]()
        parameter = [:]
        doctorSpeciality(param: parameter)
    }
    
    func handleResponse(model: TestListModel){
        LoaderController.sharedInstance.removeLoader()
        if model.status == "SUCCESS"{
            print(model)
            for person in model.gettestinglist! {
                specialtyListArray.append(person.name ?? "")
            }
        }else{
            
        }
    }
}
