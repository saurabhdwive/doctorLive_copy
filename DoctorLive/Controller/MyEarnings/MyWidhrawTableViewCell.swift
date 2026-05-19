//
//  MyWidhrawTableViewCell.swift
//  DoctorLive
//
//  Created by cst on 10/10/21.
//

import UIKit

class MyWidhrawTableViewCell: UITableViewCell {

    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var refernceNum: UILabel!
    @IBOutlet weak var accountNum: UILabel!
    @IBOutlet weak var transactionTime: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var amountTxt: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
