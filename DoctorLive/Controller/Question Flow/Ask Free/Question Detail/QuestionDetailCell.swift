//
//  QuestionDetailCell.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import UIKit

class QuestionDetailCell: UITableViewCell {
    
    @IBOutlet weak var doctorNameLbl, specialityLbl, experienceLbl, hourAgoLbl, answerLbl: UILabel!
    @IBOutlet weak var doctorImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.doctorImage, cornerRadius: 6, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
}
