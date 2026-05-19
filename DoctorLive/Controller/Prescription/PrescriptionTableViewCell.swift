//
//  PrescriptionTableViewCell.swift
//  DoctorLive
//
//  Created by cst on 12/10/21.
//

import UIKit

protocol DeletePresecriptionDelegate: AnyObject {
    func buttonTapped(cell: PrescriptionTableViewCell)
}
protocol EditPresecriptionDelegate: AnyObject {
    func buttonEditTapped(cell: PrescriptionTableViewCell)
}


class PrescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var pediatric: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    weak var delegate: DeletePresecriptionDelegate?
    weak var editDelegate: EditPresecriptionDelegate?
    override func awakeFromNib(){
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   }
    
    @IBAction func deleteButton(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)
    }
    
    @IBAction func editButton(_ sender: Any) {
        self.editDelegate?.buttonEditTapped(cell: self)
    }
    
}
