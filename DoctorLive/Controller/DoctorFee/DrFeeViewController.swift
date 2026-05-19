//
//  DrFeeViewController.swift
//  DoctorLive
//
//  Created by cst on 12/11/21.
//

import UIKit
import PromiseKit
import SideMenu

class DrFeeViewController: UIViewController {
    
    @IBOutlet weak var videoPatientFeesTxt, videoPatientVatFeesTxt, followUpPatientFeesTxt, followUpPatientVatFeesTxt: UITextField!
    @IBOutlet weak var videoCallBottomVw, videoPatientFeesVw, videoPatientVatFeesVw, followUpPatientFeesVw, followUpPatientVatFeesVw, followBottomVw, videoCallFeeVw, followFeeVw: UIView!
    @IBOutlet weak var followUpFeesLbl, videoPriceLbl, titleLable: UILabel!
    @IBOutlet weak var editFeesBtn: UIButton!
    
    var menu: SideMenuNavigationController?
    var feesDetailData: FeesDetailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.getDrFee()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func setUpViews(){
        self.titleLable.text = "My Fee".localized()
        GlobalMethods.shared.provideShadowMultipleView(vw: [self.videoCallFeeVw, self.followFeeVw], shadowColor: UIColor.gray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width: -5, height: 5), shadowRadius: 12)
        GlobalMethods.shared.provideCornerRadius(view: self.editFeesBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideThreeCornerRadius(view: self.videoCallBottomVw, cornerRadius: 12, cornerArray: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        GlobalMethods.shared.provideThreeCornerRadius(view: self.followBottomVw, cornerRadius: 12, cornerArray: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.videoPatientFeesVw, self.videoPatientVatFeesVw, self.followUpPatientFeesVw, self.followUpPatientVatFeesVw], cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 0.5)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
    }
    
    @IBAction func editBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getFeesDetailViewC()
        viewC.feesDetailData = FeesDetailData(callPrice: self.feesDetailData?.callPrice ?? "", callPercentage: self.feesDetailData?.callPercentage ?? "", followUpPrice: self.feesDetailData?.followUpPrice ?? "", followUpPercentage: self.feesDetailData?.followUpPercentage ?? "")
        viewC.delegate = self
        self.navigationController?.pushViewController(viewC, animated: true)
    }
}

extension DrFeeViewController: FeesDetailProtocol{
    func feesDetailProtocol() {
        self.getDrFee()
        self.showToast(message: "Edit Successfully")
    }
}

extension DrFeeViewController {
    func myWidhraw(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.drFee(parameters: param, header: "DeviceToken")
        }.done { (model: DRFeeModel) in
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
    
    func getDrFee() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let id = UserDefaults.standard.string(forKey: Constants.userId) else { return }
        parameter = ["doctor_id": id,
                     "token": token]
        myWidhraw(param: parameter)
    }
    
    func myWidhrawResponse(model: DRFeeModel) {
        if model.status == "SUCCESS" {
            print(model.feesdetail)
            self.videoPatientFeesTxt.text = "৳\(model.feesdetail?.callPrice ?? "")"
            self.followUpPatientFeesTxt.text = "৳\(model.feesdetail?.followupPrice ?? "")"
            self.videoPriceLbl.text = "৳\(model.feesdetail?.callPrice ?? "")"
            self.followUpFeesLbl.text = "৳\(model.feesdetail?.followupPrice ?? "")"
            
            let callPercentage = Float(model.feesdetail?.callPercent ?? 0)
            let followUpPercentage = Float(model.feesdetail?.followupPercent ?? 0)
            if callPercentage == Float(0){
                self.videoPatientVatFeesTxt.text = "৳\(model.feesdetail?.callPrice ?? EMPTY)"
            }else{
                let videoPrice = Float(model.feesdetail?.callPrice ?? EMPTY) ?? Float(0)
                let finalPrice = (videoPrice * callPercentage) / 100.0
                self.videoPatientVatFeesTxt.text = "৳\(String(Int(videoPrice - finalPrice)))"
            }
            if followUpPercentage == Float(0){
                self.followUpPatientVatFeesTxt.text = "৳\(model.feesdetail?.followupPrice ?? "")"
            }else{
                let followPrice = Float(model.feesdetail?.followupPrice ?? EMPTY) ?? Float(0)
                let finalPrice = (followPrice * followUpPercentage) / 100.0
                self.followUpPatientVatFeesTxt.text = "৳\(String(Int(followPrice - finalPrice)))"
            }
            self.feesDetailData = FeesDetailData(callPrice: model.feesdetail?.callPrice ?? "", callPercentage: String(model.feesdetail?.callPercent ?? 0), followUpPrice: model.feesdetail?.followupPrice ?? "", followUpPercentage: String(model.feesdetail?.followupPercent ?? 0))
            LoaderController.sharedInstance.removeLoader()
        } else {
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

struct FeesDetailData {
    
    var callPrice: String?
    var callPercentage: String?
    var followUpPrice: String?
    var followUpPercentage: String?
    
    init(callPrice: String = EMPTY, callPercentage: String = EMPTY, followUpPrice: String = EMPTY, followUpPercentage: String = EMPTY) {
        self.callPrice = callPrice
        self.callPercentage = callPercentage
        self.followUpPrice = followUpPrice
        self.followUpPercentage = followUpPercentage
    }
}
