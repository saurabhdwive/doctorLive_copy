//
//  MyEarningTableViewCell.swift
//  DoctorLive
//
//  Created by cst on 10/10/21.
//

import UIKit

class MyEarningTableViewCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var refernceNum: UILabel!
    @IBOutlet weak var transactionTime: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var amountTxt: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
