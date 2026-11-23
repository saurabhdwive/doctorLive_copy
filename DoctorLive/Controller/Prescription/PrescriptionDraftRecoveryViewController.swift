//
//  PrescriptionDraftRecoveryViewController.swift
//  DoctorLive
//
//  Screen showing restored draft status and checklist of filled/empty fields.
//

import UIKit

class PrescriptionDraftRecoveryViewController: UIViewController {

    var bookingId: String = ""
    var patientUserId: String?
    var patientName: String?
    
    private var draft: PrescriptionDraft?
    
    private let navBarView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .custom)
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    // Bottom Bar
    private let bottomBarView = UIView()
    private let discardButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        
        loadDraftData()
        setupNavBar()
        setupBottomBar()
        setupScrollView()
        populateContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func loadDraftData() {
        draft = PrescriptionDraftManager.shared.getDraft(for: bookingId)
    }
    
    // MARK: - Navigation Bar
    private func setupNavBar() {
        navBarView.backgroundColor = .white
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        if let backImg = UIImage(systemName: "chevron.left") {
            backButton.setImage(backImg, for: .normal)
            backButton.tintColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        } else if let backImg = UIImage(named: "back1") {
            backButton.setImage(backImg, for: .normal)
        }
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navBarView.addSubview(backButton)
        
        titleLabel.text = "Prescription"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor)
        ])
    }
    
    // MARK: - Bottom Bar
    private func setupBottomBar() {
        bottomBarView.backgroundColor = .white
        bottomBarView.layer.shadowColor = UIColor.black.cgColor
        bottomBarView.layer.shadowOpacity = 0.04
        bottomBarView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomBarView.layer.shadowRadius = 4
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)
        
        // Discard Button
        discardButton.setTitle("Discard draft", for: .normal)
        discardButton.setTitleColor(UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 1.0), for: .normal) // #DC2626
        discardButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14.5) ?? UIFont.systemFont(ofSize: 14.5, weight: .semibold)
        discardButton.backgroundColor = .white
        discardButton.layer.cornerRadius = 12
        discardButton.layer.borderWidth = 1
        discardButton.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        discardButton.translatesAutoresizingMaskIntoConstraints = false
        discardButton.addTarget(self, action: #selector(discardTapped), for: .touchUpInside)
        bottomBarView.addSubview(discardButton)
        
        // Continue Button
        continueButton.setTitle("Continue writing  ›", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14.5) ?? UIFont.systemFont(ofSize: 14.5, weight: .semibold)
        continueButton.backgroundColor = UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0) // #1D4ED8
        continueButton.layer.cornerRadius = 12
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueWritingTapped), for: .touchUpInside)
        bottomBarView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 88),
            
            discardButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            discardButton.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 12),
            discardButton.heightAnchor.constraint(equalToConstant: 48),
            discardButton.trailingAnchor.constraint(equalTo: bottomBarView.centerXAnchor, constant: -6),
            
            continueButton.leadingAnchor.constraint(equalTo: bottomBarView.centerXAnchor, constant: 6),
            continueButton.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 12),
            continueButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Scroll View
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentStack.axis = .vertical
        contentStack.spacing = 14
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Populate Content
    private func populateContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 1. Restored Banner
        let bannerView = UIView()
        bannerView.backgroundColor = UIColor(red: 236/255, green: 253/255, blue: 245/255, alpha: 1.0) // #ECFDF5
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bannerIcon = UIImageView()
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        bannerIcon.image = UIImage(systemName: "arrow.clockwise", withConfiguration: iconConfig)
        bannerIcon.tintColor = UIColor(red: 6/255, green: 95/255, blue: 70/255, alpha: 1.0) // #065F46
        bannerIcon.contentMode = .scaleAspectFit
        bannerIcon.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(bannerIcon)
        
        let bannerTitle = UILabel()
        bannerTitle.text = "Your draft was restored"
        bannerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14.5) ?? UIFont.systemFont(ofSize: 14.5, weight: .bold)
        bannerTitle.textColor = UIColor(red: 6/255, green: 95/255, blue: 70/255, alpha: 1.0)
        bannerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let savedTime = draft?.savedAtTime ?? "recently"
        let bannerSub = UILabel()
        bannerSub.text = "Saved automatically at \(savedTime) while you were writing. Nothing was lost."
        bannerSub.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        bannerSub.textColor = UIColor(red: 4/255, green: 120/255, blue: 87/255, alpha: 1.0) // #047857
        bannerSub.numberOfLines = 0
        bannerSub.translatesAutoresizingMaskIntoConstraints = false
        
        let bannerTextStack = UIStackView(arrangedSubviews: [bannerTitle, bannerSub])
        bannerTextStack.axis = .vertical
        bannerTextStack.spacing = 3
        bannerTextStack.alignment = .leading
        bannerTextStack.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(bannerTextStack)
        
        NSLayoutConstraint.activate([
            bannerIcon.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 16),
            bannerIcon.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 14),
            bannerIcon.widthAnchor.constraint(equalToConstant: 22),
            bannerIcon.heightAnchor.constraint(equalToConstant: 22),
            
            bannerTextStack.leadingAnchor.constraint(equalTo: bannerIcon.trailingAnchor, constant: 12),
            bannerTextStack.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: -16),
            bannerTextStack.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 12),
            bannerTextStack.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: -14)
        ])
        contentStack.addArrangedSubview(bannerView)
        
        // Wrap next cards in padded container
        let paddedContainer = UIStackView()
        paddedContainer.axis = .vertical
        paddedContainer.spacing = 14
        paddedContainer.layoutMargins = UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 16)
        paddedContainer.isLayoutMarginsRelativeArrangement = true
        paddedContainer.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(paddedContainer)
        
        // 2. Patient Card
        let patientCard = createCardView()
        
        let avatarView = UIView()
        avatarView.backgroundColor = UIColor(red: 235/255, green: 245/255, blue: 255/255, alpha: 1.0)
        avatarView.layer.cornerRadius = 22
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let personIcon = UIImageView()
        personIcon.image = UIImage(systemName: "person.fill")
        personIcon.tintColor = UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 1.0)
        personIcon.contentMode = .scaleAspectFit
        personIcon.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(personIcon)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44),
            personIcon.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            personIcon.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            personIcon.widthAnchor.constraint(equalToConstant: 22),
            personIcon.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        let pNameLabel = UILabel()
        let name = draft?.patientName ?? patientName ?? "Patient"
        pNameLabel.text = name
        pNameLabel.font = UIFont(name: "Poppins-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        pNameLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        
        let pSubLabel = UILabel()
        pSubLabel.text = draft?.patientSubtitle.isEmpty == false ? draft?.patientSubtitle : "Patient · Consultation"
        pSubLabel.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        pSubLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        
        let pTextStack = UIStackView(arrangedSubviews: [pNameLabel, pSubLabel])
        pTextStack.axis = .vertical
        pTextStack.spacing = 3
        pTextStack.alignment = .leading
        
        let patientRow = UIStackView(arrangedSubviews: [avatarView, pTextStack])
        patientRow.axis = .horizontal
        patientRow.spacing = 14
        patientRow.alignment = .center
        patientRow.translatesAutoresizingMaskIntoConstraints = false
        patientCard.addSubview(patientRow)
        
        NSLayoutConstraint.activate([
            patientRow.topAnchor.constraint(equalTo: patientCard.topAnchor, constant: 14),
            patientRow.bottomAnchor.constraint(equalTo: patientCard.bottomAnchor, constant: -14),
            patientRow.leadingAnchor.constraint(equalTo: patientCard.leadingAnchor, constant: 14),
            patientRow.trailingAnchor.constraint(equalTo: patientCard.trailingAnchor, constant: -14)
        ])
        paddedContainer.addArrangedSubview(patientCard)
        
        // 3. "Recovered from your draft" Checklist Card
        let checklistCard = createCardView()
        
        let checklistTitle = UILabel()
        checklistTitle.text = "Recovered from your draft"
        checklistTitle.font = UIFont(name: "Poppins-Bold", size: 14.5) ?? UIFont.systemFont(ofSize: 14.5, weight: .bold)
        checklistTitle.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        checklistTitle.translatesAutoresizingMaskIntoConstraints = false
        checklistCard.addSubview(checklistTitle)
        
        let rowsStack = UIStackView()
        rowsStack.axis = .vertical
        rowsStack.spacing = 12
        rowsStack.translatesAutoresizingMaskIntoConstraints = false
        checklistCard.addSubview(rowsStack)
        
        // Items in checklist:
        let hasChief = !(draft?.chiefComplain?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        rowsStack.addArrangedSubview(createChecklistRow(title: "Chief Complain", isFilled: hasChief, valueText: hasChief ? "Filled" : "Empty"))
        
        let hasDiagnosis = !(draft?.provisionalDiagnosis?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        rowsStack.addArrangedSubview(createChecklistRow(title: "Provisional Diagnosis", isFilled: hasDiagnosis, valueText: hasDiagnosis ? "Filled" : "Empty"))
        
        let medCount = draft?.medicines.count ?? 0
        let hasMeds = medCount > 0
        rowsStack.addArrangedSubview(createChecklistRow(title: "Medicine", isFilled: hasMeds, valueText: hasMeds ? "\(medCount) \(medCount == 1 ? "item" : "items")" : "Empty"))
        
        let invCount = draft?.investigationList.count ?? 0
        let hasInvs = invCount > 0
        rowsStack.addArrangedSubview(createChecklistRow(title: "Investigation", isFilled: hasInvs, valueText: hasInvs ? "\(invCount) \(invCount == 1 ? "test" : "tests")" : "Empty"))
        
        let hasAdvice = !(draft?.generalAdvice?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        rowsStack.addArrangedSubview(createChecklistRow(title: "General Advice", isFilled: hasAdvice, valueText: hasAdvice ? "Filled" : "Empty"))
        
        NSLayoutConstraint.activate([
            checklistTitle.topAnchor.constraint(equalTo: checklistCard.topAnchor, constant: 16),
            checklistTitle.leadingAnchor.constraint(equalTo: checklistCard.leadingAnchor, constant: 16),
            checklistTitle.trailingAnchor.constraint(equalTo: checklistCard.trailingAnchor, constant: -16),
            
            rowsStack.topAnchor.constraint(equalTo: checklistTitle.bottomAnchor, constant: 14),
            rowsStack.leadingAnchor.constraint(equalTo: checklistCard.leadingAnchor, constant: 16),
            rowsStack.trailingAnchor.constraint(equalTo: checklistCard.trailingAnchor, constant: -16),
            rowsStack.bottomAnchor.constraint(equalTo: checklistCard.bottomAnchor, constant: -16)
        ])
        paddedContainer.addArrangedSubview(checklistCard)
        
        // 4. Information Callout Box
        let calloutBox = UIView()
        calloutBox.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        calloutBox.layer.cornerRadius = 12
        calloutBox.layer.borderWidth = 1
        calloutBox.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        calloutBox.translatesAutoresizingMaskIntoConstraints = false
        
        let calloutLabel = UILabel()
        calloutLabel.text = "The draft is kept against this booking, so it survives closing the app, taking another call, or switching device. It is cleared once the prescription is sent."
        calloutLabel.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        calloutLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        calloutLabel.numberOfLines = 0
        calloutLabel.lineBreakMode = .byWordWrapping
        calloutLabel.translatesAutoresizingMaskIntoConstraints = false
        calloutBox.addSubview(calloutLabel)
        
        NSLayoutConstraint.activate([
            calloutLabel.topAnchor.constraint(equalTo: calloutBox.topAnchor, constant: 14),
            calloutLabel.bottomAnchor.constraint(equalTo: calloutBox.bottomAnchor, constant: -14),
            calloutLabel.leadingAnchor.constraint(equalTo: calloutBox.leadingAnchor, constant: 14),
            calloutLabel.trailingAnchor.constraint(equalTo: calloutBox.trailingAnchor, constant: -14)
        ])
        paddedContainer.addArrangedSubview(calloutBox)
    }
    
    private func createChecklistRow(title: String, isFilled: Bool, valueText: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        row.alignment = .center
        row.distribution = .fill
        
        let iconView = UIImageView()
        if isFilled {
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
            iconView.image = UIImage(systemName: "checkmark", withConfiguration: config)
            iconView.tintColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0) // #10B981
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
            iconView.image = UIImage(systemName: "circle", withConfiguration: config)
            iconView.tintColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0) // #CBD5E1
        }
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18)
        ])
        row.addArrangedSubview(iconView)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Poppins-Medium", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
        label.textColor = isFilled ? UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0) : UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        row.addArrangedSubview(label)
        
        let valLabel = UILabel()
        valLabel.text = valueText
        valLabel.font = UIFont(name: "Poppins-Regular", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5, weight: .regular)
        valLabel.textColor = isFilled ? UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0) : UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        valLabel.textAlignment = .right
        row.addArrangedSubview(valLabel)
        
        return row
    }
    
    private func createCardView() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.02
        card.layer.shadowOffset = CGSize(width: 0, height: 1)
        card.layer.shadowRadius = 3
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func discardTapped() {
        let alert = UIAlertController(title: "Discard Draft", message: "Are you sure you want to discard this draft? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            PrescriptionDraftManager.shared.deleteDraft(for: self.bookingId)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func continueWritingTapped() {
        let prescriptionVC = PrescriptionViewController()
        prescriptionVC.isComingFromChat = true
        prescriptionVC.bookingId = self.bookingId
        prescriptionVC.patientUserId = self.patientUserId
        prescriptionVC.data["user_id"] = self.patientUserId ?? ""
        if let name = self.patientName, !name.isEmpty, name.lowercased() != "me" {
            prescriptionVC.data["name"] = name
        }
        
        // Replace current screen on navigation stack so back button in PrescriptionViewController returns directly to Chat!
        if var viewControllers = self.navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(prescriptionVC)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        } else {
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
        }
    }
}
