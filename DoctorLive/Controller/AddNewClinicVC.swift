//
//  AddNewClinicVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit
import KYDrawerController
import SideMenu


class AddNewClinicVC: UIViewController, updateClinicDataDelegate, DeleteClinicDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var clinicTitle: UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var btnAddClinic : UIButton!
    @IBOutlet weak var notificationCountTxt: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var clinicID: String?
    var doctorId: String?
    var editClincDict = [String:String]()
    var clinicListArray: [Cliniclisting] = []
    var array: [String] = []
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        clinicTitle.text = "Clinics".localized()
        validations()
        btnAddClinic.setTitle("Add New Clinic".localized(), for: .normal)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCountTxt.text = String(count)
        setUpTable()
        self.tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func notification(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
    @IBAction func btnAddClinicPressed(_ sender: UIButton){
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddClinicVC") as! AddClinicVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
    }
    
    func updateProfile() {
        validations()
        self.tableView.reloadData()
    }
    
    func buttonTapped(cell: ClinicsCell) {
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.tableView.indexPath(for: cell) else {
                return
            }
            self?.tableView.beginUpdates()
            self?.clinicID = self?.clinicListArray[indexPath.row].clinicId
            self?.clinicListArray.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            self?.tableView.endUpdates()
            self?.deleteClinic()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.tableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    @objc func editClincButton(sender: UIButton) {
        let index = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddClinicVC") as! AddClinicVC
        editClincDict = ["clinicName":  "\(clinicListArray[index].clinicName ?? "")", "adressTxt": "\(clinicListArray[index].address ?? "")", "contactNumber": "\(clinicListArray[index].contactNumber ?? "")", "shortName": "\(clinicListArray[index].shortName ?? "")"]
        vc.editClinc = true
        vc.delegate = self
        vc.editClincDict = editClincDict
        vc.clinicId = clinicListArray[index].clinicId ?? ""
       // self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Extension for tableView Delegate & DataSource

extension AddNewClinicVC: UITableViewDelegate, UITableViewDataSource {
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ClinicsCell", bundle: nil), forCellReuseIdentifier: "ClinicsCell")
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clinicListArray.count == 0 {
            self.tableViewHeight.constant = 10
        } else {
            self.tableViewHeight.constant = 600
        }
        return clinicListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicsCell", for: indexPath) as! ClinicsCell
        
        cell.clinicName.text = clinicListArray[indexPath.row].clinicName
        cell.adressTxt.text = clinicListArray[indexPath.row].address
        let contactNum = clinicListArray[indexPath.row].contactNumber
        if contactNum == "" {
            cell.contactNumber.text = "_"
        } else {
            cell.contactNumber.text = contactNum
        }
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(self.editClincButton), for: .touchUpInside)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 }

extension AddNewClinicVC {
    func addQualification(param: [String: String]) {
        firstly {
            service!.clinicList(parameters: param, header: "DeviceToken")
        }.done { (model: ClinicListModel) in
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
        let token = UserDefaults.standard.string(forKey: Constants.accessToken)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": "\(token ?? "")"]
        addQualification(param: parameter)
    }
    
    func handleResponse(model: ClinicListModel){
        if model.status == "SUCCESS"{
            self.clinicListArray = model.cliniclisting ?? [Cliniclisting]()
            for person in model.cliniclisting! {
                array.append(person.clinicName ?? "")
                print(array.count)
            }
            self.tableView.reloadData()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension AddNewClinicVC {
    func deleteclinc(param: [String: String]) {
        firstly {
            service!.deleteclinicList(parameters: param, header: "DeviceToken")
        }.done { (model: DeleteQualification) in
            self.handleDeleteResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func deleteClinic() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "clinic_id": "\(self.clinicID ?? "")",
                     "doctor_id": "\(id ?? "")"]
        deleteclinc(param: parameter)
    }
    
    func handleDeleteResponse(model: DeleteQualification){
        if model.status == "SUCCESS"{
            //self.clinicListArray = model.cliniclisting ?? [Cliniclisting]()
            self.tableView.reloadData()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
