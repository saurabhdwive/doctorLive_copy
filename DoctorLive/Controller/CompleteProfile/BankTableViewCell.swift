//
//  BankTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import UIKit

class BankTableViewCell: UITableViewCell {
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
}
