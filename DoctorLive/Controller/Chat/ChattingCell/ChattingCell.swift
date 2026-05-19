//
//  ChattingCell.swift
//  StreetTalk
//
//  Created by User on 07/09/21.
//

import UIKit

class ChattingCell: UITableViewCell {
    //MARK:- Outlets
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
