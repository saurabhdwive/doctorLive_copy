//
//  ExperinceTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import UIKit

protocol DeleteExperinceDelegate: AnyObject {
    func buttonTapped(cell: ExperinceTableViewCell)
}

class ExperinceTableViewCell: UITableViewCell {

    @IBOutlet weak var designationTxt: UILabel!
    @IBOutlet weak var collegeTxt: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var passingYearTxt: UILabel!
    
    var parent: MyProfileVC?
    weak var delegate: DeleteExperinceDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
}
