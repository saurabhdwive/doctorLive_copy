//
//  ClinicsCell.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
protocol DeleteClinicDelegate: AnyObject {
    func buttonTapped(cell: ClinicsCell)
}

protocol EditClinicDelegate: AnyObject {
    func editbuttonTapped(cell: ClinicsCell)
}


class ClinicsCell: UITableViewCell {
    
    @IBOutlet weak var clincPlaceholder: UILabel!
    @IBOutlet weak var adressPlaceholder: UILabel!
    @IBOutlet weak var contactPlaceholder: UILabel!
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var adressTxt: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var parent: MyProfileVC?
    weak var delegate: DeleteClinicDelegate?
    weak var editDelegate: EditClinicDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
         mainView.dropShadow(scale: true)
        clincPlaceholder.text = "Clinic Name".localized()
        adressPlaceholder.text = "Address Ping".localized()
        contactPlaceholder.text = "Contact Number".localized()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.editDelegate?.editbuttonTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)
    }
    
}
