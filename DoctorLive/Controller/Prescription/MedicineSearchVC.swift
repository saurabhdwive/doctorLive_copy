//
//  MedicineSearchVC.swift
//  DoctorLive
//
//  Created by cst on 10/12/21.
//

import UIKit
import PromiseKit


class MedicineSearchVC: UIViewController, UISearchBarDelegate {
    var medicineDetailCallback: ((Medicinelisting) -> Void)?
    var medicinecallback: ((String?, String?)->())?
    @IBOutlet weak var titleTxt: UILabel!
    
    //@IBOutlet weak var tableHeight: NSLayoutConstraint!
    var workItem: DispatchWorkItem?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var bankListArray: [Medicinelisting] = Array()
    
    var delegate: DataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxt.text = "Select Medicine".localized()
        searchBar.placeholder = "Search here".localized()
        searchBar.delegate = self
        setUpTableView()
        performBankList("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if let nav = self.navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MedicineTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicineTableViewCell")
      //  tableHeight.constant = tableView.contentSize.height
    }
}

extension MedicineSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bankListArray.isEmpty {
            let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return query.isEmpty ? 0 : 1
        }
        return bankListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineTableViewCell", for: indexPath) as! MedicineTableViewCell
        if bankListArray.isEmpty {
            let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            cell.medicineName.text = query
            cell.medicineType.text = "Tap to use custom medicine".localized()
            cell.medicineCompany.text = ""
            cell.drugQunatity.text = ""
            return cell
        }
        guard indexPath.row < bankListArray.count else { return cell }
        let item = bankListArray[indexPath.row]
        let brand = item.brandName ?? ""
        let generic = item.genericName ?? ""
        let form = item.form ?? ""
        let strength = item.strength ?? ""
        
        cell.medicineName.text = !brand.isEmpty ? brand : generic
        cell.medicineType.text = generic
        cell.medicineCompany.text = form
        cell.drugQunatity.text = strength
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bankListArray.isEmpty {
            let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !query.isEmpty else { return }
            medicinecallback?(query, "")
            if let nav = self.navigationController, nav.viewControllers.first != self {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        guard indexPath.row < bankListArray.count else { return }
        let item = bankListArray[indexPath.row]
        let medicine = item.brandName ?? item.genericName ?? ""
        let id = item.id
        medicineDetailCallback?(item)
        medicinecallback?(medicine, id)
        if let nav = self.navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        workItem?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.performBankList(searchText)
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performBankList(searchBar.text ?? "")
    }

}
extension MedicineSearchVC {
    func banklist(param: [String: String]){
        firstly {
            service!.medicineList(parameters: param, header: "DeviceToken")
        }.done { (model: MedicineListModel) in
            self.handleResponse(model: model)
        }.catch { [weak self] (error) in
            DispatchQueue.main.async {
                self?.bankListArray = []
                self?.tableView.reloadData()
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
   @objc func performBankList(_ text: String){
        var parameter = [String: String]()
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        parameter = ["language_type": code,
                     "keyword": text]
        banklist(param: parameter)
    }
    
    func handleResponse(model: MedicineListModel){
        if model.status == "SUCCESS"{
            self.bankListArray = model.medicinelisting ?? [Medicinelisting]()
        } else {
            self.bankListArray = []
        }
        self.tableView.reloadData()
    }
}
