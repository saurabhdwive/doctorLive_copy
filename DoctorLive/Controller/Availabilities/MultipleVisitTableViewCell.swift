//
//  MultipleVisitTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 30/09/21.
//

import UIKit

class MultipleVisitTableViewCell: UITableViewCell {

    @IBOutlet weak var slotTxt: UILabel!
    @IBOutlet weak var slotLbl: UILabel!
    @IBOutlet weak var clinicTxt: UILabel!
    @IBOutlet weak var clinicName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slotLbl.text = "Slot".localized()
        clinicTxt.text = "Clinic".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
