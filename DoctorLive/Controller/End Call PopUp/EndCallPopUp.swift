//
//  EndCallPopUp.swift
//  Easy Health
//
//  Created by Apple on 10/07/24.
//

import UIKit

class EndCallPopUp: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomVw, callVw: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet var parentVw: UIView!
    
    static let instance = EndCallPopUp()
    var endCallButtonCallBack:(()->())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("EndCallPopUp", owner: self, options: nil)
        self.commonInit()
    }
    
    func commonInit() {
        GlobalMethods.shared.provideCornerRadius(view: self.yesBtn, cornerRadius: 10, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.bottomVw, cornerRadius: 16, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.callVw, cornerRadius: self.callVw.bounds.height / 2, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        self.parentVw.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.parentVw.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showAlertViewwPopUp(title: String) -> Void {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        APPLICATION.keyWindow?.layer.add(transition, forKey: nil)
        APPLICATION.keyWindow?.addSubview(self.parentVw)
        self.titleLbl.text = "Are you sure you want to end the call with \(title) ?"
    }
    
    @IBAction func yesBtn_Action(_ sender: Any) {
        UIView.transition(with: self.parentVw, duration: 0.25, options: .transitionCrossDissolve) {
            self.parentVw.removeFromSuperview()
        } completion: { (finish) in
            self.endCallButtonCallBack?()
        }
    }
    
    @IBAction func noBtn_Action(_ sender: Any) {
        UIView.transition(with: self.parentVw, duration: 0.25, options: .transitionCrossDissolve) {
            self.parentVw.removeFromSuperview()
        } completion: { (finish) in
            print("HUIHUI")
        }
    }
}
