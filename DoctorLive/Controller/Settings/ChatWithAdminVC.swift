//
//  ChatWithAdminVC.swift
//  DoctorLive
//
//  Created by cst on 21/10/21.
//

import UIKit
import Mobilisten

class ChatWithAdminVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ZohoSalesIQ.showLauncher(true)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let view = UIStoryboard.init(name: "Auth", bundle: nil)
//        let vc = view.instantiateViewController(withIdentifier: "HelpAndSupportVC") as! HelpAndSupportVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
