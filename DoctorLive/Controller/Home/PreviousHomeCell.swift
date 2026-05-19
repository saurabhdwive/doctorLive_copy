//
//  PreviousHomeCell.swift
//  DoctorLive
//
//  Created by Kv on 12/09/24.
//

import UIKit

class PreviousHomeCell: UITableViewCell {

    @IBOutlet weak var chatBtn, prescriptionBtn, reasonForCallBtn: UIButton!
    @IBOutlet weak var patientNameLbl, yearGenderLbl, dateLbl, priceLbl, followUpLbl, FollowUpTxt, statusLbl: UILabel!
    @IBOutlet weak var bottomVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.chatBtn, self.prescriptionBtn], cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideShadow1(view: self.bottomVw, shadowColor: UIColor.lightGray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width: -5, height: 5), shadowRadius: 12)
    }
    
}
