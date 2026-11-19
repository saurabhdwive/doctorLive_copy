//
//  CreateEditTemplateViewController.swift
//  DoctorLive
//
//  Created for Prescription Templates Feature.
//

import UIKit
import PromiseKit

// MARK: - TemplateMultilineTextView
class TemplateMultilineTextView: UITextView, UITextViewDelegate {
    private let placeholderLabel = UILabel()
    
    var placeholder: String? {
        get { return placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            placeholderLabel.isHidden = !(text?.isEmpty ?? true)
        }
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !(text?.isEmpty ?? true)
        }
    }
    
    override var font: UIFont? {
        didSet {
            super.font = font
            placeholderLabel.font = font
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textContainer.lineFragmentPadding = 0
        isScrollEnabled = true
        isUserInteractionEnabled = true
        delegate = self
        
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc private func textDidChangeNotification() {
        placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class CreateEditTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var existingTemplate: PrescriptionTemplate?
    var onSave: ((PrescriptionTemplate) -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let titleTxt = InsetPaddedTextField()
    private let chiefComplaintTxt = TemplateMultilineTextView()
    private let provisionalDiagnosisTxt = TemplateMultilineTextView()
    private let generalAdviceTxt = TemplateMultilineTextView()
    private let investigationsTxt = InsetPaddedTextField()
    private let followUpDaysTxt = InsetPaddedTextField()
    
    private var medicinesList: [TemplateMedicine] = []
    private let medicinesContainerStack = UIStackView()
    private let medCountBadge = UIView()
    private let medCountLabel = UILabel()
    
    private var titleBox = UIView()
    private let titleErrorLabel = UILabel()
    private var fuBox = UIView()
    private let followUpErrorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupUI()
        populateExistingData()
    }
    
    private func setupNavBar() {
        navigationItem.title = existingTemplate == nil ? "New Template".localized() : "Edit Template".localized()
        
        let cancelBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelTapped))
        cancelBtn.tintColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        navigationItem.leftBarButtonItem = cancelBtn
        
        let saveBtn = UIBarButtonItem(title: "Save".localized(), style: .done, target: self, action: #selector(saveTapped))
        saveBtn.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = saveBtn
    }
    
    private func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Pinned Bottom Action Buttons Bar
        let bottomBar = UIView()
        bottomBar.backgroundColor = .white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0)
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(topBorder)
        
        let bottomButtonsStack = UIStackView()
        bottomButtonsStack.axis = .horizontal
        bottomButtonsStack.spacing = 12
        bottomButtonsStack.distribution = .fillEqually
        bottomButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(bottomButtonsStack)
        
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("Cancel".localized(), for: .normal)
        cancelBtn.setTitleColor(UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0), for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        cancelBtn.backgroundColor = .white
        cancelBtn.layer.cornerRadius = 12
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0).cgColor
        cancelBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        bottomButtonsStack.addArrangedSubview(cancelBtn)
        
        let saveBtn = UIButton(type: .system)
        saveBtn.setTitle("Save template".localized(), for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        saveBtn.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        saveBtn.layer.cornerRadius = 12
        saveBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        saveBtn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        bottomButtonsStack.addArrangedSubview(saveBtn)
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topBorder.topAnchor.constraint(equalTo: bottomBar.topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            
            bottomButtonsStack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 12),
            bottomButtonsStack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 16),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -12),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
        // 1. Template Title Field
        addSectionHeader(title: "Template Name *")
        titleBox = createInputFieldBox(height: 46)
        titleTxt.placeholder = "e.g. Acute tonsillitis — adult"
        titleTxt.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        titleTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        titleTxt.translatesAutoresizingMaskIntoConstraints = false
        titleTxt.addTarget(self, action: #selector(titleDidChange), for: .editingChanged)
        titleBox.addSubview(titleTxt)
        pinViewToEdges(view: titleTxt, inside: titleBox)
        contentStack.addArrangedSubview(titleBox)
        
        setupErrorLabel(titleErrorLabel)
        contentStack.addArrangedSubview(titleErrorLabel)
        contentStack.setCustomSpacing(6, after: titleBox)
        
        // 2. Chief Complaint
        addSectionHeader(title: "Chief Complaint")
        let ccBox = createInputFieldBox(height: 64)
        chiefComplaintTxt.placeholder = "e.g. Fever with sore throat for 4 days"
        chiefComplaintTxt.translatesAutoresizingMaskIntoConstraints = false
        ccBox.addSubview(chiefComplaintTxt)
        pinViewToEdges(view: chiefComplaintTxt, inside: ccBox)
        contentStack.addArrangedSubview(ccBox)
        
        // 3. Provisional Diagnosis
        addSectionHeader(title: "Provisional Diagnosis")
        let pdBox = createInputFieldBox(height: 64)
        provisionalDiagnosisTxt.placeholder = "e.g. Acute tonsillitis"
        provisionalDiagnosisTxt.translatesAutoresizingMaskIntoConstraints = false
        pdBox.addSubview(provisionalDiagnosisTxt)
        pinViewToEdges(view: provisionalDiagnosisTxt, inside: pdBox)
        contentStack.addArrangedSubview(pdBox)
        
        // 4. Investigations
        addSectionHeader(title: "Investigations (comma separated)")
        let invBox = createInputFieldBox(height: 46)
        investigationsTxt.placeholder = "e.g. CBC, CRP, Throat swab C/S"
        investigationsTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        investigationsTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        investigationsTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        investigationsTxt.translatesAutoresizingMaskIntoConstraints = false
        invBox.addSubview(investigationsTxt)
        pinViewToEdges(view: investigationsTxt, inside: invBox)
        contentStack.addArrangedSubview(invBox)
        
        // 5. General Advice
        addSectionHeader(title: "General Advice")
        let gaBox = createInputFieldBox(height: 80)
        generalAdviceTxt.placeholder = "e.g. Drink plenty of warm water, gargle with warm saline water"
        generalAdviceTxt.translatesAutoresizingMaskIntoConstraints = false
        gaBox.addSubview(generalAdviceTxt)
        pinViewToEdges(view: generalAdviceTxt, inside: gaBox)
        contentStack.addArrangedSubview(gaBox)
        
        // 6. Follow-up Days
        addSectionHeader(title: "Follow-up After (days)")
        fuBox = createInputFieldBox(height: 46)
        followUpDaysTxt.placeholder = "e.g. 7"
        followUpDaysTxt.keyboardType = .numberPad
        followUpDaysTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        followUpDaysTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        followUpDaysTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        followUpDaysTxt.translatesAutoresizingMaskIntoConstraints = false
        followUpDaysTxt.addTarget(self, action: #selector(followUpDidChange), for: .editingChanged)
        fuBox.addSubview(followUpDaysTxt)
        pinViewToEdges(view: followUpDaysTxt, inside: fuBox)
        contentStack.addArrangedSubview(fuBox)
        
        setupErrorLabel(followUpErrorLabel)
        contentStack.addArrangedSubview(followUpErrorLabel)
        contentStack.setCustomSpacing(6, after: fuBox)
        
        // 7. Medicines Section Header with count badge
        let medHeaderRow = UIStackView()
        medHeaderRow.axis = .horizontal
        medHeaderRow.alignment = .center
        medHeaderRow.distribution = .equalSpacing
        medHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        
        let medLbl = UILabel()
        medLbl.text = "Medicines".localized()
        medLbl.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        medLbl.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        medHeaderRow.addArrangedSubview(medLbl)
        
        // Count Badge
        medCountBadge.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0)
        medCountBadge.layer.cornerRadius = 12
        medCountBadge.layer.masksToBounds = true
        medCountBadge.translatesAutoresizingMaskIntoConstraints = false
        
        medCountLabel.textColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        medCountLabel.font = UIFont(name: "Poppins-SemiBold", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        medCountLabel.textAlignment = .center
        medCountLabel.translatesAutoresizingMaskIntoConstraints = false
        medCountBadge.addSubview(medCountLabel)
        
        NSLayoutConstraint.activate([
            medCountBadge.heightAnchor.constraint(equalToConstant: 24),
            medCountBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            medCountLabel.leadingAnchor.constraint(equalTo: medCountBadge.leadingAnchor, constant: 8),
            medCountLabel.trailingAnchor.constraint(equalTo: medCountBadge.trailingAnchor, constant: -8),
            medCountLabel.centerYAnchor.constraint(equalTo: medCountBadge.centerYAnchor)
        ])
        
        medHeaderRow.addArrangedSubview(medCountBadge)
        contentStack.addArrangedSubview(medHeaderRow)
        
        // Medicines cards container
        medicinesContainerStack.axis = .vertical
        medicinesContainerStack.spacing = 10
        contentStack.addArrangedSubview(medicinesContainerStack)
        
        // "+ Add medicine to template" Dashed Button
        let addMedicineBtn = DashedBorderButton(type: .system)
        addMedicineBtn.setTitle("+ Add medicine to template".localized(), for: .normal)
        addMedicineBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        addMedicineBtn.setTitleColor(UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0), for: .normal)
        addMedicineBtn.backgroundColor = .white
        addMedicineBtn.layer.cornerRadius = 12
        addMedicineBtn.translatesAutoresizingMaskIntoConstraints = false
        addMedicineBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addMedicineBtn.addTarget(self, action: #selector(addMedicineTapped), for: .touchUpInside)
        contentStack.addArrangedSubview(addMedicineBtn)
    }
    
    private func addSectionHeader(title: String) {
        let lbl = UILabel()
        lbl.text = title
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
        lbl.textColor = UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0) // #475569
        contentStack.addArrangedSubview(lbl)
    }
    
    private func createInputFieldBox(height: CGFloat) -> UIView {
        let box = UIView()
        box.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0) // #F8FAFC
        box.layer.cornerRadius = 10
        box.layer.borderWidth = 1
        box.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor // #E2E8F0
        box.translatesAutoresizingMaskIntoConstraints = false
        let h = box.heightAnchor.constraint(equalToConstant: height)
        h.priority = UILayoutPriority(999)
        h.isActive = true
        return box
    }
    
    private func pinViewToEdges(view: UIView, inside container: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
    
    private func populateExistingData() {
        guard let item = existingTemplate else { return }
        titleTxt.text = item.title
        chiefComplaintTxt.text = item.chiefComplain
        provisionalDiagnosisTxt.text = item.provisionalDiagnosis
        generalAdviceTxt.text = item.generalAdvice
        if let tests = item.investigations {
            investigationsTxt.text = tests.joined(separator: ", ")
        }
        followUpDaysTxt.text = item.followUpDays
        medicinesList = item.medicines ?? []
        refreshMedicinesUI()
    }
    
    private func refreshMedicinesUI() {
        medCountLabel.text = "\(medicinesList.count)"
        medCountBadge.isHidden = medicinesList.isEmpty
        
        medicinesContainerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if medicinesList.isEmpty {
            let emptyLbl = UILabel()
            emptyLbl.text = "No medicines added yet."
            emptyLbl.font = UIFont(name: "Poppins-Regular", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5)
            emptyLbl.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
            medicinesContainerStack.addArrangedSubview(emptyLbl)
            return
        }
        
        for (index, med) in medicinesList.enumerated() {
            let card = UIView()
            card.backgroundColor = .white
            card.layer.cornerRadius = 12
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
            card.translatesAutoresizingMaskIntoConstraints = false
            
            let medName = UILabel()
            medName.attributedText = formatMedicineTitle(med.name)
            medName.numberOfLines = 1
            medName.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(medName)
            
            let delBtn = UIButton(type: .system)
            delBtn.setImage(UIImage(systemName: "trash"), for: .normal)
            delBtn.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 0.8)
            delBtn.tag = index
            delBtn.translatesAutoresizingMaskIntoConstraints = false
            delBtn.addTarget(self, action: #selector(deleteMedicineFromTemplate(_:)), for: .touchUpInside)
            card.addSubview(delBtn)
            
            let medSub = UILabel()
            medSub.text = "\(med.dosage) · \(med.frequencyFirst) · \(med.duration) · \(med.meals)"
            medSub.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
            medSub.textColor = UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0)
            medSub.numberOfLines = 1
            medSub.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(medSub)
            
            NSLayoutConstraint.activate([
                medName.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
                medName.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
                medName.trailingAnchor.constraint(equalTo: delBtn.leadingAnchor, constant: -8),
                
                delBtn.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                delBtn.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
                delBtn.widthAnchor.constraint(equalToConstant: 28),
                delBtn.heightAnchor.constraint(equalToConstant: 28),
                
                medSub.topAnchor.constraint(equalTo: medName.bottomAnchor, constant: 4),
                medSub.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
                medSub.trailingAnchor.constraint(equalTo: delBtn.leadingAnchor, constant: -8),
                medSub.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
            ])
            
            medicinesContainerStack.addArrangedSubview(card)
        }
    }
    
    private func formatMedicineTitle(_ rawName: String) -> NSAttributedString {
        let clean = rawName.components(separatedBy: "\n").first ?? rawName
        let parts = clean.components(separatedBy: " ")
        guard let firstWord = parts.first, !firstWord.isEmpty else {
            return NSAttributedString(string: rawName)
        }
        
        let remainder = parts.dropFirst().joined(separator: " ")
        
        let result = NSMutableAttributedString()
        let blueColor = UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0) // #1D4ED8
        let grayColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0) // #64748B
        
        let fontBold = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        let fontRegular = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        result.append(NSAttributedString(
            string: firstWord,
            attributes: [.font: fontBold, .foregroundColor: blueColor]
        ))
        
        if !remainder.isEmpty {
            result.append(NSAttributedString(
                string: " " + remainder,
                attributes: [.font: fontRegular, .foregroundColor: grayColor]
            ))
        }
        
        return result
    }
    
    @objc private func deleteMedicineFromTemplate(_ sender: UIButton) {
        let index = sender.tag
        if index < medicinesList.count {
            medicinesList.remove(at: index)
            refreshMedicinesUI()
        }
    }
    
    @objc private func addMedicineTapped() {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Validation Helpers
    private func setupErrorLabel(_ label: UILabel) {
        label.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0) // #EF4444
        label.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func titleDidChange() {
        if let text = titleTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
            clearTitleError()
        }
    }
    
    private func showTitleError(_ message: String) {
        titleErrorLabel.text = message
        titleBox.layer.borderColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.2) {
            self.titleErrorLabel.isHidden = false
            self.contentStack.layoutIfNeeded()
        }
    }
    
    private func clearTitleError() {
        titleBox.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.2) {
            self.titleErrorLabel.isHidden = true
            self.contentStack.layoutIfNeeded()
        }
    }
    
    @objc private func followUpDidChange() {
        clearFollowUpError()
    }
    
    private func showFollowUpError(_ message: String) {
        followUpErrorLabel.text = message
        fuBox.layer.borderColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.2) {
            self.followUpErrorLabel.isHidden = false
            self.contentStack.layoutIfNeeded()
        }
    }
    
    private func clearFollowUpError() {
        fuBox.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.2) {
            self.followUpErrorLabel.isHidden = true
            self.contentStack.layoutIfNeeded()
        }
    }
    
    private func validateForm() -> Bool {
        var isValid = true
        var firstInvalidView: UIView? = nil
        
        let title = titleTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if title.isEmpty {
            showTitleError("Template name is required".localized())
            isValid = false
            firstInvalidView = titleTxt
        } else {
            clearTitleError()
        }
        
        let followUp = followUpDaysTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !followUp.isEmpty {
            if let days = Int(followUp), days > 0 && days <= 365 {
                clearFollowUpError()
            } else {
                showFollowUpError("Please enter a valid number of days (1-365)".localized())
                isValid = false
                if firstInvalidView == nil {
                    firstInvalidView = followUpDaysTxt
                }
            }
        } else {
            clearFollowUpError()
        }
        
        if let target = firstInvalidView {
            target.becomeFirstResponder()
            if target == titleTxt {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else {
                let rect = target.convert(target.bounds, to: scrollView)
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
        
        return isValid
    }
    
    @objc private func saveTapped() {
        view.endEditing(true)
        guard validateForm() else {
            return
        }
        
        let title = titleTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let invList = investigationsTxt.text?
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []
        
        let templateId = existingTemplate?.id ?? UUID().uuidString
        let used = existingTemplate?.usedCount ?? 0
        let updatedDate = "Just now"
        
        let template = PrescriptionTemplate(
            id: templateId,
            title: title,
            usedCount: used,
            updatedAt: updatedDate,
            chiefComplain: chiefComplaintTxt.text,
            pastHistory: nil,
            provisionalDiagnosis: provisionalDiagnosisTxt.text,
            generalAdvice: generalAdviceTxt.text,
            temperature: nil,
            bloodPressureSystolic: nil,
            bloodPressureDiastolic: nil,
            pulse: nil,
            bloodSugar: nil,
            investigations: invList,
            followUpDays: followUpDaysTxt.text,
            medicines: medicinesList
        )
        
        // Call API
        saveTemplateViaApi(template: template)
        
        onSave?(template)
        dismiss(animated: true, completion: nil)
    }
    
    private func saveTemplateViaApi(template: PrescriptionTemplate) {
        let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        var param: [String: Any] = [
            "token": token,
            "language_type": code,
            "title": template.title,
            "chief_complain": template.chiefComplain ?? "",
            "provisional_diagnosis": template.provisionalDiagnosis ?? "",
            "general_advice": template.generalAdvice ?? "",
            "follow_up_days": template.followUpDays ?? "",
            "investigations": template.investigations ?? [],
            "investigation": (template.investigations ?? []).joined(separator: ", ")
        ]
        
        if let meds = template.medicines {
            let medDicts = meds.map { [
                "name": $0.name,
                "dosage": $0.dosage,
                "frequency_first": $0.frequencyFirst,
                "duration": $0.duration,
                "meals": $0.meals
            ]}
            param["medicines"] = medDicts
            param["medicine"] = medDicts
        }
        
        if let existingId = existingTemplate?.id {
            param["template_id"] = existingId
            param["id"] = existingId
            firstly {
                service!.updatePrescriptionTemplate(parameters: param, header: "DeviceToken")
            }.done { (resp: PrescriptionTemplateCommonResponse) in
                print("Template updated successfully on server: \(resp)")
            }.catch { error in
                print("Template update API fallback: \(error.localizedDescription)")
            }
        } else {
            firstly {
                service!.createPrescriptionTemplate(parameters: param, header: "DeviceToken")
            }.done { (resp: PrescriptionTemplateCommonResponse) in
                print("Template created successfully on server: \(resp)")
            }.catch { error in
                print("Template create API fallback: \(error.localizedDescription)")
            }
        }
    }
}

extension CreateEditTemplateViewController: DataDelegate {
    func userData(passData: [Medicine]) {
        for med in passData {
            let item = TemplateMedicine(
                id: med.id,
                name: med.name,
                dosage: med.dosage,
                frequencyFirst: med.frequencyFirst,
                duration: med.duration,
                meals: med.meals
            )
            medicinesList.append(item)
        }
        refreshMedicinesUI()
    }
    
    func userEditData(passData: [Medicine]) {
        // Not used here
    }
}
