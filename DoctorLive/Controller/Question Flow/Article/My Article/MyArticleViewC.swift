//
//  MyArticleViewC.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import UIKit

class MyArticleViewC: UIViewController {
    
    @IBOutlet weak var writeArticleBtn: UIButton!
    @IBOutlet weak var articleTblVw: UITableView!{
        didSet{
            self.articleTblVw.delegate = self
            self.articleTblVw.dataSource = self
        }
    }
    
    var viewmodel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.registerXib()
        self.myArticleApi()
    }
    
    private func setUpViews(){
        GlobalMethods.shared.provideCornerRadius(view: self.writeArticleBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
    
    private func registerXib(){
        self.articleTblVw.register(UINib(nibName: MyArticleCell.className, bundle: nil), forCellReuseIdentifier: MyArticleCell.className)
    }
    
    @IBAction func writeArticleBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getWriteArticleViewC()
        viewC.addDelegate = self
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func backBtn_Actiom(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let viewC = DIConfigurator.sharedInst().getWriteArticleViewC()
        viewC.myArticlesArticles = self.viewmodel.myArticleData.first?.articles?[sender.tag]
        viewC.editDelegate = self
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @objc func deleteBtnTap(_ sender: UIButton){
        self.alertWithHandler1(message: "Are you sure you want to delete this article") {
            self.articleDeleteApi(id: self.viewmodel.myArticleData.first?.articles?[sender.tag].id ?? EMPTY)
        }
    }
}

extension MyArticleViewC: EditWriteArticle, WriteArticle{
    func editWriteArticle() {
        self.myArticleApi()
        self.showToast(message: "Article edit successfully")
    }
    
    func writeArticle() {
        self.myArticleApi()
        self.showToast(message: "Article added successfully")
    }
}
