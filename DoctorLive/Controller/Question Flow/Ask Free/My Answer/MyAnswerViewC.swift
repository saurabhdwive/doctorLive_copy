//
//  MyAnswerViewC.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class MyAnswerViewC: UIViewController {
    
    @IBOutlet weak var answerTblVw: UITableView!{
        didSet{
            self.answerTblVw.delegate = self
            self.answerTblVw.dataSource = self
        }
    }
    
    var viewmodel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXib()
        self.myAnswerListApi()
    }
    
    private func registerXib(){
        self.answerTblVw.register(UINib(nibName: QuestionCell.className, bundle: nil), forCellReuseIdentifier: QuestionCell.className)
    }

    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didSelectBtnTap(_ sender: UIButton){
        let question = self.viewmodel.myAnswerListData.first?.data?[sender.tag]
        let viewC = DIConfigurator.sharedInst().getAnswerAddEditViewC()
        viewC.questionData = QuestionRootData(title: question?.title ?? EMPTY, time: question?.hoursAgo ?? EMPTY, description: question?.description ?? EMPTY, gender: question?.memberDetails?.gender ?? EMPTY, age: question?.memberDetails?.dob ?? EMPTY, answer: question?.answers?.first?.answer ?? EMPTY, questionId: question?.questionId ?? EMPTY)
        viewC.comeFromAnswer = true
        viewC.answerId = question?.answers?.first?.id ?? EMPTY
        self.navigationController?.pushViewController(viewC, animated: true)
    }
}
