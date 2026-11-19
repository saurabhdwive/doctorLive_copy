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
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        mainView.backgroundColor = .white
        medicineName.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        medicineName.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        medicineName.numberOfLines = 0
        
        if let pencilImg = UIImage(systemName: "pencil") {
            editButton.setImage(pencilImg, for: .normal)
            editButton.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        }
        if let trashImg = UIImage(systemName: "trash") {
            deleteButton.setImage(trashImg, for: .normal)
            deleteButton.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)
        }
        
        pediatric.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        frequency.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        duration.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        meal.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
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
