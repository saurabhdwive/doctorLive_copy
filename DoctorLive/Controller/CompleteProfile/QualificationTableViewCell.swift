//
//  QualificationTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import UIKit
protocol CellSubclassDelegate: AnyObject {
    func buttonTapped(cell: QualificationTableViewCell)
}

class QualificationTableViewCell: UITableViewCell {
    var parent: MyProfileVC?
    weak var delegate: CellSubclassDelegate?
   
    @IBOutlet weak var degreeTxt: UILabel!
    @IBOutlet weak var collegeTxt: UILabel!
    @IBOutlet weak var yearLable: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
       
      }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)
    }
    
}
