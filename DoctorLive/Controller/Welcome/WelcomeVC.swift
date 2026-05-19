//
//  WelcomeVC.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit

class WelcomeVC: ParentViewController {

    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var profileVerifyTxt: UILabel!
    @IBOutlet weak var welcomeLable: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLable.text = "Welcome to".localized()
        profileVerifyTxt.text = "Your profile is under verification.Please wait, we'll get back to you ASAP.".localized()
        okayButton.setTitle("Done".localized(), for: .normal)
       // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOKeyPressed(_ sender: UIButton) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
   }
}
