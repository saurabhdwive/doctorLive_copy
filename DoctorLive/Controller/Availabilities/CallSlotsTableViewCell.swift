//
//  CallSlotsTableViewCell.swift
//  DoctorLive
//
//  Created by apple on 28/02/22.
//

import UIKit

class CallSlotsTableViewCell: UITableViewCell {

    @IBOutlet weak var slotNum: UILabel!
    @IBOutlet weak var slotTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
