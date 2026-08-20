//
//  SideMenuVC.swift
//  DoctorLive
//
//  Created by User on 17/08/21.
//

import UIKit
import SDWebImage
import PromiseKit
import SideMenu

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var imaOut: UIImageView!
    @IBOutlet weak var nametxt,balTxt: UILabel?
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var menu: SideMenuNavigationController?
    var amount = UserDefaults.standard.string(forKey: "balance")
    var myEarningArray:[Earning] = []
   
    var earningData: EarningListModel?
    var menuItem = ["\("Home".localized())","My Rating" ,"\("My Availabilities".localized())", "\("My Earnings".localized())", "\("My Profile".localized())", "My Fee".localized(), "\("Notifications".localized())","\("Settings".localized())","Change Language".localized(), "\("Help & Support".localized())", "\("Share with friends".localized())", "Logout".localized()]
    
     var logoImage: [UIImage] = [#imageLiteral(resourceName: "Path 6649"),#imageLiteral(resourceName: "Path 6717"),#imageLiteral(resourceName: "Path 6717"),#imageLiteral(resourceName: "Path 6643"),#imageLiteral(resourceName: "Path 6653"),#imageLiteral(resourceName: "my fee"),#imageLiteral(resourceName: "Path 6654"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "Path 6747"),#imageLiteral(resourceName: "Help&setting"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "Path 6658"),#imageLiteral(resourceName: "Path 6658")]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        PerformDoctorProfile()
        performProfessionalDetails()
    }
    
    @IBAction func widhrawAmountButton(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "WidhrawViewController") as! WidhrawViewController
        vc.amount = amount
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Extension for tableView Delegate & DataSource
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource {
    
    func setUpTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.img.image = logoImage[indexPath.row]
        cell.lblName.text = menuItem[indexPath.row]
           return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {

        case 0:
            if let viewController = storyboard?.instantiateViewController(identifier: HomeVC.className) as? HomeVC {
                navigationController?.pushViewController(viewController, animated: true)
            }
          break
            
        case 1:
            if let viewController = storyboard?.instantiateViewController(identifier: MyRatingViewC.className) as? MyRatingViewC {
                navigationController?.pushViewController(viewController, animated: true)
            }
//            
//        case 2:
//            print("My Clinics")
//
//            if let viewController = storyboard?.instantiateViewController(identifier: "AddNewClinicVC") as? AddNewClinicVC {
//                navigationController?.pushViewController(viewController, animated: true)
//            }
//           break
//            
        case 2:
            if let viewController = storyboard?.instantiateViewController(identifier: DayAvilabilityVC.className) as? DayAvilabilityVC {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 3:
            if let viewController = storyboard?.instantiateViewController(identifier: MyEarningViewController.className) as? MyEarningViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 4:
            if let viewController = storyboard?.instantiateViewController(identifier: MyProfileVC.className) as? MyProfileVC {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 5:
            if let viewController = storyboard?.instantiateViewController(identifier: DrFeeViewController.className) as? DrFeeViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 6:
            if let viewController = storyboard?.instantiateViewController(identifier: NotificationViewController.className) as? NotificationViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 7:
            if let viewController = storyboard?.instantiateViewController(identifier: SettingViewController.className) as? SettingViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 8:
            if let viewController = storyboard?.instantiateViewController(identifier: SelectLanguageVC.className) as? SelectLanguageVC {
                viewController.languageChange = true
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 9:
            if let viewController = storyboard?.instantiateViewController(identifier: HelpAndSupportVC.className) as? HelpAndSupportVC {
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 10:
            let url = URL(string: "https://www.google.com/")
            if let imageUrl = url, !imageUrl.absoluteString.isEmpty {
                let objectsToShare: [Any] = ["https://apps.apple.com/us/app/dr-live-for-doctors/id1592690667"]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            } else {
                print("errror")
            }
        case 11:
            logoutButtonTapped()
        default:
            print("Case")
      }
        
    }
    
    func logoutButtonTapped() {
        let actionSheet = UIAlertController(title: "", message: "Are you sure, You want to Logout?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
          

            if let videoVC = self?.findVideoCallController() {
                self?.resetDefaults()
                videoVC.isLoggingOut = true
                videoVC.disconnectCallAndDismiss(isLogout: true)
            }else{
                self?.resetDefaults()
                DIConfigurator.sharedInst().getRootViewC(.Auth, identifer: LoginVC.className)
                //                let view = UIStoryboard.init(name: "Auth", bundle: nil)
                //                let vc = view.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                //                self?.resetDefaults()
                //                self?.navigationController?.pushViewController(vc, animated: true)
            }
           
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        for key in dictionary.keys where key != Constants.deviceId {
            defaults.removeObject(forKey: key)
        }
    }
}

extension SideMenuVC {
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
        if model.status == "SUCCESS" {
            nametxt?.text = model.personaldetail?.name
           
            
           
          
            UserDefaults.standard.set(model.personaldetail?.name, forKey: Constants.userName)
            if let imageUrl = model.personaldetail?.image {
                self.imaOut.sd_setImage(with: URL(string:imageUrl))
                self.imaOut.contentMode = .scaleAspectFill
                self.imaOut.layer.cornerRadius = 10
            }
        } else {
         
        }
    }
}

extension SideMenuVC {
    func fullProfessionalProfile(param: [String: String]){
        firstly {
            service!.fullCompleteProfile(parameters: param, header: "DeviceToken")
        }.done { (model: FullProfileDetailModel) in
            self.handleProfileResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performProfessionalDetails() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        fullProfessionalProfile(param: parameter)
    }
    
    func handleProfileResponse(model: FullProfileDetailModel){
        print(model.message)
        if model.status == "SUCCESS" {
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.accountNo, forKey: Constants.accountNo)
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.bankName, forKey: Constants.bankName)
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.id, forKey: Constants.bankId)
        }else if model.message == "Your credentials is loggedIn in another device! Please login again."{
//            print(model.message)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension SideMenuVC {
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
    
    func MyEarning() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: EarningListModel) {
        if model.status == "SUCCESS" {
//            print(model)
            self.myEarningArray = model.myearning?.earning ?? [Earning]()
            self.earningData = model
            let due = model.myearning?.due
            UserDefaults.standard.set(due, forKey: "balance")
            let totalMoney = model.myearning?.totalEarning
            let dueAmount = model.myearning?.due
            UserDefaults.standard.setValue(totalMoney, forKey: Constants.amount)
            self.tableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else if model.message ==  "Your credentials is loggedIn in another device! Please login again."{
            self.alertWithHandler(message: "Your credentials is loggedIn in another device! Please login again.", block: {
                let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
                let menuVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navigationController = UINavigationController(rootViewController: menuVC)
                navigationController.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            })
        }else{
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
    
    func alertWithHandler(message : String , block:  @escaping ()->Void ){
        
        let  alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action : UIAlertAction) in
            
            block()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}


extension UIViewController {

    // MARK: - Check VideoCallViewC Exists
    
    func findVideoCallController() -> VideoCallViewC? {

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }

        return searchVideoCallController(from: rootVC)
    }
    
    private func searchVideoCallController(from vc: UIViewController) -> VideoCallViewC? {
        
        if let videoCall = vc as? VideoCallViewC {
            return videoCall
        }
        
        if let nav = vc as? UINavigationController {
            for child in nav.viewControllers {
                if let found = searchVideoCallController(from: child) {
                    return found
                }
            }
        }
        
        if let tab = vc as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let found = searchVideoCallController(from: child) {
                    return found
                }
            }
        }
        
        if let presented = vc.presentedViewController {
            if let found = searchVideoCallController(from: presented) {
                return found
            }
        }
        
        for child in vc.children {
            if let found = searchVideoCallController(from: child) {
                return found
            }
        }
        
        return nil
    }
}
