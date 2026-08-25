//
//  MyEarningViewController.swift
//  DoctorLive
//
//  Created by cst on 09/10/21.
//

import UIKit
import PromiseKit
import DropDown
import SideMenu
class MyEarningViewController: UIViewController {
    
    @IBOutlet weak var balanceTxt: UILabel!
    @IBOutlet weak var widhrawButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectedTxtField: UITextField!
    @IBOutlet weak var segView: UIView!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenu: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var balanceLable: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var dueAmountValue: UILabel!
    @IBOutlet weak var paidAmountValue: UILabel!
    @IBOutlet weak var dueAmount: UILabel!
    //  @IBOutlet weak var dueAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var allLbl: UITextField!
    var menu: SideMenuNavigationController?
    @IBOutlet weak var notificationCountTxt: UILabel!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var myEarning: Bool = true
    var myWidhraw: Bool = false
    var myEarningArray:[Earning] = []
    var myWidhrawArray:[WithdrawEarning] = []
    var earningData: EarningListModel?
    var notifyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validations()
        setUpTableView()
        notificationCountTxt.text = String(count)
        infoView.layer.cornerRadius = 7
        widhrawButton.layer.cornerRadius = 10
        titleLbl.text = "My Earnings".localized()
        balanceLable.text = "Total Earnings".localized()
        widhrawButton.setTitle("Withdraw".localized(), for: .normal)
        allLbl.text = "All".localized()
        performWidhraw()
        seg.setTitle("Transactions".localized(), forSegmentAt: 0)
        seg.setTitle("Withdraws".localized(), forSegmentAt: 1)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyEarningTableViewCell", bundle: nil), forCellReuseIdentifier: "MyEarningTableViewCell")
        tableView.register(UINib(nibName: "MyWidhrawTableViewCell", bundle: nil), forCellReuseIdentifier: "MyWidhrawTableViewCell")
        //seg.backgroundColor = .clear
        tableView.reloadData()
        //seg.backgroundColor = .white
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    @IBAction func notificationButton(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func selectionTypeBtn(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["All", "Video Call", "Clinic Visit"]
        dropDown.anchorView = sender as? AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
       dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            // (sender as AnyObject).setTitle(item, for: .normal)
            self?.allLbl.text = item
           self?.validations()
        }
    }
    
    
    @IBAction func sideMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func widhrawTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "WidhrawViewController") as! WidhrawViewController
        vc.amount = earningData?.myearning?.totalEarning
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segTapped(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.myEarning = true
            self.myWidhraw = false
            validations()
            self.tableView.reloadData()
            
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            self.myWidhraw = true
            self.myEarning = false
            self.performWidhraw()
            self.tableView.reloadData()
        }
    }
}

//MARK:- Extension for tableView Delegate & DataSource
extension MyEarningViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myEarning == true {
            return myEarningArray.count
        } else  {
            return myWidhrawArray.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if myEarning == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyEarningTableViewCell", for: indexPath) as! MyEarningTableViewCell
            cell.userName.text = myEarningArray[indexPath.row].patient_name
            cell.refernceNum.text = "Booking ID: \(myEarningArray[indexPath.row].bookingId ?? "")"
            cell.transactionTime.text = myEarningArray[indexPath.row].bookingDate
            cell.amountTxt.text = "৳\(myEarningArray[indexPath.row].amount ?? "")"
            return cell
        } else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "MyWidhrawTableViewCell", for: indexPath) as! MyWidhrawTableViewCell
            cell1.amountTxt.text = "৳\(myWidhrawArray[indexPath.row].fees ?? "")"
            cell1.bankName.text = myWidhrawArray[indexPath.row].bankName
            cell1.accountNum.text = "A/C:\(myWidhrawArray[indexPath.row].accountNumber ?? "")"
            cell1.transactionTime.text = myWidhrawArray[indexPath.row].createdDate
            return cell1
            
        }
    }
    
}

extension MyEarningViewController {
    func fullProfile(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.myEarning(parameters: param, header: "DeviceToken")
        }.done { (model: EarningListModel) in
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
        var type = String()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        if allLbl.text == "All" {
            type = ""
        } else if allLbl.text == "Video Call" {
            type = "call"
        } else {
            type = "visit"
        }
        parameter = ["language_type": code,
                     "token": token,
                     "type": type]
        if let notifyId = notifyId {
            parameter["notify_id"] = notifyId
        }
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: EarningListModel) {
        if model.status == "SUCCESS" {
            print(model)
            self.myEarningArray = model.myearning?.earning ?? [Earning]()
            self.earningData = model
            let due = model.myearning?.due
            UserDefaults.standard.set(due, forKey: "balance")
            let totalMoney = model.myearning?.totalEarning
            let dueAmount = model.myearning?.due
            UserDefaults.standard.integer(forKey: "dueAmount")
            let paid = model.myearning?.paid
            self.dueAmount.text = "Due Amount:".localized()
            self.paidAmount.text = "Paid Amount:".localized()
           
            self.tableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension MyEarningViewController {
    func myWidhraw(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.myWidhraw(parameters: param, header: "DeviceToken")
        }.done { (model: WidhrawListModel) in
            self.myWidhrawResponse(model: model)
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
    
    func performWidhraw() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
//        if let notifyId = notifyId {
//            parameter["notify_id"] = notifyId
//        }
         myWidhraw(param: parameter)
    }
    
    func myWidhrawResponse(model: WidhrawListModel) {
        LoaderController.sharedInstance.removeLoader()
        if model.status == "SUCCESS" {

            self.myWidhrawArray = model.mywithdraw?.earning ?? [WithdrawEarning]()
            self.dueAmountValue.text = "\(model.mywithdraw?.due ?? 0.0)"
            self.paidAmountValue.text = "\(model.mywithdraw?.paid ?? 0.0)"
            self.balanceTxt.text = "৳\(model.mywithdraw?.totalEarning ?? 0.0)"
            UserDefaults.standard.setValue("\(model.mywithdraw?.totalEarning ?? 0.0)", forKey: Constants.amount)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            AppToast.showMessage(message: model.status ?? "")
        }
    }
}
