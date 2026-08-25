

//  Created by Ashok kumar on 3/5/21.


import Foundation
import UIKit

class ConfirmBooking: UIViewController {
    
    var addBookingCallBack: (() -> ())?
    var message = "Please be prepare for the consultation, Thanks".localized()
    
    private lazy var backgroundCardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor(named: "TextFieldBack")
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        return cardView
    }()
    
    public lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Booking Confirmed!".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.textColor = UIColor(named: "TextColour")
        label.textAlignment = .center
        return label
    }()
    
    public lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.numberOfLines = .zero
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    public lazy var okayButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Okay".localized(), for: .normal)
        button.backgroundColor = UIColor(named: "ButtonBlueColor") ?? .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(okayButtonTapped), for: .touchUpInside)
        return button
    }()
    
   var navController: UINavigationController?
   
    @objc func okayButtonTapped() {
        self.addBookingCallBack?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        self.addBookingCallBack?()
        //self.dismiss(animated: true, completion: nil)
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
        self.backgroundCardView.addSubview(percentageLabel)
        self.backgroundCardView.addSubview(errorLabel)
        self.backgroundCardView.addSubview(okayButton)
    }
    
    // MARK: -SetupConstraints
    private func setupConstraints() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.backgroundCardView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.backgroundCardView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.backgroundCardView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 35),
            self.backgroundCardView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            self.errorLabel.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 20),
            self.errorLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            self.errorLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            self.percentageLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            self.percentageLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            self.percentageLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            self.okayButton.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 25),
            self.okayButton.centerXAnchor.constraint(equalTo: backgroundCardView.centerXAnchor),
            self.okayButton.widthAnchor.constraint(equalToConstant: 120),
            self.okayButton.heightAnchor.constraint(equalToConstant: 44),
            self.okayButton.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -20)
        ])
     }
 }
