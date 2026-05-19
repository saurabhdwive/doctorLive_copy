//
//  ChatMessageLeftCell.swift
//  StreetTalk
//
//  Created by User on 09/09/21.
//

import UIKit

class ChatMessageLeftCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblUserName:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblUserName.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
