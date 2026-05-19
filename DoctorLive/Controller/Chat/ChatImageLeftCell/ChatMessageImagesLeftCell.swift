//
//  ChatMessageImagesLeftCell.swift
//  StreetTalk
//
//  Created by User on 10/09/21.
//

import UIKit

class ChatMessageImagesLeftCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUserName.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
