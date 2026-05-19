//
//  PersonalProfileEditVC.swift
//  DoctorLive
//
//  Created by call soft on 10/09/21.
//

import UIKit
import PromiseKit
import DropDown
import SwiftyJSON

protocol updateProfileDataDelegate {
    func updateProfile()
}

class PersonalProfileEditVC: UIViewController, MyDataSendingDelegateProtocol {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passportViw: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneNumTxt: UITextField!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var adressView: UIView!
    @IBOutlet weak var adressTxt: UITextField!
    @IBOutlet weak var passportTxt: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerNumTxt: UITextField!
    @IBOutlet weak var addClincButton: UIButton!
    @IBOutlet weak var profileEditTitle: UILabel!
    var adressText: String?
    var profile: String?
    var latitude: String?
    var longitude: String?
    var imageData: Data?
    var gender = String()
    
    var dict1 = [String: String]()
    var delegate: updateProfileDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        profileEditTitle.text = "Update Profile".localized()
       
        if dict1["gender"] == "Male" {
            self.gender = "m"
        } else if dict1["gender"] == "Female" {
            self.gender = "f"
        } else {
            self.gender = "o"
        }
       nameTxt.text = dict1["name"]
        phoneNumTxt.text = dict1["phone"]
        emailTxt.text = dict1["email"]
        dobText.text = dict1["dob"]
        genderText.text = dict1["gender"]
        adressTxt.text = dict1["adress"]
        passportTxt.text = dict1["passNum"]
        registerNumTxt.text = dict1["docNum"]
        nameTxt.placeholder = "Name".localized()
        phoneNumTxt.placeholder = "Phone Number".localized()
        emailTxt.placeholder = "Email".localized()
        dobText.placeholder = "dob".localized()
        genderText.placeholder = "Gender".localized()
        adressTxt.placeholder = "Address".localized()
        passportTxt.placeholder = "Passport Number".localized()
        registerNumTxt.placeholder = "Registration Number".localized()
        addClincButton.setTitle("Update".localized(), for: .normal)
        if let imageUrl = dict1["image"] {
            self.imageView.sd_setImage(with: URL(string:imageUrl))
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.layer.cornerRadius = 10
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.gray.cgColor
            
        }
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        performUpdateQulification()
    }
    
    @IBAction func profileUploadButton(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image in
            guard let self = self else { return }
            self.imageData = image.jpegData(compressionQuality: 0.75) ?? Data()
            LoaderController.sharedInstance.showLoader(view: self.view)
            let fileName = "profile_\(Int(Date().timeIntervalSince1970)).jpg"
            self.getPreSignURL(fileName: fileName)
        }
    }

    private func getPreSignURL(fileName: String) {
        let passDict: [String: Any] = ["filename": fileName, "filetype": "image/jpeg"]
        let apiHandle = ApiHandler()
        let url = Domain.baseUrl().appending(APIEndpoint.signedUrl)
        let header = ApiManager.instance.getHeadeWithJwtToken()
        apiHandle.fetchApiHeaderService(method: .post, url: url, passDict: passDict, header: header) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let status = data["status"].bool ?? false
                    let signedUrlString = data["data"]["signedUrl"].string
                    let publicUrl = data["data"]["publicUrl"].string ?? ""
                    guard status,
                          let signedUrlString = signedUrlString,
                          let uploadURL = URL(string: signedUrlString),
                          let imageData = self.imageData, !imageData.isEmpty else {
                        LoaderController.sharedInstance.removeLoader()
                        AppToast.showMessage(message: data["message"].string ?? "Invalid signed URL or image data")
                        return
                    }
                    let authToken = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
                    self.uploadFileToPresignedUrl(fileData: imageData, uploadUrl: uploadURL, fileName: fileName, authToken: authToken) { [weak self] uploadResult in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            LoaderController.sharedInstance.removeLoader()
                            switch uploadResult {
                            case .success:
                                self.profile = publicUrl
                                self.imageView.sd_setImage(with: URL(string: publicUrl))
                                self.imageView.contentMode = .scaleAspectFill
                                self.imageView.layer.cornerRadius = 10
                            case .failure(let error):
                                AppToast.showMessage(message: error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    LoaderController.sharedInstance.removeLoader()
                    AppToast.showMessage(message: error.localizedDescription)
                }
            }
        }
    }

    private func uploadFileToPresignedUrl(fileData: Data, uploadUrl: URL, fileName: String, authToken: String,
                                         result: @escaping (Swift.Result<Void, Error>) -> Void) {
        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "PUT"
        request.httpBody = fileData
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("\(fileData.count)", forHTTPHeaderField: "Content-Length")
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(NSError(domain: "Upload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                result(.success(()))
            } else {
                result(.failure(NSError(domain: "Upload", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Upload failed with status code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }

    @IBAction func dobButtonTapped(_ sender: Any) {
        openDatePicker()
     }
    
    @IBAction func genderButtonTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Male", "Female", "Others"]
        dropDown.anchorView = sender as? AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
       
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if item == "Male" {
                self?.gender = "m"
                self?.genderText.text = item
            } else if item == "Female" {
                self?.gender = "f"
                self?.genderText.text = item
            } else {
                self?.gender = "o"
                self?.genderText.text = item
            }
           self?.genderText.text = item
        }
    }
    
    @IBAction func AdressButtonTapped(_ sender: Any) {
        let location = LocationViewController()
        location.delegate = self
        self.navigationController?.pushViewController(location, animated: true)
    }
    
    func sendDataToFirstViewController(lat: String) {
        self.latitude = lat
        print(lat)
    }
    
    func sendDataToFirstViewController(long: String) {
        self.longitude = long
        print(long)
    }
    
    func sendDataToFirstViewController(adress: String) {
        self.adressText = adress
        print(adress)
        adressTxt.text = adress
    }
}

extension PersonalProfileEditVC {
    func performUpdateProfile(param: [String: String]){
        firstly {
            service!.updateProfile(parameters: param, header: "DeviceToken")
        }.done { (model: UpdatePersonalDetails) in
            self.updateUserDeatails(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
        }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
 func performUpdateQulification() {
    let token = UserDefaults.standard.string(forKey: Constants.accessToken)
    //let id = UserDefaults.standard.string(forKey: Constants.userId)
    guard let mobileNumber = phoneNumTxt.text else { return }
    guard let name = nameTxt.text else { return }
    guard let email = emailTxt.text else { return }
    guard let dob = dobText.text else { return }
    let gender1 = gender
    let address = adressTxt.text
    let addressLatitude = latitude
    let addressLongitude = longitude
    guard let passportNum = passportTxt.text else { return }
    guard let registrationNum = registerNumTxt.text else { return }
    var parameter = [String: String]()
    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
    parameter = ["language_type": code,
                  "token": token ?? "",
                  "name": name,
                  "email": email,
                  "profile": "\(profile ?? "")",
                  "mobile": mobileNumber,
                  "dob": dob,
                  "gender": "\(gender1)",
                  "address": "\(address ?? "")",
                  "latitude": "\(addressLatitude ?? "")",
                  "longitude": "\(addressLongitude ?? "")",
                  "passport_num": passportNum,
                  "registration_num": registrationNum]
        performUpdateProfile(param: parameter)
     }
    
    func updateUserDeatails(model: UpdatePersonalDetails) {
        if model.status == "SUCCESS" {
            print(model)
            self.delegate?.updateProfile()
            self.navigationController?.popViewController(animated: true)
        } else {
            AppToast.showMessage(message: model.message ?? "")
       }
    }
}
