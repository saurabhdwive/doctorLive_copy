//
//  AnswerAddEditViewC.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class AnswerAddEditViewC: UIViewController {
        
    @IBOutlet weak var titileLbl, daysAgoLbl, descriptionLbl, genderLbl, experienceLbl, questionTitleLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    var questionData = QuestionRootData()
    var viewmodel = ViewModel()
    var comeFromAnswer: Bool = true
    var editStatus: Bool = false
    var answerId: String?
    var callBack: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView(){
        self.answerTxt.delegate = self
        self.questionTitleLbl.text = self.questionData.title ?? EMPTY
        self.daysAgoLbl.text = self.questionData.time ?? EMPTY
        self.descriptionLbl.text = self.questionData.description ?? EMPTY
        self.genderLbl.text = "Asked for \(self.questionData.gender ?? EMPTY)"
        self.experienceLbl.text = "\(self.questionData.age ?? EMPTY) Years"
        GlobalMethods.shared.provideCornerRadius(view: self.postBtn, cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        if self.comeFromAnswer != false {
            self.answerTxt.text = self.questionData.answer ?? EMPTY
            self.postBtn.setTitle("Edit Answer", for: .normal)
            self.answerTxt.isUserInteractionEnabled = false
        }else{
            self.postBtn.setTitle("Post Answer", for: .normal)
        }
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postAnswerBtn_Action(_ sender: Any) {
        guard self.answerTxt.text == EMPTY || self.answerTxt.text ?? EMPTY == "Start typing…" else {
            guard self.comeFromAnswer else {
                self.postAnswerApi()
                return
            }
            guard self.editStatus else{
                self.answerTxt.isUserInteractionEnabled = true
                self.editStatus = true
                self.postBtn.setTitle("Update Answer", for: .normal)
                return
            }
            self.updateAnswerApi(id: self.answerId ?? EMPTY)
            return
        }
        self.showToast(message: "Please enter answer")
    }
}

extension AnswerAddEditViewC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.answerTxt.text == "Start typing…"{
            self.answerTxt.text = EMPTY
            self.answerTxt.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.answerTxt.text == EMPTY{
            self.answerTxt.text = "Start typing…"
            self.answerTxt.textColor = .lightGray
        }
        return true
    }
}

struct QuestionRootData {
    
    var title: String?
    var time: String?
    var description: String?
    var gender: String?
    var age: String?
    var answer: String?
    var questionId: String?
    
    init(title: String? = nil, time: String? = nil, description: String? = nil, gender: String? = nil, age: String? = nil, answer: String? = nil, questionId: String? = nil) {
        self.title = title
        self.time = time
        self.description = description
        self.gender = gender
        self.age = age
        self.answer = answer
        self.questionId = questionId
    }
    
    
}
