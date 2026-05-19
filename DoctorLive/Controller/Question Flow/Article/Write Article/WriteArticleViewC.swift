//
//  WriteArticleViewC.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import UIKit

class WriteArticleViewC: UIViewController {
    
    @IBOutlet weak var titleArticleLbl, descriptionCountLbl, specialityLbl, titleCountLbl, doctorNameLbl: UILabel!
    @IBOutlet weak var uploadBtn, postArticleBtn: UIButton!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var articleCollectionVw: UICollectionView!{
        didSet{
            self.articleCollectionVw.delegate = self
            self.articleCollectionVw.dataSource = self
        }
    }
    
    var myArticlesArticles: MyArticlesArticles?
    var editDelegate: EditWriteArticle?
    var addDelegate: WriteArticle?
    var viewmodel = ViewModel()
    var photoUri = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.validations()
        self.registerXib()
    }
    
    private func setUpViews(){
        self.updateCharacterCount()
        self.titleTxt.delegate = self
        self.descriptionTxt.delegate = self
        self.doctorNameLbl.text = USER_DEFAULTS.string(forKey: Constants.userName) ?? EMPTY
        let mystring = USER_DEFAULTS.string(forKey: Constants.userImage) ?? EMPTY
        let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
        self.doctorImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.fill"))
        GlobalMethods.shared.provideCornerRadius(view: self.postArticleBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.doctorImage, cornerRadius: 6, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        self.titleTxt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        guard self.myArticlesArticles?.id ?? EMPTY == EMPTY else{
            self.titleTxt.text = self.myArticlesArticles?.title ?? EMPTY
            self.descriptionTxt.text = self.myArticlesArticles?.description ?? EMPTY
            self.titleArticleLbl.text = "Edit Article"
            self.postArticleBtn.setTitle("Edit Article", for: .normal)
            self.myArticlesArticles?.articleImagePaths?.forEach({ Str in
                self.photoUri.append(Str)
            })
            self.articleCollectionVw.reloadData()
            self.updateCharacterCount()
            return
        }
    }
    
    private func registerXib(){
        self.articleCollectionVw.register(UINib(nibName: WriteArticleCell.className, bundle: nil), forCellWithReuseIdentifier: WriteArticleCell.className)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateCharacterCount()
    }

    @IBAction func postArticleBtn_Action(_ sender: Any) {
        guard self.titleTxt.text ?? EMPTY == EMPTY else {
            guard self.descriptionTxt.text ?? EMPTY == EMPTY || self.descriptionTxt.text == "Start typing…" else {
                guard self.photoUri.count == 0 else {
                    guard self.myArticlesArticles?.id ?? EMPTY == EMPTY else{
                        self.editArticleApi(id: self.myArticlesArticles?.id ?? EMPTY)
                        return
                    }
                    self.postArticleApi()
                    return
                }
                self.showToast(message: "Please add attachments")
                return
            }
            self.showToast(message: "Please enter description")
            return
        }
        self.showToast(message: "Please enter title")
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func uploadBtnTap(_ sender: UIButton){
        ImagePickerManager().pickImage(self) { image in
            LoaderController.sharedInstance.showLoader(view: self.view)
            AWSS3Manager.shared.uploadImage(image: image, progress: nil) { (sucess, error) in
                LoaderController.sharedInstance.removeLoader()
                print(sucess ?? EMPTY)
                self.photoUri.append(sucess ?? EMPTY)
                self.showToast(message: "Image upload successfully")
                self.articleCollectionVw.reloadData()
            }
        }
    }
    
    @objc func crossBtnTap(_ sender: UIButton){
        self.photoUri.remove(at: sender.tag)
        self.articleCollectionVw.reloadData()
    }
}

protocol EditWriteArticle{
    func editWriteArticle()
}

protocol WriteArticle {
    func writeArticle()
}

extension WriteArticleViewC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.descriptionTxt.text == "Start typing…"{
            self.descriptionTxt.text = EMPTY
            self.descriptionTxt.textColor = .black
        }
        self.updateCharacterCount()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.descriptionTxt.text == EMPTY{
            self.descriptionTxt.text = "Start typing…"
            self.descriptionTxt.textColor = .lightGray
        }
        self.updateCharacterCount()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
}

extension WriteArticleViewC: UITextFieldDelegate{
    func updateCharacterCount() {
        let summaryCount = self.titleTxt.text?.count ?? 0
        let descriptionCount = self.descriptionTxt.text?.count ?? 0

       self.titleCountLbl.text = "\((0) + summaryCount)/40"

       self.descriptionCountLbl.text = "\((0) + descriptionCount)/100"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if(textField == self.titleTxt){
            return (textField.text?.count ?? 0) +  (string.count - range.length) <= 40
        }else if(textField == self.descriptionTxt){
            return (textField.text?.count ?? 0) +  (string.count - range.length) <= 100
        }
        return false
    }
}
