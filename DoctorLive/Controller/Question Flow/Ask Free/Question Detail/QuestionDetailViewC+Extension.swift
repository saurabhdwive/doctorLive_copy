//
//  QuestionDetailViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import UIKit

extension QuestionDetailViewC: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.questionDetailData.first?.answers?.count ?? INTZERO
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QuestionDetailViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.questionTblVw.dequeueReusableHeaderFooterView(withIdentifier: QuestionDetailHeader.className)as! QuestionDetailHeader
        let question = self.viewmodel.questionDetailData.first?.question
        header.titileLbl.text = question?.title ?? EMPTY
        header.descriptionLbl.text = question?.description ?? EMPTY
        header.timeLbl.text = question?.hoursAgo ?? EMPTY
        header.genderLbl.text = "Asked for \(question?.memberDetails?.gender ?? EMPTY)"
        header.ageLbl.text = "\(question?.memberDetails?.dob ?? EMPTY) Years"
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.questionTblVw.dequeueReusableCell(withIdentifier: QuestionDetailCell.className)as! QuestionDetailCell
        let answer = self.viewmodel.questionDetailData.first?.answers?[indexPath.row]
        cell.doctorNameLbl.text = answer?.doctorName ?? EMPTY
        cell.specialityLbl.text = answer?.specialtyName ?? EMPTY
        cell.experienceLbl.text = "Experience: \(answer?.doctorExp ?? EMPTY) Years"
        cell.hourAgoLbl.text = answer?.minutesAgo ?? EMPTY
        cell.answerLbl.text = answer?.answer ?? EMPTY
        let mystring = answer?.doctorImage ?? EMPTY
        let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
        cell.doctorImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "user_dummy"))
        return cell
    }
}
