//
//  ChatRightTextCell.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import UIKit

class ChatRightTextCell: UITableViewCell {

    @IBOutlet weak var chatTxt, timeLbl: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var chatVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.chatVw, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
    
}
