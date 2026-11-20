//
//  ChangePatientBottomSheetViewController.swift
//  DoctorLive
//

import UIKit
import PromiseKit

// MARK: - FamilyMemberCardCell
class FamilyMemberCardCell: UITableViewCell {
    
    static let identifier = "FamilyMemberCardCell"
    
    let cardView = UIView()
    let radioOuterCircle = UIView()
    let radioInnerCircle = UIView()
    let avatarCircle = UIView()
    let avatarIcon = UIImageView()
    let nameLabel = UILabel()
    let subtitleLabel = UILabel()
    let bookedBadge = UIView()
    let bookedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Radio button
        radioOuterCircle.layer.cornerRadius = 11
        radioOuterCircle.layer.borderWidth = 1.5
        radioOuterCircle.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(radioOuterCircle)
        
        radioInnerCircle.layer.cornerRadius = 5.5
        radioInnerCircle.translatesAutoresizingMaskIntoConstraints = false
        radioOuterCircle.addSubview(radioInnerCircle)
        
        // Avatar circle
        avatarCircle.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0) // #F1F5F9
        avatarCircle.layer.cornerRadius = 20
        avatarCircle.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(avatarCircle)
        
        avatarIcon.image = UIImage(systemName: "person.fill")
        avatarIcon.tintColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0) // #94A3B8
        avatarIcon.contentMode = .scaleAspectFit
        avatarIcon.translatesAutoresizingMaskIntoConstraints = false
        avatarCircle.addSubview(avatarIcon)
        
        // Name & Subtitle
        nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 15.5) ?? UIFont.systemFont(ofSize: 15.5, weight: .bold)
        nameLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(subtitleLabel)
        
        // Booked badge
        bookedBadge.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0) // #EFF6FF
        bookedBadge.layer.cornerRadius = 9
        bookedBadge.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(bookedBadge)
        
        bookedLabel.text = "Booked"
        bookedLabel.font = UIFont(name: "Poppins-Medium", size: 11.5) ?? UIFont.systemFont(ofSize: 11.5, weight: .medium)
        bookedLabel.textColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        bookedLabel.translatesAutoresizingMaskIntoConstraints = false
        bookedBadge.addSubview(bookedLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
            
            // Radio button
            radioOuterCircle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            radioOuterCircle.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            radioOuterCircle.widthAnchor.constraint(equalToConstant: 22),
            radioOuterCircle.heightAnchor.constraint(equalToConstant: 22),
            
            radioInnerCircle.centerXAnchor.constraint(equalTo: radioOuterCircle.centerXAnchor),
            radioInnerCircle.centerYAnchor.constraint(equalTo: radioOuterCircle.centerYAnchor),
            radioInnerCircle.widthAnchor.constraint(equalToConstant: 11),
            radioInnerCircle.heightAnchor.constraint(equalToConstant: 11),
            
            // Avatar
            avatarCircle.leadingAnchor.constraint(equalTo: radioOuterCircle.trailingAnchor, constant: 12),
            avatarCircle.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 40),
            avatarCircle.heightAnchor.constraint(equalToConstant: 40),
            
            avatarIcon.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            avatarIcon.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),
            avatarIcon.widthAnchor.constraint(equalToConstant: 20),
            avatarIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // Labels
            nameLabel.leadingAnchor.constraint(equalTo: avatarCircle.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 13),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: bookedBadge.leadingAnchor, constant: -8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: bookedBadge.leadingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -13),
            
            // Booked Badge
            bookedBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            bookedBadge.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            bookedLabel.topAnchor.constraint(equalTo: bookedBadge.topAnchor, constant: 3),
            bookedLabel.bottomAnchor.constraint(equalTo: bookedBadge.bottomAnchor, constant: -3),
            bookedLabel.leadingAnchor.constraint(equalTo: bookedBadge.leadingAnchor, constant: 8),
            bookedLabel.trailingAnchor.constraint(equalTo: bookedBadge.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with member: PatientMember, isSelected: Bool, isBooked: Bool) {
        nameLabel.text = member.member_name ?? "Patient"
        subtitleLabel.text = member.subtitleText
        bookedBadge.isHidden = !isBooked
        
        let primaryBlue = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        let lightBlueBg = UIColor(red: 240/255, green: 247/255, blue: 255/255, alpha: 1.0)
        let lightGrayBorder = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0)
        let radioUnselectedBorder = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0)
        
        if isSelected {
            cardView.backgroundColor = lightBlueBg
            cardView.layer.borderColor = primaryBlue.cgColor
            cardView.layer.borderWidth = 1.8
            
            radioOuterCircle.layer.borderColor = primaryBlue.cgColor
            radioInnerCircle.backgroundColor = primaryBlue
            radioInnerCircle.isHidden = false
        } else {
            cardView.backgroundColor = .white
            cardView.layer.borderColor = lightGrayBorder.cgColor
            cardView.layer.borderWidth = 1.0
            
            radioOuterCircle.layer.borderColor = radioUnselectedBorder.cgColor
            radioInnerCircle.backgroundColor = .clear
            radioInnerCircle.isHidden = true
        }
    }
}

// MARK: - DashedButtonView
class DashedButtonView: UIView {
    private let borderLayer = CAShapeLayer()
    let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        borderLayer.strokeColor = UIColor(red: 147/255, green: 197/255, blue: 253/255, alpha: 1.0).cgColor // #93C5FD
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 1.5
        borderLayer.lineDashPattern = [6, 4]
        layer.addSublayer(borderLayer)
        
        button.setTitle("+ Add a new patient", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
}

// MARK: - ChangePatientBottomSheetViewController
class ChangePatientBottomSheetViewController: UIViewController {

    var userId: String = ""
    var currentPatientName: String?
    var bookedPatientName: String?
    var currentMemberId: String?
    var onPatientConfirmed: ((PatientMember) -> Void)?
    
    // UI Elements
    private let dimmedBackgroundView = UIView()
    private let sheetContainerView = UIView()
    private let dragIndicatorView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let descriptionLabel = UILabel()
    private let searchContainerView = UIView()
    private let searchIcon = UIImageView()
    private let searchTextField = UITextField()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let dashedAddButton = DashedButtonView()
    
    private let bottomButtonBar = UIView()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let emptyLabel = UILabel()
    
    private var containerBottomConstraint: NSLayoutConstraint?
    private var tableHeightConstraint: NSLayoutConstraint?
    
    // Data
    private var allMembers: [PatientMember] = []
    private var filteredMembers: [PatientMember] = []
    private var selectedMember: PatientMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMembers()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dimmedBackgroundView.alpha = 0
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(handleClose))
        dimmedBackgroundView.addGestureRecognizer(dismissTap)
        view.addSubview(dimmedBackgroundView)
        
        sheetContainerView.backgroundColor = .white
        sheetContainerView.layer.cornerRadius = 24
        sheetContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetContainerView.clipsToBounds = true
        sheetContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sheetContainerView)
        
        // Top handle
        dragIndicatorView.backgroundColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0) // #CBD5E1
        dragIndicatorView.layer.cornerRadius = 2.5
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(dragIndicatorView)
        
        // Title
        titleLabel.text = "Change patient"
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(titleLabel)
        
        // Close button
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        closeButton.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        closeButton.layer.cornerRadius = 16
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        sheetContainerView.addSubview(closeButton)
        
        // Description
        let fullDesc = "Pick who this consultation is really for. It changes this prescription only — the booking and the patient's account stay as they are."
        let attributedString = NSMutableAttributedString(string: fullDesc, attributes: [
            .font: UIFont(name: "Poppins-Regular", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5),
            .foregroundColor: UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        ])
        let boldRange = (fullDesc as NSString).range(of: "this prescription only")
        if boldRange.location != NSNotFound {
            attributedString.addAttributes([
                .font: UIFont(name: "Poppins-SemiBold", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .bold),
                .foregroundColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
            ], range: boldRange)
        }
        descriptionLabel.attributedText = attributedString
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(descriptionLabel)
        
        // Search bar
        searchContainerView.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        searchContainerView.layer.cornerRadius = 12
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(searchContainerView)
        
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchIcon)
        
        searchTextField.placeholder = "Search family members"
        searchTextField.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        searchTextField.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchContainerView.addSubview(searchTextField)
        
        // TableView
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FamilyMemberCardCell.self, forCellReuseIdentifier: FamilyMemberCardCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(tableView)
        
        // Add button
        dashedAddButton.translatesAutoresizingMaskIntoConstraints = false
        dashedAddButton.button.addTarget(self, action: #selector(handleAddPatient), for: .touchUpInside)
        sheetContainerView.addSubview(dashedAddButton)
        
        // Activity indicator & empty label
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(activityIndicator)
        
        emptyLabel.text = "No family members found"
        emptyLabel.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        emptyLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(emptyLabel)
        
        // Bottom sticky bar
        bottomButtonBar.backgroundColor = .white
        bottomButtonBar.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(bottomButtonBar)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonBar.addSubview(bottomBorder)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15.5) ?? UIFont.systemFont(ofSize: 15.5, weight: .medium)
        cancelButton.setTitleColor(UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1.5
        cancelButton.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        bottomButtonBar.addSubview(cancelButton)
        
        confirmButton.setTitle("Confirm patient", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15.5) ?? UIFont.systemFont(ofSize: 15.5, weight: .bold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        confirmButton.layer.cornerRadius = 12
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        bottomButtonBar.addSubview(confirmButton)
        
        containerBottomConstraint = sheetContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sheetContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerBottomConstraint!,
            sheetContainerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.90),
            
            dragIndicatorView.topAnchor.constraint(equalTo: sheetContainerView.topAnchor, constant: 10),
            dragIndicatorView.centerXAnchor.constraint(equalTo: sheetContainerView.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 44),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: dragIndicatorView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -20),
            
            searchContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            searchContainerView.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            searchIcon.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 16),
            searchIcon.heightAnchor.constraint(equalToConstant: 16),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -12),
            searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: dashedAddButton.topAnchor, constant: -12),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180),
            
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -20),
            
            dashedAddButton.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            dashedAddButton.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -20),
            dashedAddButton.heightAnchor.constraint(equalToConstant: 48),
            dashedAddButton.bottomAnchor.constraint(equalTo: bottomButtonBar.topAnchor, constant: -12),
            
            bottomButtonBar.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor),
            bottomButtonBar.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor),
            bottomButtonBar.bottomAnchor.constraint(equalTo: sheetContainerView.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonBar.heightAnchor.constraint(equalToConstant: 68),
            
            bottomBorder.topAnchor.constraint(equalTo: bottomButtonBar.topAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: bottomButtonBar.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: bottomButtonBar.trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            
            cancelButton.leadingAnchor.constraint(equalTo: bottomButtonBar.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: bottomButtonBar.centerYAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.trailingAnchor.constraint(equalTo: bottomButtonBar.centerXAnchor, constant: -6),
            
            confirmButton.leadingAnchor.constraint(equalTo: bottomButtonBar.centerXAnchor, constant: 6),
            confirmButton.centerYAnchor.constraint(equalTo: bottomButtonBar.centerYAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.trailingAnchor.constraint(equalTo: bottomButtonBar.trailingAnchor, constant: -16)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.dimmedBackgroundView.alpha = 1.0
        }
    }
    
    // MARK: - API
    private func fetchMembers(autoSelectId: String? = nil) {
        let effectiveId = !userId.isEmpty ? userId : (UserDefaults.standard.string(forKey: "current_patient_user_id") ?? "")
        guard !effectiveId.isEmpty else {
            showEmptyState(message: "Patient user ID is missing")
            return
        }
        self.userId = effectiveId
        
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true
        
        var params: [String: Any] = [:]
        if let intId = Int(effectiveId) {
            params["user_id"] = intId
        } else {
            params["user_id"] = effectiveId
        }
        
        firstly {
            service!.getMembers(parameters: params, header: "DeviceToken")
        }.done { [weak self] (response: MembersResponse) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            let list = response.data ?? []
            self.allMembers = list
            self.filterMembers()
            
            if let autoId = autoSelectId, let match = list.first(where: { $0.member_id == autoId }) {
                self.selectedMember = match
            } else if self.selectedMember == nil {
                // Find currently active patient or booked patient
                if let currentName = self.currentPatientName,
                   let match = list.first(where: { ($0.member_name ?? "").caseInsensitiveCompare(currentName) == .orderedSame }) {
                    self.selectedMember = match
                } else if let bookedName = self.bookedPatientName,
                          let match = list.first(where: { ($0.member_name ?? "").caseInsensitiveCompare(bookedName) == .orderedSame }) {
                    self.selectedMember = match
                } else if let me = list.first(where: { ($0.member_relationship ?? "").lowercased() == "me" }) {
                    self.selectedMember = me
                } else {
                    self.selectedMember = list.first
                }
            }
            
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !self.filteredMembers.isEmpty
        }.catch { [weak self] (error) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.showEmptyState(message: error.localizedDescription)
        }
    }
    
    private func showEmptyState(message: String) {
        emptyLabel.text = message
        emptyLabel.isHidden = false
        allMembers = []
        filteredMembers = []
        tableView.reloadData()
    }
    
    @objc private func searchTextChanged() {
        filterMembers()
        tableView.reloadData()
        emptyLabel.isHidden = !filteredMembers.isEmpty
        if filteredMembers.isEmpty {
            emptyLabel.text = "No matching members found"
        }
    }
    
    private func filterMembers() {
        let query = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if query.isEmpty {
            filteredMembers = allMembers
        } else {
            filteredMembers = allMembers.filter { member in
                let nameMatch = (member.member_name ?? "").localizedCaseInsensitiveContains(query)
                let relMatch = member.displayRelationship.localizedCaseInsensitiveContains(query)
                return nameMatch || relMatch
            }
        }
    }
    
    // MARK: - Actions
    @objc private func handleClose() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.25, animations: {
            self.dimmedBackgroundView.alpha = 0
            self.sheetContainerView.transform = CGAffineTransform(translationX: 0, y: self.sheetContainerView.frame.height)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func handleConfirm() {
        guard let member = selectedMember else {
            AppToast.showMessage(message: "Please select a patient")
            return
        }
        onPatientConfirmed?(member)
        handleClose()
    }
    
    @objc private func handleAddPatient() {
        let effectiveId = !self.userId.isEmpty ? self.userId : (UserDefaults.standard.string(forKey: "current_patient_user_id") ?? "")
        let addVC = AddPatientBottomSheetViewController()
        addVC.userId = effectiveId
        addVC.modalPresentationStyle = .overFullScreen
        addVC.modalTransitionStyle = .crossDissolve
        addVC.onPatientAdded = { [weak self] newMemberId in
            guard let self = self else { return }
            AppToast.showMessage(message: "Patient added successfully")
            self.fetchMembers(autoSelectId: newMemberId)
        }
        present(addVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ChangePatientBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberCardCell.identifier, for: indexPath) as? FamilyMemberCardCell else {
            return UITableViewCell()
        }
        
        let member = filteredMembers[indexPath.row]
        let isSelected = (selectedMember?.member_id == member.member_id) ||
                         (selectedMember?.member_name == member.member_name && selectedMember != nil)
        
        // Determine if this member is the booked member
        let isBooked: Bool
        if let bookedName = bookedPatientName, !bookedName.isEmpty {
            isBooked = (member.member_name?.caseInsensitiveCompare(bookedName) == .orderedSame)
        } else {
            isBooked = (member.member_relationship?.lowercased() == "me")
        }
        
        cell.configure(with: member, isSelected: isSelected, isBooked: isBooked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMember = filteredMembers[indexPath.row]
        tableView.reloadData()
    }
}
