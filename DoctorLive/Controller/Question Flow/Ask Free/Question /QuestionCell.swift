//
//  QuestionCell.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var doctorFourthImage, doctorThirdImage, doctorSecondImage, doctorFirstImage: UIImageView!
    @IBOutlet weak var ageLbl, titleLbl, descriptionLbl, answerCountLbl, countLbl, genderLbl: UILabel!
    @IBOutlet weak var answerVw, bottomVw, questionVw: UIView!
    @IBOutlet weak var didSelectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.questionVw, cornerRadius: 16, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.bottomVw, cornerRadius: 16, borderColor: UIColor.lightGray.cgColor, borderWidth: 1)
        GlobalMethods.shared.provideThreeCornerRadius(view: self.answerVw, cornerRadius: 16, cornerArray: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.doctorFirstImage, self.doctorSecondImage, self.doctorThirdImage, self.doctorFourthImage], cornerRadius: 12, borderColor: UIColor.white.cgColor, borderWidth: 1)
    }
   
}
