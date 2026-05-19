//
//  AvilabilityTableViewswift
//  DoctorLive
//
//  Created by call soft on 28/09/21.
//

import UIKit

class AvilabilityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDsy: UILabel!{
    didSet{
        lblDsy.layer.cornerRadius = 11
        lblDsy.layer.masksToBounds = true
        lblDsy.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }
}
    @IBOutlet weak var slot1Lbl: UILabel!
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 11
            mainView.dropShadow(scale: true)
        }
    }
    @IBOutlet weak var slot2: UILabel!
    @IBOutlet weak var slot1Time: UILabel!
    @IBOutlet weak var slot2Time: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var notAvilableLbl: UILabel!
    
//    var slotsData: Availabilityfetch? {
//        didSet {
//            guard let slotData = slotsData else { return }
//            lblDsy.text = slotData.dayName
//            let flag = slotData.flag
//            let slots = slotData.slots
//
//            if flag == "0" {
//                lblDsy.backgroundColor = .gray
//            } else if flag == "1" {
//                lblDsy.backgroundColor = .red
//            } else if flag == "2" {
//                lblDsy.backgroundColor = .systemGreen
//            }
//            if slots?.count == 0 {
//                slot1Lbl.isHidden = true
//                slot2Time.isHidden = true
//                slot2.isHidden = true
//                slot1Time.isHidden = true
//                notAvilableLbl.isHidden = false
//                notAvilableLbl.text = "Set Availability".localized()
//            }else{
//                slot1Lbl.isHidden = false
//                slot2Time.isHidden = false
//                slot2.isHidden = false
//                slot1Time.isHidden = false
//                notAvilableLbl.isHidden = true
//                notAvilableLbl.text = "Set Availability".localized()
//            }
//            if let slotsArray = slots{
//                print("slotsArray.......\(slotsArray)")
//                if slotsArray.count > 0{
//                    if slotsArray.count > 0 {
//                        let person = slotsArray[0]
//                        if person.availability == "0" {
//                            slot1Time.text = "No Availability".localized()
//                        }
//                        if person.availability == "1" {
//                             slot1Time.text = "\(person.slotFrom ?? "")-\(person.slotTo ?? "")"
//                        }
//                    }
//
//                    if slotsArray.count > 1{
//                        let person = slotsArray[1]
//                        if person.availability == "0" {
//                            slot2Time.text = "No Availability".localized()
//                        }
//
//                        if person.availability == "1" {
//                            slot2Time.text = "\(person.slotFrom ?? "")-\(person.slotTo ?? "")"
//                        }
//
//                    }
//                }else{
//                    //                    slot1Lbl.isHidden = true
//                    //                    slot2Time.isHidden = true
//                    //                    slot2.isHidden = true
//                    //                    slot1Time.isHidden = true
//                    //                    notAvilableLbl.isHidden = false
//                    //                    notAvilableLbl.text = "Set Availability".localized()
//                }
//            }else{
//
//            }
////            for person in slots! {
////                let slotFrom = person.slotFrom ?? ""
////                let slotTo = person.slotTo ?? ""
////                 if person.slot == "1" {
////                    if person.availability == "0" {
////                        slot1Time.text = "Not Avilable".localized()
////                    } else if person.availability == "1" {
////                        slot1Time.text = "\(slotFrom)-\(slotTo)"
////                    }
////                } else if person.slot == "2" {
////                    if person.availability == "0" {
////                        slot2Time.text = "Not Avilable".localized()
////                    } else if person.availability == "1" {
////                        slot2Time.text = "\(slotFrom)-\(slotTo)"
////                    }
////                }
////              }
//           }
//        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.notAvilableLbl.isHidden = true
        slot1Lbl.text = "Slot 1".localized()
        slot2.text = "Slot 2".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
