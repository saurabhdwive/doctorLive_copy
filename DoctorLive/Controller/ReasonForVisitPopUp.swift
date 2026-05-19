//
//  ReasonForVisitPopUp.swift
//  DoctorLive
//
//  Created by cst on 11/10/21.
//


import Foundation
import UIKit

class ReasonForVisitPopUp: UIViewController {
    
    var addBookingCallBack: (() -> ())?
    var message: String?
    var flowHeightConstraint: NSLayoutConstraint?

    private lazy var backgroundCardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 6
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        return cardView
    }()
    
    public lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = UIFont(name: "Poppins-Regular", size: 17)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    var navController: UINavigationController?
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        //self.addBookingCallBack!()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C1E26").withAlphaComponent(0.62)
    }
    
    // MARK: - setupViews
    private func setupViews() {
        self.view.addSubview(backgroundCardView)
        //self.backgroundCardView.addSubview(percentageLabel)
        self.backgroundCardView.addSubview(errorLabel)
    }
    
    // MARK: -SetupConstraints
    private func setupConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.backgroundCardView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.backgroundCardView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.backgroundCardView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.backgroundCardView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            self.backgroundCardView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            self.errorLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.errorLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.errorLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            self.errorLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20)
        ])
     }
 }
