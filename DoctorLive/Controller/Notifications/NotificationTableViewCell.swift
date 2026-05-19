//
//  NotificationTableViewCell.swift
//  DoctorLive
//
//  Created by cst on 29/10/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTxt: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var timeTxt: UILabel!
    
    @IBOutlet weak var notificationReadImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.dropShadow(scale: true)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
