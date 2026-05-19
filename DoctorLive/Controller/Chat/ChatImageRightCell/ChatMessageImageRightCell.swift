//
//  ChatMessageImageRightCell.swift
//  StreetTalk
//
//  Created by User on 10/09/21.
//

import UIKit

class ChatMessageImageRightCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
