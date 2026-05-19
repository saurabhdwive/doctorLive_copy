//
//  ChatLeftTextCell.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import UIKit

class ChatLeftTextCell: UITableViewCell {

    @IBOutlet weak var timeLbl, chatTxt: UILabel!
    @IBOutlet weak var chatVw: UIView!
    @IBOutlet weak var chatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.chatVw, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
}
