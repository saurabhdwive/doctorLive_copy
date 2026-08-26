//
//  ChatLeftImageCell.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import UIKit

class ChatLeftImageCell: UITableViewCell {

    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var chatVw: UIView!
    
    var imageBtnTapped: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.chatVw, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.chatImage, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        chatImage.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = 150
            }
            if constraint.firstAttribute == .width {
                constraint.constant = 120
            }
        }
    }
    
    @IBAction func imageBtn_Action(_ sender: Any) {
        self.imageBtnTapped?()
    }
}
