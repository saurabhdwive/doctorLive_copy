//
//  VisitTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 16/09/21.
//

import UIKit

class VisitTableViewCell: UITableViewCell {
    let textView = UITextView(frame: CGRect.zero)
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var prescription: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var reasonForReject: UIButton!
    @IBOutlet weak var resonOfVisit: UIButton!
    
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    var parent = HomeVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.dropShadow(scale: true)
        setupUI()
        resonOfVisit.isHidden = true
       
    }
    func setupUI() {
        reasonForReject.setTitle("Reason For Reject".localized(), for: .normal)
        reportButton.setTitle("Reports".localized(), for: .normal)
        prescription.setTitle("Prescriptions".localized(), for: .normal)
        confirmButton.setTitle("Chat".localized(), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func reportTapped(_ sender: Any) {
    }
    
    @IBAction func perscriptionTapped(_ sender: Any) {
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
       
    }
    @IBAction func rejectButton(_ sender: Any) {
    }
    
}
    

