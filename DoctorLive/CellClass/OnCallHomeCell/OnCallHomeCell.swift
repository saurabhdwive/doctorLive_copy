//
//  OnCallHomeCell.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import PromiseKit
protocol CustomTableViewCellDelegate {
   func buttonPress(tag: Int)
}

class OnCallHomeCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var reasonForCall: UIButton!
    @IBOutlet weak var reasonOfVisit: UIButton!
    let textView = UITextView(frame: CGRect.zero)
    var confirm: Bool?
    var reject: Bool?
    var delegate : CustomTableViewCellDelegate?
    
    var parent = HomeVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.dropShadow(scale: true)
        reasonForCall.setTitle("Reason for Call".localized(), for: .normal)
        reasonOfVisit.setTitle("Reason for Visit".localized(), for: .normal)
        confirmButton.setTitle("Confirm".localized(), for: .normal)
        rejectButton.setTitle("Reject".localized(), for: .normal)
        reasonOfVisit.isHidden = true
    }
    
    @IBAction func confirmTapped(_ sender: Any) {

    }
    
    @IBAction func rejectButton(_ sender: Any) {

    }
}
//   extension HomeVC {
//    func confirmBooking(param: [String: String]){
//        firstly {
//            service!.bookingStatus(parameters: param, header: "DeviceToken")
//        }.done { (model: BookingStatusModel) in
//            self.confirmBoking(model: model)
//        }.catch { (error) in
//            DispatchQueue.main.async {
//        }
//            
//        }.finally {
//            DispatchQueue.main.async {
//                // Loader.hide()
//            }
//        }
//    }
//    
//  func performConfirmBooking() {
//        var parameter = [String: String]()
//        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
//    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
//    parameter = ["language_type": code,
//                     "token": token,
//                     "booking_id": "bookingId" ?? "",
//                     "status": "1",
//                     "reason": ""]
//         confirmBooking(param: parameter)
//     }
//    
//    func confirmBoking(model: BookingStatusModel){
//        if model.status == "SUCCESS" {
////            self.validations()
//            self.dismiss(animated: true, completion: nil)
//        } else {
//            AppToast.showMessage(message: model.message ?? "")
//        }
//    }
// }
