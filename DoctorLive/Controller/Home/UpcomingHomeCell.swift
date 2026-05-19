//
//  UpcomingHomeCell.swift
//  DoctorLive
//
//  Created by Kv on 12/09/24.
//

import UIKit

class UpcomingHomeCell: UITableViewCell {

    @IBOutlet weak var videoCallBtn, chatBtn, reasonForCallBtn: UIButton!
    @IBOutlet weak var patientNameLbl, yearGenderLbl, dateLbl: UILabel!
    @IBOutlet weak var bottomVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.videoCallBtn, self.chatBtn], cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideShadow1(view: self.bottomVw, shadowColor: UIColor.lightGray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width: -5, height: 5), shadowRadius: 12)
    }
    
}
