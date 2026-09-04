//
//  QuestionListViewC.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class QuestionListViewC: UIViewController {
    
    @IBOutlet weak var questionTblVw: UITableView!{
        didSet{
            self.questionTblVw.delegate = self
            self.questionTblVw.dataSource = self
        }
    }
    
    var viewmodel = ViewModel()
    var currentPage = 1
    var isFetching = false
    var isLastPage = false
    var dataList = [QuestionListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXib()
        self.questionListApi()
    }
    
    private func registerXib(){
        self.questionTblVw.register(UINib(nibName: QuestionCell.className, bundle: nil), forCellReuseIdentifier: QuestionCell.className)
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myAnswertBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getMyAnswerViewC()
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @objc func didSelectBtnTap(_ sender: UIButton){
        let viewC = DIConfigurator.sharedInst().getQuestionDetailViewC()
        viewC.questionId = self.dataList[sender.tag].questionId ?? EMPTY
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
}
