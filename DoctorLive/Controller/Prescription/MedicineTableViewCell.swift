//
//  MedicineTableViewCell.swift
//  DoctorLive
//
//  Created by cst on 10/12/21.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineType: UILabel!
    @IBOutlet weak var medicineCompany: UILabel!
    @IBOutlet weak var drugQunatity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
