//
//  QuestionDetailViewC.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class QuestionDetailViewC: UIViewController {

    @IBOutlet weak var writeAnswerBtn: UIButton!
    @IBOutlet weak var questionTblVw: UITableView!{
        didSet{
            self.questionTblVw.delegate = self
            self.questionTblVw.dataSource = self
        }
    }
    
    var viewmodel = ViewModel()
    var questionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.registerXib()
        self.questionDetailApi()
    }
    
    private func setUpViews(){
        GlobalMethods.shared.provideCornerRadius(view: self.writeAnswerBtn, cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
    
    private func registerXib(){
        self.questionTblVw.register(UINib(nibName: QuestionDetailHeader.className, bundle: nil), forHeaderFooterViewReuseIdentifier: QuestionDetailHeader.className)
        self.questionTblVw.register(UINib(nibName: QuestionDetailCell.className, bundle: nil), forCellReuseIdentifier: QuestionDetailCell.className)
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func writeAnswerBtn_Action(_ sender: Any) {
        let question = self.viewmodel.questionDetailData.first?.question
        let viewC = DIConfigurator.sharedInst().getAnswerAddEditViewC()
        viewC.questionData = QuestionRootData(title: question?.title ?? EMPTY, time: question?.hoursAgo ?? EMPTY, description: question?.description ?? EMPTY, gender: question?.memberDetails?.gender ?? EMPTY, age: question?.memberDetails?.dob ?? EMPTY, answer: EMPTY, questionId: question?.id ?? EMPTY)
        viewC.comeFromAnswer = false
        viewC.callBack = {
            self.showToast(message: "Answer added successfully")
            self.questionDetailApi()
        }
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
}
