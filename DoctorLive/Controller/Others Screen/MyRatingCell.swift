//
//  MyRatingCell.swift
//  DoctorLive
//
//  Created by Kv on 14/11/24.
//

import UIKit

class MyRatingCell: UITableViewCell {

    @IBOutlet weak var fivthStarImg, fourthStarImg, thirdStarImg, secondStarImg, firstStarImg: UIImageView!
    @IBOutlet weak var dateLbl, descriptionLbl, patientNameLbl: UILabel!
    @IBOutlet weak var bottomVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.bottomVw, cornerRadius: 12, borderColor: UIColor.lightGray.cgColor, borderWidth: 0.5)
    }
    
}
