//
//  MedicineSearchVC.swift
//  DoctorLive
//
//  Created by cst on 10/12/21.
//

import UIKit
import PromiseKit


class MedicineSearchVC: UIViewController, UISearchBarDelegate {
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

   }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        return bankListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineTableViewCell", for: indexPath) as! MedicineTableViewCell
        cell.medicineName.text = bankListArray[indexPath.row].genericName
        cell.medicineType.text = bankListArray[indexPath.row].form
        cell.medicineCompany.text = bankListArray[indexPath.row].brandName
        cell.drugQunatity.text = bankListArray[indexPath.row].strength
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medicine = bankListArray[indexPath.row].brandName
        let id = bankListArray[indexPath.row].id
        self.navigationController?.popViewController(animated: true)
        medicinecallback?(medicine, id)
       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.performBankList(searchBar.text ?? "")
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
   

}
extension MedicineSearchVC {
    func banklist(param: [String: String]){
        firstly {
            service!.medicineList(parameters: param, header: "DeviceToken")
        }.done { (model: MedicineListModel) in
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
    
   @objc func performBankList(_ text:String){
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "keyword": text]
        banklist(param: parameter)
    }
    
    func handleResponse(model: MedicineListModel){
        if model.status == "SUCCESS"{
            print(model)
            self.bankListArray = model.medicinelisting?.reversed() ?? [Medicinelisting]()
            self.tableView.reloadData()
//            for person in model.medicinelisting! {
//                bankListArray.append(person.brandName ?? "")
//            }
        }else{
            
        }
    }
}
