//
//  AddMoreVisitTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 30/09/21.
//

import UIKit
protocol DeleteAvilabilityDelegate: AnyObject {
    func buttonTapped(cell: AddMoreVisitTableViewCell)
}

protocol EditAvilabilityDelegate: AnyObject {
    func buttonTapped1(cell: AddMoreVisitTableViewCell)
}

class AddMoreVisitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var slotTime: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: DeleteAvilabilityDelegate?
    weak var editDelegate: EditAvilabilityDelegate?
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
    
    @IBAction func editbuttonTapped(_ sender: Any) {
        self.editDelegate?.buttonTapped1(cell: self)
    }
    
}
