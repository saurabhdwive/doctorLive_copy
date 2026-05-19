//
//  PastTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 17/09/21.
//

import UIKit

class PastTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var prescription: UIButton!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var reasonForReject: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var chatButtonTapped: UIButton!
    @IBOutlet weak var prescriptionTapped: UIButton!
    @IBOutlet weak var rejectLable: UILabel!
    @IBOutlet weak var reasonOfVisit: UIButton!
    var parent1 = UpcomingBookingVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        reasonOfVisit.isHidden = true
        mainView.dropShadow(scale: true)
        chatButtonTapped.layer.cornerRadius = 6
        prescription.layer.cornerRadius = 6
        rejectLable.isHidden = true
       // rejectLable.text = "Reject".localized()
       // reasonForReject.setTitle("Reason for Call".localized(), for: .normal)
        prescriptionTapped.setTitle("Generate Prescription".localized(), for: .normal)
        chatButton.setTitle("Chat".localized(), for: .normal)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func prescriptionTapped(_ sender: Any) {
        
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {
        
    }
}
