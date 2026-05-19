//
//  QuestionListViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import UIKit

extension QuestionListViewC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.questionListData.first?.data?.count ?? INTZERO
    }
}

extension QuestionListViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.questionTblVw.dequeueReusableCell(withIdentifier: QuestionCell.className)as! QuestionCell
        let question = self.viewmodel.questionListData.first?.data?[indexPath.row]
        cell.titleLbl.text = question?.title ?? EMPTY
        cell.descriptionLbl.text = question?.description ?? EMPTY
        cell.answerCountLbl.text = "\(question?.totalAnswerCount ?? INTZERO) answers from doctor"
        cell.genderLbl.text = "Asked for \(question?.memberDetails?.gender ?? EMPTY)"
        cell.ageLbl.text = "\(question?.memberDetails?.dob ?? EMPTY) Years"
//            \(Date.timesinceDate(question?.date ?? EMPTY))"
        cell.doctorFourthImage.isHidden = true
        cell.doctorThirdImage.isHidden = true
        cell.doctorSecondImage.isHidden = true
        cell.doctorFirstImage.isHidden = true
        cell.countLbl.isHidden = true
        let doctorCount = question?.doctorImages?.count ?? INTZERO
        if doctorCount > 0 {
            let imageViews = [cell.doctorFourthImage, cell.doctorThirdImage, cell.doctorSecondImage, cell.doctorFirstImage]
            for i in 0..<min(doctorCount, imageViews.count) {
                if let mystring = question?.doctorImages?[i] {
                    let urlNew = mystring.replacingOccurrences(of: " ", with: "%20")
                    imageViews[i]?.isHidden = false
                    imageViews[i]?.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "user_dummy"))
                }
            }
            if doctorCount > imageViews.count {
                cell.countLbl.isHidden = false
                cell.countLbl.text = "+\(doctorCount - imageViews.count)"
            }
        }
        cell.didSelectBtn.tag = indexPath.row
        cell.didSelectBtn.addTarget(self, action: #selector(didSelectBtnTap), for: .touchUpInside)
        return cell
    }
}
