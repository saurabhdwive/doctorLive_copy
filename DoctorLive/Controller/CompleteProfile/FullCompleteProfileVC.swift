//
//  FullCompleteProfileVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit
import DropDown
import RSSelectionMenu
import KYDrawerController
import SDWebImage

struct BankDetail1 {
    let bankName, accountNumber, acoountName, branchName: String?
}

class FullCompleteProfileVC: ParentViewController, updateTableViewDelegateProtocol, updateExpiernceDelegateProtocol, updateBankDelegateProtocol {
    
    //MARK:- Outlets
    @IBOutlet weak var btnCompleteProfile : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var imageView : UIImageView!
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
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var bankDetailExpView : UIView!
    @IBOutlet weak var yearExp: UILabel!
    @IBOutlet weak var specialitylable: UILabel!
    @IBOutlet weak var monthExp: UILabel!
    @IBOutlet weak var qualificationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expienceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bankDetail: UILabel!
    
    let dropDown = DropDown()
    var specialtyListArray:[String] = Array()
    var qualifiId: String?
    var exprienceId: String?
    var addQualification: Bool?
    var bankId: String?
    var qualficationDict = [String: String]()
    var experinceDict = [String: String]()
    var bankDict = [String: String]()
    var qualification: [Qualification] = []
    var experience: [Experience] = []
    var bankDetails: [Bank] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        validations()
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
        qualificationTableView.separatorColor = UIColor.gray
        experinceTableView.separatorColor = UIColor.gray
        lblHeading.text = "Complete Profile".localized()
        btnCompleteProfile.setTitle("Complete Profile".localized(), for: .normal)
    }
    
    //MARK:- SetUp UI/UX
    fileprivate func setupUI() {
        // setupLable(["Complete Profile".localized()], [lblHeading], [.left], [.Medium], [18])
        btnCompleteProfile.titleLabel?.font =  AppFont.Medium.size(AppFontName.poppins, size: 17)
        imageView.dropShadow(scale: true)
        imageView.layer.cornerRadius = 10
        medicinView.dropShadow(scale: true)
        yearView.dropShadow(scale: true)
        qulificationView.dropShadow(scale: true)
        currentExpView.dropShadow(scale: true)
        yearView.dropShadow(scale: true)
        monthExpView.dropShadow(scale: true)
        bankDetailExpView.dropShadow(scale: true)
        aboutTextView.dropShadow(scale: true)
    }
    
    @IBAction func selectSpecailityTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCompleteProfilePressed(_ sender: UIButton) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendDataToFirstViewController() {
        self.dismiss(animated: true, completion: nil)
        validations()
        self.experinceTableView.reloadData()
    }
    
    func updateExperience() {
        self.dismiss(animated: true, completion: nil)
        validations()
        self.experinceTableView.reloadData()
    }
    
    func updateBankDelegate() {
        self.dismiss(animated: true, completion: nil)
        validations()
        self.viewWillAppear(true)
    }
    
    @IBAction func yearButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func monthButtonTapped(_ sender: Any) {
        
    }
}

extension FullCompleteProfileVC {
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
                // Loader.hide()
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
    
    func handleResponse(model: FullProfileDetailModel){
        if model.status == "SUCCESS" {
            self.qualificationTableView.reloadData()
            if model.professionaldetail?.qualification?.count != 0 {
                self.qualification = model.professionaldetail?.qualification ?? [Qualification]()
                self.qualificationTableView.reloadData()
            } else {
                print("hello")
            }
            if model.professionaldetail?.experience?.count != 0 {
               self.experience = model.professionaldetail?.experience ?? [Experience]()
                self.experinceTableView.reloadData()
            } else {
                print("hello")
            }
            if self.qualification.count <= 3 {
                self.qualificationViewHeight.constant = CGFloat(self.qualification.count * 120)+70
                self.view.layoutIfNeeded()
                self.qualificationTableView.reloadData()
            } else {
                self.qualificationViewHeight.constant = CGFloat(3 * 120)+70
                self.view.layoutIfNeeded()
                self.qualificationTableView.reloadData()
            }
            if self.experience.count <= 3 {

                self.expienceViewHeight.constant = CGFloat(self.experience.count * 80)+70
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()


            }else{

                self.expienceViewHeight.constant = CGFloat(3 * 80)+70
                self.view.layoutIfNeeded()
                self.experinceTableView.reloadData()
            }
            if let imageUrl = model.professionaldetail?.image {
                imageView.contentMode = .scaleAspectFill
                self.imageView.sd_setImage(with: URL(string:imageUrl))
                
            }
            bankDict = ["bankName": "\(model.professionaldetail?.bank?.first?.bankName ?? "")",
                        "accountName": "\(model.professionaldetail?.bank?.first?.acHolder ?? "")",
                        "accountNumber": "\(model.professionaldetail?.bank?.first?.accountNo ?? "")",
                        "branchName": "\(model.professionaldetail?.bank?.first?.branchName ?? "")"]
            self.bankDetails = model.professionaldetail?.bank ?? [Bank]()
            self.specialitylable.text = model.professionaldetail?.specialty
            self.yearExp.text = "\(model.professionaldetail?.year ?? "") Years"
            self.monthExp.text = "\(model.professionaldetail?.month ?? "") Months"
            self.bankName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Bank Name:  ".localized(), "\(model.professionaldetail?.bank?.first?.bankName ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.accountName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Account Name:  ".localized(), "\(model.professionaldetail?.bank?.first?.acHolder ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.accountNumber.provideAttributedTextToControlLeftAllignCenterArray(title: ["Account Number:  ".localized(), "\(model.professionaldetail?.bank?.first?.accountNo ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            self.branchName.provideAttributedTextToControlLeftAllignCenterArray(title: ["Branch Name:  ".localized(), "\(model.professionaldetail?.bank?.first?.acHolder ?? "")"], titleFont: [UIFont.systemFont(ofSize: 14, weight: .medium), UIFont.systemFont(ofSize: 14, weight: .light)], titleColor: [UIColor.black, UIColor.gray], alignment: [.left, .left])
            
            
   
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.accountNo, forKey: Constants.accountNo)
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.bankName, forKey: Constants.bankName)
            UserDefaults.standard.set(model.professionaldetail?.bank?.first?.id, forKey: Constants.bankId)
            self.bankId = model.professionaldetail?.bank?.first?.id
            self.aboutTextView.text = model.professionaldetail?.about ?? ""
            qualificationTableView.reloadData()
            experinceTableView.reloadData()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension FullCompleteProfileVC: UITableViewDelegate, UITableViewDataSource {

    
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
    

    
    @objc func clickButton() {
        if qualification.count >= 3 {
            Utils.shared.displayAlert(title: "", message: "Can't Add more then three Qualification".localized(), viewController: self)
        }
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
       
        if experience.count >= 3 {
            Utils.shared.displayAlert(title: "", message: "Can't Add more then three Experience".localized(), viewController: self)
        }
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QualificationTableViewCell") as? QualificationTableViewCell {
            qualficationDict = ["collegeTxt":qualification[indexPath.row].institute ?? "",
                                "degreeTxt": qualification[indexPath.row].degree ?? "",
                                "yearLable": qualification[indexPath.row].passingYear ?? "",
                                "country": qualification[indexPath.row].country ?? ""]
            cell.collegeTxt.text = qualification[indexPath.row].institute
            cell.countryLable.text = qualification[indexPath.row].country
            cell.degreeTxt.text = qualification[indexPath.row].degree
            cell.yearLable.text = qualification[indexPath.row].passingYear
            cell.delegate = self
            
            self.qualifiId = qualification[indexPath.row].id
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.editButton.addTarget(self, action: #selector(self.qualificationEditButton), for: .touchUpInside)
            //cell.deleteButton.addTarget(self, action: #selector(self.deleteQualificationTapped), for: .touchUpInside)
            return cell
        } else if let cell1 = tableView.dequeueReusableCell(withIdentifier: "ExperinceTableViewCell") as? ExperinceTableViewCell {
            experinceDict = ["collegeTxt":"\(experience[indexPath.row].institute ?? "")",
                             "designationTxt":"\(experience[indexPath.row].designation ?? "")"]
//            cell1.editButton.isHidden = true
//           cell1.deleteButton.isHidden = true
            cell1.collegeTxt.text = experience[indexPath.row].institute
            cell1.designationTxt.text = experience[indexPath.row].designation
            self.exprienceId = experience[indexPath.row].id
            cell1.deleteButton.isHidden = true
            cell1.editButton.isHidden = true
            cell1.delegate = self
            cell1.editButton.addTarget(self, action: #selector(self.experinaceEditButton), for: .touchUpInside)
        // cell1.deleteButton.addTarget(self, action: #selector(self.deleteeExperenceTapped), for: .touchUpInside)
            return cell1
        }
        return UITableViewCell()
    }

    
    @objc func qualificationEditButton() {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddQualificationPopUp") as! AddQualificationPopUp
        vc.qualificationId = qualifiId
        vc.delegate = self
        vc.qualficationDict1 = qualficationDict
        vc.updateQualification = true
        vc.modalPresentationStyle = .overFullScreen
        vc.addQuliCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func experinaceEditButton() {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddExperiencePopUp") as! AddExperiencePopUp
        vc.updateExpeince = true
        vc.delegate = self
        vc.experinceDict1 = experinceDict
        vc.exprienceId = exprienceId
        vc.modalPresentationStyle = .overFullScreen
        vc.addExperienceCallBack = {
            self.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
}
