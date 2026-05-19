//
//  SelectLanguageVC.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import Mobilisten
import PromiseKit

class SelectLanguageVC: ParentViewController {
    //MARK:- Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnEnglish : UIButton!
    @IBOutlet weak var btnBangla : UIButton!
    @IBOutlet weak var lblSelectLang : UILabel!
    var passChange: Bool?
    var languageChange: Bool?
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if passChange == true {
            AppToast.showMessage(message: "Password Change Successfuly")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ZohoSalesIQ.showLauncher(false)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- SetUp UI/UX
    fileprivate func setupUI() {
        setupLable(["Select Language"], [lblSelectLang], [.left], [.Medium], [16])
        btnEnglish.setTitle("English", for: .normal)
        btnEnglish.titleLabel?.font =  AppFont.Regular.size(AppFontName.poppins, size: 16)
        btnBangla.setTitle("বাংলা", for: .normal)
        btnBangla.titleLabel?.font =  AppFont.Regular.size(AppFontName.poppins, size: 16)
        btnEnglish.dropShadow(scale: true)
        btnBangla.dropShadow(scale: true)
        mainView.dropShadow(scale: true)
        mainView.layer.cornerRadius = 6
    }
    
    //MARK:- IBAction
    @IBAction func btnEnglishPressed(_ sender: UIButton){
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let code = "en"
        UserDefaults.standard.set(code, forKey: Constants.languageCode)
        Localize.setCurrentLanguage(language: code)
        performLangaugeChange()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBanglaPressed(_ sender: UIButton) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let code = "bn"
        UserDefaults.standard.set(code, forKey: Constants.languageCode)
        Localize.setCurrentLanguage(language: code)
        performLangaugeChange()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SelectLanguageVC {
    func languageChange(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.changeLanguage(parameters: param, header: "DeviceToken")
        }.done { (model: LanguageChangeModel) in
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
    
    func performLangaugeChange() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        languageChange(param: parameter)
    }
    
    func myWidhrawResponse(model: LanguageChangeModel) {
        if model.status == "SUCCESS" {
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: "Language Change Successfully")
            // LoaderController.sharedInstance.removeLoader()
        }
    }
}
