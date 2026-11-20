//
//  AddPatientBottomSheetViewController.swift
//  DoctorLive
//

import UIKit
import PromiseKit

class AddPatientBottomSheetViewController: UIViewController {

    var userId: String = ""
    var onPatientAdded: ((String?) -> Void)?
    
    // UI Elements
    private let dimmedBackgroundView = UIView()
    private let sheetContainerView = UIView()
    private let dragIndicatorView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let nameLabel = UILabel()
    private let nameTextField = InsetPaddedTextField()
    
    private let relationshipLabel = UILabel()
    private let chipsScrollView = UIScrollView()
    private let chipsStackView = UIStackView()
    private let relationshipTextField = InsetPaddedTextField()
    
    private let genderLabel = UILabel()
    private let genderSegmentedControl = UISegmentedControl(items: ["Male", "Female", "Other"])
    
    private let ageLabel = UILabel()
    private let ageTextField = InsetPaddedTextField()
    
    private let bottomButtonBar = UIView()
    private let cancelButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private var containerBottomConstraint: NSLayoutConstraint?
    private var containerHeightConstraint: NSLayoutConstraint?
    
    private let relationshipChips = ["Brother", "Sister", "Mother", "Father", "Son", "Daughter", "Spouse", "Grandfather", "Grandmother", "Other"]
    private var chipButtons: [UIButton] = []
    private var selectedChipButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
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
        
        dragIndicatorView.backgroundColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0) // #CBD5E1
        dragIndicatorView.layer.cornerRadius = 2.5
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(dragIndicatorView)
        
        titleLabel.text = "Add new patient"
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 19) ?? UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(titleLabel)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        closeButton.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        closeButton.layer.cornerRadius = 16
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        sheetContainerView.addSubview(closeButton)
        
        // Scroll view & form stack view
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(scrollView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 14
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        // 1. Name section
        nameLabel.text = "Full Name"
        nameLabel.font = UIFont(name: "Poppins-Medium", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
        nameLabel.textColor = UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
        styleTextField(nameTextField, placeholder: "e.g. Sharad")
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(nameTextField)
        
        // 2. Relationship section
        relationshipLabel.text = "Relationship"
        relationshipLabel.font = UIFont(name: "Poppins-Medium", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
        relationshipLabel.textColor = UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
        
        chipsScrollView.showsHorizontalScrollIndicator = false
        chipsScrollView.translatesAutoresizingMaskIntoConstraints = false
        chipsScrollView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        chipsStackView.axis = .horizontal
        chipsStackView.spacing = 8
        chipsStackView.alignment = .center
        chipsStackView.translatesAutoresizingMaskIntoConstraints = false
        chipsScrollView.addSubview(chipsStackView)
        
        for chip in relationshipChips {
            let chipBtn = UIButton(type: .system)
            chipBtn.setTitle(chip, for: .normal)
            chipBtn.setTitleColor(UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0), for: .normal)
            chipBtn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5)
            chipBtn.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
            chipBtn.layer.cornerRadius = 14
            chipBtn.layer.borderWidth = 1
            chipBtn.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
            chipBtn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            chipBtn.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            chipsStackView.addArrangedSubview(chipBtn)
            chipButtons.append(chipBtn)
        }
        
        styleTextField(relationshipTextField, placeholder: "or type custom relationship (e.g. Brother)")
        
        contentStackView.addArrangedSubview(relationshipLabel)
        contentStackView.addArrangedSubview(chipsScrollView)
        contentStackView.addArrangedSubview(relationshipTextField)
        
        // 3. Gender section
        genderLabel.text = "Gender"
        genderLabel.font = UIFont(name: "Poppins-Medium", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
        genderLabel.textColor = UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
        genderSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.selectedSegmentTintColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        genderSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        genderSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0)], for: .normal)
        genderSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentStackView.addArrangedSubview(genderLabel)
        contentStackView.addArrangedSubview(genderSegmentedControl)
        
        // 4. Age section
        ageLabel.text = "Age or Date of Birth"
        ageLabel.font = UIFont(name: "Poppins-Medium", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
        ageLabel.textColor = UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
        styleTextField(ageTextField, placeholder: "e.g. 28 or 1996-04-12")
        
        contentStackView.addArrangedSubview(ageLabel)
        contentStackView.addArrangedSubview(ageTextField)
        
        // Bottom action buttons
        bottomButtonBar.backgroundColor = .white
        bottomButtonBar.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.addSubview(bottomButtonBar)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonBar.addSubview(bottomBorder)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        cancelButton.setTitleColor(UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1.5
        cancelButton.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        bottomButtonBar.addSubview(cancelButton)
        
        submitButton.setTitle("Add Patient", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .bold)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0)
        submitButton.layer.cornerRadius = 12
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        bottomButtonBar.addSubview(submitButton)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addSubview(loadingIndicator)
        
        containerBottomConstraint = sheetContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerHeightConstraint = sheetContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.74)
        containerHeightConstraint?.priority = UILayoutPriority(950)
        
        NSLayoutConstraint.activate([
            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sheetContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerBottomConstraint!,
            sheetContainerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            containerHeightConstraint!,
            
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
            
            submitButton.leadingAnchor.constraint(equalTo: bottomButtonBar.centerXAnchor, constant: 6),
            submitButton.centerYAnchor.constraint(equalTo: bottomButtonBar.centerYAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 48),
            submitButton.trailingAnchor.constraint(equalTo: bottomButtonBar.trailingAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonBar.topAnchor, constant: -8),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            chipsStackView.topAnchor.constraint(equalTo: chipsScrollView.topAnchor),
            chipsStackView.bottomAnchor.constraint(equalTo: chipsScrollView.bottomAnchor),
            chipsStackView.leadingAnchor.constraint(equalTo: chipsScrollView.leadingAnchor),
            chipsStackView.trailingAnchor.constraint(equalTo: chipsScrollView.trailingAnchor),
            chipsStackView.heightAnchor.constraint(equalTo: chipsScrollView.heightAnchor)
        ])
    }
    
    private func styleTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.dimmedBackgroundView.alpha = 1.0
        }
    }
    
    @objc private func chipTapped(_ sender: UIButton) {
        selectedChipButton?.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        selectedChipButton?.setTitleColor(UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0), for: .normal)
        selectedChipButton?.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        
        sender.backgroundColor = UIColor(red: 240/255, green: 247/255, blue: 255/255, alpha: 1.0)
        sender.setTitleColor(UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0), for: .normal)
        sender.layer.borderColor = UIColor(red: 147/255, green: 197/255, blue: 253/255, alpha: 1.0).cgColor
        selectedChipButton = sender
        
        if let title = sender.title(for: .normal) {
            relationshipTextField.text = title
        }
    }
    
    @objc private func handleClose() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.25, animations: {
            self.dimmedBackgroundView.alpha = 0
            self.sheetContainerView.transform = CGAffineTransform(translationX: 0, y: self.sheetContainerView.frame.height)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func handleSubmit() {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            AppToast.showMessage(message: "Please enter patient name")
            return
        }
        guard let relationship = relationshipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !relationship.isEmpty else {
            AppToast.showMessage(message: "Please enter or select relationship")
            return
        }
        guard let dob = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dob.isEmpty else {
            AppToast.showMessage(message: "Please enter age or date of birth")
            return
        }
        
        let gender: String
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0: gender = "m"
        case 1: gender = "f"
        default: gender = "o"
        }
        
        let effectiveUid = !userId.isEmpty ? userId : (UserDefaults.standard.string(forKey: "current_patient_user_id") ?? "")
        guard !effectiveUid.isEmpty else {
            AppToast.showMessage(message: "Patient user ID is required")
            return
        }
        
        var param: [String: Any] = [
            "name": name,
            "dob": dob,
            "gender": gender,
            "relationship": relationship
        ]
        if let intId = Int(effectiveUid) {
            param["user_id"] = intId
        } else {
            param["user_id"] = effectiveUid
        }
        
        submitButton.setTitle("", for: .normal)
        loadingIndicator.startAnimating()
        submitButton.isEnabled = false
        
        firstly {
            service!.addMember(parameters: param, header: "DeviceToken")
        }.done { [weak self] (response: AddMemberResponse) in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.submitButton.setTitle("Add Patient", for: .normal)
            self.submitButton.isEnabled = true
            
            if response.status?.uppercased() == "SUCCESS" {
                self.onPatientAdded?(response.member_id)
                self.handleClose()
            } else {
                let msg = response.message ?? "Could not add member"
                AppToast.showMessage(message: msg)
            }
        }.catch { [weak self] (error) in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.submitButton.setTitle("Add Patient", for: .normal)
            self.submitButton.isEnabled = true
            AppToast.showMessage(message: error.localizedDescription)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            containerBottomConstraint?.constant = -keyboardFrame.height + view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        containerBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
