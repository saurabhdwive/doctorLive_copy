//
//  MyProfileVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit
import RSSelectionMenu
import KYDrawerController
import DropDown
import SideMenu

class MyProfileVC: UIViewController, updateTableViewDelegateProtocol, updateExpiernceDelegateProtocol, updateBankDelegateProtocol, updateProfileDataDelegate, updateYearsExpiernceDelegateProtocol, updateAboutDelegateProtocol {
    
    //MARK:- Outlets
    @IBOutlet weak var mainView1: UIStackView!
    @IBOutlet weak var mainView2 : UIView!
    @IBOutlet weak var Seg : UISegmentedControl!
    @IBOutlet weak var imageView : UIView!
    @IBOutlet weak var myProfile: UILabel!
    @IBOutlet weak var medicinView : UIView!
    @IBOutlet weak var qulificationView : UIView!
    @IBOutlet weak var currentExpView : UIView!
    @IBOutlet weak var yearView : UIView!
    @IBOutlet weak var monthExpView : UIView!
    @IBOutlet weak var qualificationTableView: UITableView!
    @IBOutlet weak var experinceTableView: UITableView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bankDetailExpView : UIView!
    @IBOutlet weak var yearExp: UILabel!
    @IBOutlet weak var specialitylable: UILabel!
    @IBOutlet weak var monthExp: UILabel!
    
    @IBOutlet weak var bankDeatils: UILabel!
    @IBOutlet weak var aboutTxt: UILabel!
    @IBOutlet weak var yearsTxt: UILabel!
    @IBOutlet weak var expienceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qualificationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var chargesView: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var docNum: UILabel!
    @IBOutlet weak var passNum: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var totalConsultation: UILabel!
    @IBOutlet weak var totalCall: UILabel!
    @IBOutlet weak var dateOfJoin: UILabel!
    @IBOutlet weak var visit: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var monthTxt: UILabel!
    @IBOutlet weak var aboutTxt1: UILabel!
    @IBOutlet weak var years: UIStackView!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var visitLbl: UILabel!
    @IBOutlet weak var onCallLbl: UILabel!
    @IBOutlet weak var totalConsulation: UILabel!
    @IBOutlet weak var nidPassport: UILabel!
    @IBOutlet weak var nisPassport: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var genderlbl: UILabel!
    @IBOutlet weak var dojLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var doj1Txt: UILabel!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var menu: SideMenuNavigationController?
    @IBOutlet weak var notificationCountTxt: UILabel!
    
    var specilityId = String()
    var parentVC: MyProfileVC?
    var qualifiId: String?
    var exprienceId: String?
    var addQualification: Bool?
    var qualification: [Qualification] = []
    var experience: [Experience] = []
    var profileUpdate = [String: String]()
    var bankDetails: [Bank] = []
    var bankId: String?
    var indexPath1: IndexPath?
    var indexRow: Int?
    var profileDetails: Personaldetail?
    var selectedNames: [String] = []
    var specialtyListIdArray: [String] = Array()
    var specialtyArray:[SpecialtyList]?
    var specialtyListArray:[String] = []
    let dropDown = DropDown()
    var dict = [String: String]()
    var qualficationDict = [String: String]()
    var experinceDict = [String: String]()
    var bankDict = [String: String]()
    var deleteQualification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PerformDoctorProfile()
        validationsList()
        Seg.setTitle("Personal".localized(), forSegmentAt: 0)
        Seg.setTitle("Professional".localized(), forSegmentAt: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes1, for: .normal)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notificationCountTxt.text = String(count)
        setupUI()
       
        mainView1.isHidden = true
        mainView2.isHidden = false
        profileImage.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
        Seg.backgroundColor = .clear
        myProfile.text = "My Profile".localized()
       
        emailTxt.text = "Email ID".localized()
        phoneLbl.text = "Phone".localized()
        yearsTxt.text = "Years".localized()
        aboutTxt.text = "About".localized()
        bankDeatils.text = "Bank details".localized()
        dob.text = "D.O.B".localized()
        genderlbl.text = "Gender".localized()
        adressLbl.text = "Address".localized()
        nidPassport.text = "NID/Passport No.".localized()
        doj1Txt.text = "DOJ".localized()
        onCallLbl.text = "On Call".localized()
        dojLbl.text = "D.O.B".localized()
        totalConsulation.text = "Total Consultations".localized()
        visitLbl.text = "Doctor Visit".localized()
        // yearLable.text = "Years".localized()
        nisPassport.text = "BMDC Reg. No.".localized()
        qualificationTableView.register(UINib(nibName: "QualificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "QualificationTableViewCell")
        experinceTableView.register(UINib(nibName: "ExperinceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ExperinceTableViewCell")
        qualificationTableView.delegate = self
        qualificationTableView.dataSource = self
        experinceTableView.delegate = self
        experinceTableView.dataSource = self
//        self.qualificationTableView.reloadData()
//        self.experinceTableView.reloadData()
        self.experinceTableView.isScrollEnabled = false
        self.qualificationTableView.isScrollEnabled = false
        qualificationTableView.separatorColor = UIColor.lightGray
    }
    
    fileprivate func setupUI() {
        //imageView.dropShadow(scale: true)
        medicinView.dropShadow(scale: true)
        qulificationView.dropShadow(scale: true)
        currentExpView.dropShadow(scale: true)
        years.dropShadow(scale: true)
        monthExpView.dropShadow(scale: true)
        bankDetailExpView.dropShadow(scale: true)
        yearView.layer.cornerRadius = 10
        monthExpView.layer.cornerRadius = 10
    }
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        let vc = PersonalProfileEditVC()
        vc.dict1 = dict
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editYears(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "YearsExperienceVC") as! YearsExperienceVC
        vc.delegate = self
        vc.addExperience = true
        vc.updateProffesional1 = profileUpdate
        vc.modalPresentationStyle = .overFullScreen
        vc.addExperienceCallBack = {
            self.dismiss(animated: true, completion: nil)
            self.experinceTableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func monthButtonTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddAboutVC") as! AddAboutVC
        vc.delegate = self
        vc.updateProffesional1 = profileUpdate
        vc.modalPresentationStyle = .overFullScreen
        vc.addExperienceCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func sendDataToFirstViewController() {
        self.dismiss(animated: true, completion: nil)
        validations()
       // self.qualificationTableView.reloadData()
    }
    func updateExperience() {
        self.dismiss(animated: true, completion: nil)
        validations()
       // self.experinceTableView.reloadData()
    }
    
    func updateBankDelegate() {
        self.dismiss(animated: true, completion: nil)
        validations()
        self.viewWillAppear(true)
    }
    
    func updateYearsExperience() {
        validations()
    }
    
    func updateAboutExperience() {
        validations()
    }
    
    func updateProfile() {
        PerformDoctorProfile()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK:- IBAction
    @IBAction func btnMenuPressed(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            PerformDoctorProfile()
            mainView1.isHidden = true
            mainView2.isHidden = false
        }else{
            validations()
            mainView1.isHidden = false
            mainView2.isHidden = true
        }
    }
    
    @IBAction func specialityButtonTapped(_ sender: Any) {
        
        let menu = RSSelectionMenu(selectionStyle: .multiple, dataSource: specialtyListArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.selectedNames = selectedItems
            print(selectedItems)
            let items = self.selectedNames.joined(separator:", ")
            if self.selectedNames.count == 1 {
                self.specialitylable.text = items
                self.performUpdateExpiernce()
            } else if self.selectedNames.count >= 2 {
                self.specialitylable.text = items
               self.performUpdateExpiernce()
                self.dismiss(animated: true, completion: nil)
            }
        }
        menu.show(style: .actionSheet(title: nil, action: "Done", height: nil), from: self)
    }
    
    @IBAction func editBankDeatils(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddBankDetailPopUp") as! AddBankDetailPopUp
        vc.modalPresentationStyle = .overFullScreen
        vc.updateBank = true
        vc.delegate = self
        vc.bankDict1 = bankDict
        vc.bankId = bankId
        vc.addBankDetailCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension MyProfileVC {
    func fullProfile(param: [String: String]){
        firstly {
            service!.fullCompleteProfile(parameters: param, header: "DeviceToken")
        }.done { (model: FullProfileDetailModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func validations() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: FullProfileDetailModel) {
        if model.status == "SUCCESS" {
            if model.professionaldetail?.qualification?.count != 0 {
                self.qualification = model.professionaldetail?.qualification ?? [Qualification]()
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
                print("hello")
            }
            if model.professionaldetail?.experience?.count != 0 {
                self.experience = model.professionaldetail?.experience ?? [Experience]()
                if self.experience.count <= 3 {
                    
                    self.expienceViewHeight.constant = CGFloat(self.experience.count * 80)+120
                    self.view.layoutIfNeeded()
                    self.experinceTableView.reloadData()


                }else{
                   
                    self.expienceViewHeight.constant = CGFloat(3 * 80)+120
                    self.view.layoutIfNeeded()
                    self.experinceTableView.reloadData()
                }
                // self.experience.append(contentsOf: model.professionaldetail?.experience ?? [Experience]())
                
                //self.experinceTableView.reloadData()
            } else {
                print("hello")
            }
            
            profileUpdate = ["about": "\(model.professionaldetail?.about ?? "")",
                             "year": "\(model.professionaldetail?.year ?? "")",
                             "month": "\(model.professionaldetail?.month ?? "")",
                             "speciality":"\(model.professionaldetail?.month ?? ""))"]
            
            bankDict = ["bankName": "\(model.professionaldetail?.bank?.first?.bankName ?? "")",
                        "accountName": "\(model.professionaldetail?.bank?.first?.acHolder ?? "")",
                        "accountNumber": "\(model.professionaldetail?.bank?.first?.accountNo ?? "")",
                        "branchName": "\(model.professionaldetail?.bank?.first?.branchName ?? "")"]
            self.bankDetails = model.professionaldetail?.bank ?? [Bank]()
            self.specialitylable.text = model.professionaldetail?.specialty
            self.yearExp.text = "\(model.professionaldetail?.year ?? "") Years"
            self.monthExp.text = "\(model.professionaldetail?.month ?? "") Months"
//            self.bankName.text = model.professionaldetail?.bank?.first?.bankName
//            self.accountName.text = model.professionaldetail?.bank?.first?.acHolder
//            self.accountNumber.text = model.professionaldetail?.bank?.first?.accountNo
//            self.branchName.text = model.professionaldetail?.bank?.first?.branchName
            self.bankName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Bank name:  ".localized(), "\(model.professionaldetail?.bank?.first?.bankName ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.accountName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Account Name:  ".localized(), "\(model.professionaldetail?.bank?.first?.acHolder ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.accountNumber.provideAttributedTextToControlLeftAllignCenterArray(title: ["Account Number:  ".localized(), "\(model.professionaldetail?.bank?.first?.accountNo ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.branchName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Branch Name:  ".localized(), "\(model.professionaldetail?.bank?.first?.acHolder ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            self.bankId = model.professionaldetail?.bank?.first?.id
            self.aboutTxt1.text = model.professionaldetail?.about
            
            //qualificationTableView.reloadData()
           // experinceTableView.reloadData()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension MyProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == qualificationTableView{
            if qualification.count <= 3{
                return qualification.count
            }else{
                return 3
            }
            
        }else if tableView == experinceTableView{
            if experience.count <= 3 {
                return experience.count
            }else{
                return 3
            }
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == qualificationTableView{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: qualificationTableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 50, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Qualification".localized()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .gray
            var imageView : UIImageView
            imageView  = UIImageView(frame: CGRect(x: 20, y: 15, width: 20, height: 20))
            imageView.image = UIImage(named:"Path 6710")
            headerView.addSubview(label)
            headerView.addSubview(imageView)
            return headerView
        }else if tableView == experinceTableView{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: experinceTableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 50, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Experience".localized()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .gray
            var imageView : UIImageView
            imageView  = UIImageView(frame: CGRect(x: 20, y: 15, width: 20, height: 20))
            imageView.image = UIImage(named:"Group 4390")
            headerView.addSubview(label)
            headerView.addSubview(imageView)
            return headerView
        }else{
            return UITableViewCell()
        }
//        if tableView == qualificationTableView {
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: qualificationTableView.frame.width, height: 50))
//            let label = UILabel()
//            label.frame = CGRect.init(x: 50, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//            label.text = "Qualification".localized()
//            label.font = .systemFont(ofSize: 16)
//            label.textColor = .gray
//            var imageView : UIImageView
//            imageView  = UIImageView(frame: CGRect(x: 20, y: 15, width: 20, height: 20))
//            imageView.image = UIImage(named:"Path 6710")
//            headerView.addSubview(label)
//            headerView.addSubview(imageView)
//            return headerView
//        } else if tableView == experinceTableView {
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: experinceTableView.frame.width, height: 50))
//            let label = UILabel()
//            label.frame = CGRect.init(x: 50, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//            label.text = "Current Experience".localized()
//            label.font = .systemFont(ofSize: 16)
//            label.textColor = .gray
//            var imageView : UIImageView
//            imageView  = UIImageView(frame: CGRect(x: 20, y: 15, width: 20, height: 20))
//            imageView.image = UIImage(named:"Path 6630")
//            headerView.addSubview(label)
//            headerView.addSubview(imageView)
//            return headerView
//        }
       // return UITableView()
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == qualificationTableView{
            return 50
        }else if tableView == experinceTableView{
            return 50
        }else{
            return 0
        }
       
    }
    
    private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == qualificationTableView{
            return 50
        }else if tableView == experinceTableView{
            return 50
        }else{
            return 0
        }
       // return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == qualificationTableView{
            return 110
        }else if tableView == experinceTableView{
            return 80
        }else{
            return 0
        }
       
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if tableView == qualificationTableView{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
            let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 140, y: 5, width: 120, height: 36.0))
            //here is what you should add:
            //doneButton.rightAnchor = footerView.rightAnchor
            doneButton.setTitle("Add more".localized(), for: .normal)
            doneButton.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C75BC")
            doneButton.layer.cornerRadius = 5.0
            
            if tableView == qualificationTableView {
                
                doneButton.addTarget(self, action: #selector(self.clickButton), for: .touchUpInside)
            } else {
                doneButton.addTarget(self, action: #selector(self.experinaceButton), for: .touchUpInside)
            }
            footerView.addSubview(doneButton)
            return footerView
        }else if tableView == experinceTableView{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
            let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 140, y: 5, width: 120, height: 36.0))
            //here is what you should add:
            //doneButton.rightAnchor = footerView.rightAnchor
            doneButton.setTitle("Add more".localized(), for: .normal)
            doneButton.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C75BC")
            doneButton.layer.cornerRadius = 5.0
            
            if tableView == qualificationTableView {
                
                doneButton.addTarget(self, action: #selector(self.clickButton), for: .touchUpInside)
            } else {
                doneButton.addTarget(self, action: #selector(self.experinaceButton), for: .touchUpInside)
            }
            footerView.addSubview(doneButton)
            return footerView
        }else{
            return UITableViewCell()
        }
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
//        let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 140, y: 5, width: 120, height: 36.0))
//        //here is what you should add:
//        //doneButton.rightAnchor = footerView.rightAnchor
//        doneButton.setTitle("Add more".localized(), for: .normal)
//        doneButton.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C75BC")
//        doneButton.layer.cornerRadius = 5.0
//
//        if tableView == qualificationTableView {
//
//            doneButton.addTarget(self, action: #selector(self.clickButton), for: .touchUpInside)
//        } else {
//            doneButton.addTarget(self, action: #selector(self.experinaceButton), for: .touchUpInside)
//        }
//        footerView.addSubview(doneButton)
//        return footerView
    }
    
    @objc func clickButton() {
//        if qualification.count >= 3 {
//            Utils.shared.displayAlert(title: "", message: "Can't Add more then three Qualification".localized(), viewController: self)
//        }
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddQualificationPopUp") as! AddQualificationPopUp
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.addQualification = true
        vc.addQuliCallBack = {
            self.dismiss(animated: true, completion: nil)
            self.qualificationTableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func experinaceButton() {
//        if experience.count >= 3 {
//            Utils.shared.displayAlert(title: "", message: "Can't Add more then three Experience".localized(), viewController: self)
//        }
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddExperiencePopUp") as! AddExperiencePopUp
        vc.delegate = self
        vc.addExperience = true
        vc.modalPresentationStyle = .overFullScreen
        vc.addExperienceCallBack = {
            self.dismiss(animated: true, completion: nil)
            self.experinceTableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == qualificationTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QualificationTableViewCell") as! QualificationTableViewCell
            cell.collegeTxt.text = qualification[indexPath.row].institute
            cell.countryLable.text = qualification[indexPath.row].country
            cell.degreeTxt.text = qualification[indexPath.row].degree
            cell.yearLable.text = qualification[indexPath.row].passingYear
            self.qualifiId = qualification[indexPath.row].id
            self.indexPath1 = indexPath
            self.indexRow = indexPath.row
            cell.delegate = self
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.qualificationEditButton), for: .touchUpInside)
            return cell
            
        }else if tableView == experinceTableView{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExperinceTableViewCell") as! ExperinceTableViewCell
            cell1.collegeTxt.text = experience[indexPath.row].institute
            cell1.designationTxt.text = experience[indexPath.row].designation
            self.exprienceId = experience[indexPath.row].id
            cell1.delegate = self
            cell1.editButton.addTarget(self, action: #selector(self.experinaceEditButton), for: .touchUpInside)
            cell1.editButton.tag = indexPath.row
            //cell1.deleteButton.addTarget(self, action: #selector(self.deleteeExperenceTapped), for: .touchUpInside)
            return cell1
        }else{
            return UITableViewCell()
        }
        
    }
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "QualificationTableViewCell") as? QualificationTableViewCell {
//            cell.collegeTxt.text = qualification[indexPath.row].institute
//            cell.countryLable.text = qualification[indexPath.row].country
//            cell.degreeTxt.text = qualification[indexPath.row].degree
//            cell.yearLable.text = qualification[indexPath.row].passingYear
//            self.qualifiId = qualification[indexPath.row].id
//            self.indexPath1 = indexPath
//            self.indexRow = indexPath.row
//            cell.delegate = self
//            cell.editButton.tag = indexPath.row
//            cell.editButton.addTarget(self, action: #selector(self.qualificationEditButton), for: .touchUpInside)
//            return cell
//        }
//        else if let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExperinceTableViewCell") as? ExperinceTableViewCell {
//            cell1.collegeTxt.text = experience[indexPath.row].institute
//            cell1.designationTxt.text = experience[indexPath.row].designation
//            self.exprienceId = experience[indexPath.row].id
//            cell1.delegate = self
//            cell1.editButton.addTarget(self, action: #selector(self.experinaceEditButton), for: .touchUpInside)
//            cell1.editButton.tag = indexPath.row
//            //cell1.deleteButton.addTarget(self, action: #selector(self.deleteeExperenceTapped), for: .touchUpInside)
//            return cell1
//        }
       // return UITableViewCell()
    
    
    
    @objc func qualificationEditButton(sender: UIButton) {
        let index = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddQualificationPopUp") as! AddQualificationPopUp
        vc.qualificationId = qualification[index].id
        vc.delegate = self
        qualficationDict = ["collegeTxt": qualification[index].institute ?? "",
                            "degreeTxt": qualification[index].degree ?? "",
                            "yearLable": qualification[index].passingYear ?? "",
                            "country": qualification[index].country ?? ""]
        vc.qualficationDict1 = qualficationDict
        vc.updateQualification = true
        vc.modalPresentationStyle = .overFullScreen
        vc.addQuliCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func experinaceEditButton(sender: UIButton){
        let index = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddExperiencePopUp") as! AddExperiencePopUp
        vc.updateExpeince = true
        vc.delegate = self
        experinceDict = ["collegeTxt":"\(experience[index].institute ?? "")",
                         "designationTxt":"\(experience[index].designation ?? "")"]
        vc.experinceDict1 = experinceDict
        vc.exprienceId = experience[index].id
        vc.modalPresentationStyle = .overFullScreen
        vc.addExperienceCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension MyProfileVC {
    func updateExpiernce(param: [String: String]){
        firstly {
            service!.updateProfessionalDetails(parameters: param, header: "DeviceToken")
        }.done { (model: UpdateQualificationModel) in
            self.performUpdateExpienence(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
            
        }.finally {
            DispatchQueue.main.async {
               
            }
        }
    }
    
    func performUpdateExpiernce() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        
        for item in 0..<(selectedNames.count) {
            print(selectedNames)
            
            if let specialData = specialtyArray{
                for i in specialData{
                    if selectedNames[item] == i.name{
                        specialtyListIdArray.append(i.id ?? "")
                        print(specialtyListIdArray)
                    }
                }
            }
        }
        
        let selectedIds = specialtyListIdArray.joined(separator: ",")
        parameter = ["language_type": code,
                     "specialty": selectedIds,
                     "id": "\(id ?? "")",
                     "year": "\(yearExp.text ?? "")",
                     "month": "\(monthExp.text ?? "")",
                     "about" :"\(aboutTxt1.text ?? "")"]
        updateExpiernce(param: parameter)
    }
    
    func performUpdateExpienence(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            print(model)
            specialtyListIdArray.removeAll()
            self.selectedNames.removeAll()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
