//
//  CompleteProfileVC.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit
import DropDown
import RSSelectionMenu

class CompleteProfileVC: ParentViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, updateTableViewDelegateProtocol, updateExpiernceDelegateProtocol, updateBankDelegateProtocol, updateYearsExpiernceDelegateProtocol, updateAboutDelegateProtocol {
    
    //MARK:- Outlets
    
    @IBOutlet weak var completeProfileLbl: UILabel!
    @IBOutlet weak var btnCompleteProfile : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var imageView : UIView!
    @IBOutlet weak var uploadLable: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var speaclityView : UIView!
    // @IBOutlet weak var qulificationView : UIView!
    //@IBOutlet weak var currentExpView : UIView!
    @IBOutlet weak var yearView : UIView!
    @IBOutlet weak var monthExpView : UIView!
    @IBOutlet weak var specialityTxtField: UITextField!
    // @IBOutlet weak var qualificationTxtField: UITextField!
    @IBOutlet weak var yearsTxtField: UITextField!
    // @IBOutlet weak var currentExpienceTxt: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var bankDetailExpView : UIView!
    @IBOutlet weak var bankDetailsText: UITextField!
    @IBOutlet weak var aboutYouText: UITextView!
    @IBOutlet weak var callFeeButton: UIButton!
    @IBOutlet weak var visitFeeButton: UIButton!
    @IBOutlet weak var callFeeTxtField: UILabel!
    @IBOutlet weak var callFeeView: UIView!
    @IBOutlet weak var visitLbl: UILabel!
    @IBOutlet weak var callTextField: UITextField!
    @IBOutlet weak var visitFeeView: UIView!
    @IBOutlet weak var visitFeeTextField: UITextField!
    @IBOutlet weak var backButtonTapped: UIButton!
    @IBOutlet weak var aboutYouView: UIView!
    @IBOutlet weak var aboutYouHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    
    var specialtyListIdArray: [String] = Array()
    var finalSeletedListId: [String] = Array()
    var selectedNames: [String] = []
    var specialtyArray:[SpecialtyList]?
    var specialtyListArray:[String] = []
    
    var imageData: Data?
    var checkBtn: Bool? = false
    var specilityId = String()
    var call: Int?
    var visit: Int?
    var imagePicker = UIImagePickerController()
    var ApiIMageUrl: String?
    public var completeProfile1: Bool?
    
    var qualification: [Qualification] = []
    var experience: [Experience] = []
    @IBOutlet weak var qualificationTableView: UITableView!
    @IBOutlet weak var experinceTableView: UITableView!
    @IBOutlet weak var expienceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qualificationViewHeight: NSLayoutConstraint!
    var qualficationDict = [String: String]()
    var experinceDict = [String: String]()
    var bankDict = [String: String]()
    var indexPath1: IndexPath?
    var indexRow: Int?
    var exprienceId: String?
    var qualifiId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        validations()
        callFeeView.isHidden = true
        visitFeeView.isHidden = true
        imageView.layer.cornerRadius = 10
        aboutYouText.delegate = self
        aboutYouText.textColor = UIColor.lightGray
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SetUp UI/UX
    fileprivate func setupUI() {
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        //setupLable(["Complete Profile".localized()], [lblHeading], [.left], [.Medium], [20])
        btnCompleteProfile.setTitle("Complete Profile".localized(), for: .normal)
        specialityTxtField.placeholder = "Select Specialty (max. 2)".localized()
        aboutYouText.text = "About Me".localized()
        //  qualificationTxtField.placeholder = "Qualification".localized()
        // currentExpienceTxt.placeholder = "Current Experience".localized()
        yearsTxtField.placeholder = "-- years".localized()
        monthTextField.placeholder = "-- months".localized()
        yearsTxtField.textColor = UIColor(named: "textColour")
        monthTextField.textColor = UIColor(named: "textColour")
        bankDetailsText.placeholder = "bank details".localized()
        completeProfileLbl.text = "Complete Profile".localized()
        callTextField.placeholder = "Call Fee".localized()
        callFeeTxtField.text = "Call Fee".localized()
        visitLbl.text = "Visit Fee".localized()
        uploadLable.text = "Upload Photo".localized()
        btnCompleteProfile.titleLabel?.font =  AppFont.Medium.size(AppFontName.poppins, size: 20)
        imageView.dropShadow(scale: true)
        speaclityView.dropShadow(scale: true)
        qualificationTableView.dropShadow(scale: true)
        experinceTableView.dropShadow(scale: true)
        yearView.dropShadow(scale: true)
        monthExpView.dropShadow(scale: true)
        bankDetailExpView.dropShadow(scale: true)
        callFeeView.dropShadow(scale: true)
        visitFeeView.dropShadow(scale: true)
        aboutYouView.dropShadow(scale: true)
        profileImage.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 15
        qualificationTableView.separatorColor = UIColor.lightGray
        experinceTableView.separatorColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        qualificationTableView.register(UINib(nibName: "QualificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "QualificationTableViewCell")
        experinceTableView.register(UINib(nibName: "ExperinceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ExperinceTableViewCell")
        qualificationTableView.delegate = self
        qualificationTableView.dataSource = self
        experinceTableView.delegate = self
        experinceTableView.dataSource = self
        self.qualificationTableView.reloadData()
        self.experinceTableView.reloadData()
        self.experinceTableView.isScrollEnabled = false
        self.qualificationTableView.isScrollEnabled = false
        
        getProfileDetails()
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        ImagePickerManager().pickImage(self) { image in
           // LoaderController.sharedInstance.showLoader(view: self.view)
            self.imageData = (image.jpegData(compressionQuality: 0.75) ?? Data())
            AWSS3Manager.shared.uploadImage(image: image, progress: nil) { (sucess, error) in
                Indicator.shared.hideProgressView()
                self.ApiIMageUrl = sucess
                self.profileImage.contentMode = .scaleAspectFill
                self.cameraImage.isHidden = true
                self.uploadLable.isHidden = true
                self.profileImage.image = image
            }
        }
    }
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profileImage.contentMode = .scaleAspectFill
            self.cameraImage.isHidden = true
            self.uploadLable.isHidden = true
            profileImage.image = pickedImage
            self.imageData = (pickedImage.jpegData(compressionQuality: 0.75) ?? Data())
            AWSS3Manager.shared.uploadImage(image: pickedImage, progress: nil) { (sucess, error) in
                Indicator.shared.hideProgressView()
                self.ApiIMageUrl = sucess
                UserDefaults.standard.set(sucess, forKey: Constants.userImage)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if aboutYouText.textColor == UIColor.lightGray {
            aboutYouText.text = nil
            aboutYouText.textColor = UIColor.gray
        }
    }
    
    func sendDataToFirstViewController() {
        self.dismiss(animated: true, completion: nil)
        getProfileDetails()
        //self.qualificationTableView.reloadData()
    }
    
    func updateExperience() {
        self.dismiss(animated: true, completion: nil)
        getProfileDetails()
        //self.experinceTableView.reloadData()
    }
    
    func updateBankDelegate() {
        self.dismiss(animated: true, completion: nil)
        getProfileDetails()
        self.viewWillAppear(true)
    }
    
    func updateYearsExperience() {
        getProfileDetails()
    }
    
    func updateAboutExperience() {
        getProfileDetails()
    }
    
    func updateProfile() {
        
    }
    @IBAction func callFeeButtonTapped(_ sender: Any) {
        if callFeeButton.isSelected == true {
            self.callFeeView.isHidden = false
            self.checkBtn = true
            self.call = 1
            self.callFeeButton.setImage(UIImage(named: "checke"), for: .normal)
        } else {
            self.callFeeView.isHidden = true
            self.checkBtn = false
            self.call = 0
            self.callFeeButton.setImage(UIImage(named: "Rectangle 701"), for: .normal)
        }
        callFeeButton.isSelected = !callFeeButton.isSelected
    }
    
    @IBAction func visitFeeButtonTapped(_ sender: Any) {
        if visitFeeButton.isSelected == true {
            self.visitFeeView.isHidden = false
            self.checkBtn = true
            self.visit = 1
            self.visitFeeButton.setImage(UIImage(named: "checke"), for: .normal)
        } else {
            self.visitFeeView.isHidden = true
            self.checkBtn = false
            self.visit = 0
            self.visitFeeButton.setImage(UIImage(named: "Rectangle 701"), for: .normal)
        }
        visitFeeButton.isSelected = !visitFeeButton.isSelected
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
                self.specialityTxtField.text = items
                self.performUpdateExpiernce()
            } else if self.selectedNames.count >= 2 {
                self.specialityTxtField.text = items
                self.performUpdateExpiernce()
                self.dismiss(animated: true, completion: nil)
            }
        }
        menu.show(style: .actionSheet(title: nil, action: "Done", height: nil), from: self)
      
    }
    
    @IBAction func qualification(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddQualificationPopUp") as! AddQualificationPopUp
        let navi = UINavigationController(rootViewController: vc)
        vc.controller = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        //        vc.callback = { text in self.qualificationTxtField.text = text
        //            self.dismiss(animated: true, completion: nil)
        //        }
        self.present(navi, animated: true, completion: nil)
    }
    
    @IBAction func experienceButton(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddExperiencePopUp") as! AddExperiencePopUp
        let navi = UINavigationController(rootViewController: vc)
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        //        vc.experencecallback = {
        //            text in self.currentExpienceTxt.text = text
        //            self.dismiss(animated: true, completion: nil)
        //        }
        self.present(navi, animated: true, completion: nil)
    }
    
    @IBAction func yearButtonTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource =   ["0 year","1 year","2 years","3 years" ,"4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years","13 years","14 years","15 years","16 years","17 years","18 years","19 years","20 years","21 years","22 years","23 years","24 years","25 years","26 years","27 years","28 years","29 years","30 years","31 years","32 years","33 years","34 years","35 years","36 years","37 years","38 years","39 years","40 years","41 years","42 years","43 years","44 years","45 years","46 years","47 years","48 years","49 years","50 years","50+ years"]
        
        dropDown.show()
        dropDown.direction = .bottom
        //dropDown.backgroundColor = .white
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            //  let choosevalue = item
            self.yearsTxtField.text =  item
        }
    }
    
    @IBAction func monthButtonTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["0 month","1 month","2 month","3 month","4 month","5 month","6 month","7 month","8 month","9 month","10 month","11 month"]
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.anchorView = sender as? AnchorView
        dropDown.selectionAction = { [unowned self] (index, item) in
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            self.monthTextField.text =  item
        }
    }
    
    @IBAction func bankDetailTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddBankDetailPopUp") as! AddBankDetailPopUp
        let navi = UINavigationController(rootViewController: vc)
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        vc.bankDetailsCallback = {
            text in self.bankDetailsText.text = text
            
            self.dismiss(animated: true, completion: nil)
        }
        self.present(navi, animated: true, completion: nil)
    }
    
    @IBAction func btnCompleteProfilePressed(_ sender: UIButton) {
        performCompleteProfile()
    }
}

extension CompleteProfileVC {
    func doctorSpeciality(param: [String: String]) {
        firstly {
            service!.speciality(parameters: param, header: "DeviceToken")
        }.done { (model: DoctorSpeciality) in
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
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code]
        doctorSpeciality(param: parameter)
    }
    
    func handleResponse(model: DoctorSpeciality){
        if model.status == "SUCCESS"{
            if let specialData = model.specialtyList{
                //self.specialtyListArray = specialData//model.specialtyList ?? [SpecialtyList]()
                specialtyArray = specialData
                for person in specialData {
                    specialtyListArray.append(person.name ?? "")
                    //specialtyListIdArray.append(person.id ?? "")
                }
            }else{
                AppToast.showMessage(message: model.message ?? "")
            }
        }
    }
}

extension CompleteProfileVC {
    func addCompleteProfile(param: [String: String]) {
        firstly {
            service!.completeProfile(parameters: param, header: "DeviceToken")
        }.done { (model: AddCompleteDetail) in
            self.handleCompleteResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performCompleteProfile() {
        for item in 0..<(selectedNames.count) {
            if let specialData = specialtyArray{
                for i in specialData {
                    if selectedNames[item] == i.name{
                        specialtyListIdArray.append(i.id ?? "")
                        print(specialtyListIdArray)
                    }
                }
            }
        }
        
        
        let finalArrayOfId = finalSeletedListId.suffix(2)
        print(finalArrayOfId)
        let selectedIds = finalArrayOfId.joined(separator: ",")
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        if self.specialityTxtField.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please select speciality".localized())
        } else if self.profileImage.image == nil  {
            AppToast.showMessage(message: "please upload your image".localized())
        } else if self.qualification.count == 0 {
            AppToast.showMessage(message: "Please Fill your qualification".localized())
        } else if self.experience.count == 0 {
            AppToast.showMessage(message: "Please Fill your Experience".localized())
        } else if self.yearsTxtField.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Fill your Experience in Years".localized())
        } else if self.monthTextField.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Fill your Experience in months".localized())
        } else if self.bankDetailsText.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Fill your bank details".localized())
        } else if self.aboutYouText.text == "About Me"{
            AppToast.showMessage(message: "Please Add something About you".localized())
        } else if self.visitFeeButton.isSelected == true {
            AppToast.showMessage(message: "Please Add mode of payment".localized())
        } else if self.callTextField.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Fill your Fees".localized())
        } else {
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            var parameter = [String: String]()
            parameter = ["language_type": code,
                         "id": "\(id ?? "")",
                         "specialty": "\(selectedIds)",
                         "year": "\(yearsTxtField.text ?? "")",
                         "month": "\(monthTextField.text?.first?.description ?? "")",
                         "image": "\(ApiIMageUrl ?? "")",
                         "call_fees": "\(callTextField.text ?? "")",
                         "call": "\(call ?? 0)",
                         "visit_fees": "\(visitFeeTextField.text ?? "")",
                         "visit": "\(visit ?? 0)",
                         "about": "\(aboutYouText.text ?? "")"]
            addCompleteProfile(param: parameter)
        }
    }
    
    func handleCompleteResponse(model: AddCompleteDetail){
        if model.status == "SUCCESS" {
            let isLogin = true
            let view = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = view.instantiateViewController(withIdentifier: "FullCompleteProfileVC") as! FullCompleteProfileVC
            //UserDefaults.standard.set(isLogin, forKey: Constants.accountStatus)
            vc.specialtyListArray = specialtyListArray
            specialtyListIdArray.removeAll()
            self.selectedNames.removeAll()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
extension CompleteProfileVC {
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
    
    func getProfileDetails() {
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
            
            
            // self.bankDetails = model.professionaldetail?.bank ?? [Bank]()
            self.specialityTxtField.text = model.professionaldetail?.specialty
           // self.yearsTxtField.text = "\(model.professionaldetail?.year ?? "")"
          //  self.monthTextField.text = "\(model.professionaldetail?.month ?? "")"
            self.bankDetailsText.text = model.professionaldetail?.bank?.first?.bankName
            //self.aboutYouText.text = model.professionaldetail?.about
            //            self.accountNumber.text = model.professionaldetail?.bank?.first?.accountNo
            //            self.branchName.text = model.professionaldetail?.bank?.first?.branchName
            //            self.bankId = model.professionaldetail?.bank?.first?.id
            
            
            qualificationTableView.reloadData()
            experinceTableView.reloadData()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
extension CompleteProfileVC: UITableViewDelegate, UITableViewDataSource {
    
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
            
        }else if tableView == experinceTableView {
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
        if tableView == qualificationTableView {
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
        } else if tableView == experinceTableView {
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
        }
        return UITableView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
        if tableView == qualificationTableView {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
            let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 140, y: 5, width: 105, height: 32.0))
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
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50.0))
            let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 140, y: 5, width: 105, height: 32.0))
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
        }
        
    }
    
    @objc func clickButton() {
        //        if qualification.count >= 3 {
        //           Utils.shared.displayAlert(title: "", message: "Can't Add more then three Qualification".localized(), viewController: self)
        //            //qualificationViewHeight.constant = 450
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
        //            //expienceViewHeight.constant = 390
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QualificationTableViewCell") as? QualificationTableViewCell {
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
            //cell.deleteButton.addTarget(self, action: #selector(self.deleteQualificationTapped), for: .touchUpInside)
            return cell
        } else if let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExperinceTableViewCell") as? ExperinceTableViewCell {
            cell1.collegeTxt.text = experience[indexPath.row].institute
            cell1.designationTxt.text = experience[indexPath.row].designation
            self.exprienceId = experience[indexPath.row].id
            cell1.delegate = self
            cell1.editButton.addTarget(self, action: #selector(self.experinaceEditButton), for: .touchUpInside)
            cell1.editButton.tag = indexPath.row
            cell1.passingYearTxt.text = experience[indexPath.row].year
            self.exprienceId = experience[indexPath.row].id
            //cell1.deleteButton.addTarget(self, action: #selector(self.deleteeExperenceTapped), for: .touchUpInside)
            return cell1
        }
        return UITableViewCell()
    }
    
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
extension CompleteProfileVC: CellSubclassDelegate, DeleteExperinceDelegate {
    func buttonTapped(cell: QualificationTableViewCell) {
        if qualification.count == 1 {
            Utils.shared.displayAlert(title: "", message: "Add one more to delete the Qualification".localized(), viewController: self)
        }
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.qualificationTableView.indexPath(for: cell) else {
                return
            }
           // self.qualification.remove(at: indexPath.)
           // self?.qualificationTableView.beginUpdates()
            self?.qualification.remove(at: indexPath.row)
//            self?.qualificationTableView.deleteRows(at: [indexPath], with: .bottom)
//            self?.qualificationTableView.endUpdates()
            self?.performDeleteQulification()
            self?.qualificationTableView.reloadData()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self]_ in
            self.qualificationTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    func buttonTapped(cell: ExperinceTableViewCell) {
        if experience.count == 1 {
            Utils.shared.displayAlert(title: "", message: "Add one more to delete the Experience".localized(), viewController: self)
        }
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self]_ in
            //guard let strongSelf = self else { return }
            guard let indexPath = self?.experinceTableView.indexPath(for: cell) else {
                return
            }
            //self?.experinceTableView.beginUpdates()
            self?.experience.remove(at: indexPath.row)
            //self?.experinceTableView.deleteRows(at: [indexPath], with: .bottom)
            //self?.experinceTableView.endUpdates()
            self?.performDeleteExperience()
            self?.experinceTableView.reloadData()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self]_ in
            self.experinceTableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
}
extension CompleteProfileVC {
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
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension CompleteProfileVC {
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
            if self.experience.count <= 3 {
                
                self.expienceViewHeight.constant = CGFloat(self.experience.count * 80)+120
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()
                
                
            }else{
                
                self.expienceViewHeight.constant = CGFloat(3 * 80)+120
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
extension CompleteProfileVC {
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
                        finalSeletedListId.append(i.id ?? "")
                        print(specialtyListIdArray)
                    }
                }
            }
        }
        
        let selectedIds = specialtyListIdArray.joined(separator: ",")
        parameter = ["language_type": code,
                     "specialty": selectedIds,
                     "id": "\(id ?? "")",
                     "year": "1 year",
                     "month": "2 months",
                     "about" :"\(aboutYouText.text ?? "")"]
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
