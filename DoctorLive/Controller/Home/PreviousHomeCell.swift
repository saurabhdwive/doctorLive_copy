//
//  PreviousHomeCell.swift
//  DoctorLive
//
//  Created by Kv on 12/09/24.
//

import UIKit

class PreviousHomeCell: UITableViewCell {

    @IBOutlet weak var chatBtn, prescriptionBtn, reasonForCallBtn: UIButton!
    @IBOutlet weak var patientNameLbl, yearGenderLbl, dateLbl, priceLbl, followUpLbl, FollowUpTxt, statusLbl: UILabel!
    @IBOutlet weak var bottomVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.chatBtn, self.prescriptionBtn], cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideShadow1(view: self.bottomVw, shadowColor: UIColor.lightGray.cgColor, shadowOpacity: 0.3, shadowOffset: CGSize(width: -5, height: 5), shadowRadius: 12)
        
        setupRatingView()
    }
    
    lazy var ratingVw: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ButtonBlueColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        // Add height constraint to match the other buttons in the stack view
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let starImg = UIImageView(image: UIImage(systemName: "star.fill"))
        starImg.tintColor = .systemYellow
        starImg.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            starImg.widthAnchor.constraint(equalToConstant: 14),
            starImg.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        
        let innerStack = UIStackView(arrangedSubviews: [starImg, lbl])
        innerStack.axis = .horizontal
        innerStack.spacing = 6
        innerStack.alignment = .center
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(innerStack)
        NSLayoutConstraint.activate([
            innerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            innerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            innerStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 4),
            innerStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -4)
        ])
        
        self.ratingLbl = lbl
        return view
    }()
    
    var ratingLbl: UILabel?
    
    private func setupRatingView() {
        guard let stackView = chatBtn.superview as? UIStackView else { return }
        
        // Remove existing arranged subviews to re-order them: Prescription, Rating, Chat
        stackView.removeArrangedSubview(chatBtn)
        stackView.removeArrangedSubview(prescriptionBtn)
        
        stackView.addArrangedSubview(prescriptionBtn)
        stackView.addArrangedSubview(ratingVw)
        stackView.addArrangedSubview(chatBtn)
        
        // Ensure corner radius is applied to the rating view consistently
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.chatBtn, self.prescriptionBtn, self.ratingVw], cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
    
    func setRating(_ rating: String?) {
        let r = rating ?? "0"
        if r == "0" || r == "0.0" || r.isEmpty {
            ratingVw.isHidden = true
        } else {
            ratingVw.isHidden = false
            ratingLbl?.text = r
        }
    }
}
