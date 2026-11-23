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
    
    override var attributedText: NSAttributedString! {
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
    private let pastHistoryTxt = TemplateMultilineTextView()
    
    // General Examination
    private let genralExamCard = UIView()
    private let genralSwitchButton = UISwitch()
    private let genralExamStack = UIStackView()
    private let tempTxt = InsetPaddedTextField()
    private let systolicTxt = InsetPaddedTextField()
    private let diastolicTxt = InsetPaddedTextField()
    private let pulseTxt = InsetPaddedTextField()
    private let sugarTxt = InsetPaddedTextField()
    
    private let provisionalDiagnosisTxt = TemplateMultilineTextView()
    private let generalAdviceTxt = TemplateMultilineTextView()
    private var savedGeneralAdviceHTML: String?
    private let investigationsTxt = InsetPaddedTextField()
    private let followUpDaysTxt = InsetPaddedTextField()
    
    private var medicinesList: [TemplateMedicine] = []
    private var editingMedicineIndex: Int?
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
        
        // 3. Past History
        addSectionHeader(title: "Past History")
        let phBox = createInputFieldBox(height: 64)
        pastHistoryTxt.placeholder = "e.g. Hypertension, Diabetes, No known allergies"
        pastHistoryTxt.translatesAutoresizingMaskIntoConstraints = false
        phBox.addSubview(pastHistoryTxt)
        pinViewToEdges(view: pastHistoryTxt, inside: phBox)
        contentStack.addArrangedSubview(phBox)
        
        // 4. General Examination
        setupGeneralExaminationCard()
        
        // 5. Provisional Diagnosis
        addSectionHeader(title: "Provisional Diagnosis")
        let pdBox = createInputFieldBox(height: 64)
        provisionalDiagnosisTxt.placeholder = "e.g. Acute tonsillitis"
        provisionalDiagnosisTxt.translatesAutoresizingMaskIntoConstraints = false
        pdBox.addSubview(provisionalDiagnosisTxt)
        pinViewToEdges(view: provisionalDiagnosisTxt, inside: pdBox)
        contentStack.addArrangedSubview(pdBox)
        
        // 6. Investigations
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
        
        // 7. General Advice with Format button
        let gaHeaderRow = UIStackView()
        gaHeaderRow.axis = .horizontal
        gaHeaderRow.alignment = .center
        gaHeaderRow.distribution = .equalSpacing
        gaHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        
        let gaLbl = UILabel()
        gaLbl.text = "General Advice"
        gaLbl.font = UIFont(name: "Poppins-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
        gaLbl.textColor = UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0)
        gaHeaderRow.addArrangedSubview(gaLbl)
        
        let formatBtn = UIButton(type: .system)
        formatBtn.setTitle(" ≡ Format", for: .normal)
        formatBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5, weight: .medium)
        formatBtn.setTitleColor(UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0), for: .normal)
        formatBtn.backgroundColor = .white
        formatBtn.layer.cornerRadius = 6
        formatBtn.layer.borderWidth = 1.2
        formatBtn.layer.borderColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0).cgColor
        formatBtn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        formatBtn.addTarget(self, action: #selector(formatAdviceTapped), for: .touchUpInside)
        gaHeaderRow.addArrangedSubview(formatBtn)
        contentStack.addArrangedSubview(gaHeaderRow)
        
        let gaBox = createInputFieldBox(height: 80)
        generalAdviceTxt.placeholder = "e.g. Drink plenty of warm water, gargle with warm saline water"
        generalAdviceTxt.translatesAutoresizingMaskIntoConstraints = false
        gaBox.addSubview(generalAdviceTxt)
        pinViewToEdges(view: generalAdviceTxt, inside: gaBox)
        contentStack.addArrangedSubview(gaBox)
        
        // 8. Follow-up Days
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
    
    private func setupGeneralExaminationCard() {
        genralExamCard.backgroundColor = .white
        genralExamCard.layer.cornerRadius = 12
        genralExamCard.layer.borderWidth = 1
        genralExamCard.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        genralExamCard.translatesAutoresizingMaskIntoConstraints = false
        
        let cardContentStack = UIStackView()
        cardContentStack.axis = .vertical
        cardContentStack.spacing = 14
        cardContentStack.translatesAutoresizingMaskIntoConstraints = false
        genralExamCard.addSubview(cardContentStack)
        
        NSLayoutConstraint.activate([
            cardContentStack.topAnchor.constraint(equalTo: genralExamCard.topAnchor, constant: 14),
            cardContentStack.leadingAnchor.constraint(equalTo: genralExamCard.leadingAnchor, constant: 14),
            cardContentStack.trailingAnchor.constraint(equalTo: genralExamCard.trailingAnchor, constant: -14),
            cardContentStack.bottomAnchor.constraint(equalTo: genralExamCard.bottomAnchor, constant: -14)
        ])
        
        // Header Row: "General Examination" + UISwitch
        let headerRow = UIStackView()
        headerRow.axis = .horizontal
        headerRow.alignment = .center
        headerRow.distribution = .equalSpacing
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLbl = UILabel()
        titleLbl.text = "General Examination"
        titleLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        headerRow.addArrangedSubview(titleLbl)
        
        genralSwitchButton.onTintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        genralSwitchButton.isOn = false
        genralSwitchButton.addTarget(self, action: #selector(genExamSwitchChanged(_:)), for: .valueChanged)
        headerRow.addArrangedSubview(genralSwitchButton)
        cardContentStack.addArrangedSubview(headerRow)
        
        // Fields Stack (collapsible)
        genralExamStack.axis = .horizontal
        genralExamStack.distribution = .fillEqually
        genralExamStack.spacing = 12
        genralExamStack.isHidden = true
        genralExamStack.translatesAutoresizingMaskIntoConstraints = false
        cardContentStack.addArrangedSubview(genralExamStack)
        
        // Left Column: Temperature + Blood Pressure
        let leftCol = UIStackView()
        leftCol.axis = .vertical
        leftCol.spacing = 10
        leftCol.distribution = .fillEqually
        genralExamStack.addArrangedSubview(leftCol)
        
        // Temperature
        let tempContainer = UIView()
        let tempLbl = UILabel()
        tempLbl.text = "Temperature"
        tempLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        tempLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        tempLbl.translatesAutoresizingMaskIntoConstraints = false
        tempContainer.addSubview(tempLbl)
        
        let tempBox = createInputFieldBox(height: 44)
        tempContainer.addSubview(tempBox)
        
        tempTxt.placeholder = "101.2 °F"
        tempTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        tempTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        tempTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        tempTxt.keyboardType = .numbersAndPunctuation
        tempTxt.translatesAutoresizingMaskIntoConstraints = false
        tempBox.addSubview(tempTxt)
        pinViewToEdges(view: tempTxt, inside: tempBox)
        
        NSLayoutConstraint.activate([
            tempLbl.topAnchor.constraint(equalTo: tempContainer.topAnchor),
            tempLbl.leadingAnchor.constraint(equalTo: tempContainer.leadingAnchor),
            tempBox.topAnchor.constraint(equalTo: tempLbl.bottomAnchor, constant: 4),
            tempBox.leadingAnchor.constraint(equalTo: tempContainer.leadingAnchor),
            tempBox.trailingAnchor.constraint(equalTo: tempContainer.trailingAnchor),
            tempBox.bottomAnchor.constraint(equalTo: tempContainer.bottomAnchor)
        ])
        leftCol.addArrangedSubview(tempContainer)
        
        // Blood Pressure (systolic / diastolic)
        let bpContainer = UIView()
        let bpLbl = UILabel()
        bpLbl.text = "Blood pressure"
        bpLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        bpLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        bpLbl.translatesAutoresizingMaskIntoConstraints = false
        bpContainer.addSubview(bpLbl)
        
        let bpBox = createInputFieldBox(height: 44)
        bpContainer.addSubview(bpBox)
        
        let bpRow = UIStackView()
        bpRow.axis = .horizontal
        bpRow.distribution = .fillProportionally
        bpRow.spacing = 2
        bpRow.translatesAutoresizingMaskIntoConstraints = false
        bpBox.addSubview(bpRow)
        
        systolicTxt.placeholder = "120"
        systolicTxt.textAlignment = .center
        systolicTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        systolicTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        systolicTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        systolicTxt.keyboardType = .numberPad
        bpRow.addArrangedSubview(systolicTxt)
        
        let slashLbl = UILabel()
        slashLbl.text = "/"
        slashLbl.font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        slashLbl.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        slashLbl.textAlignment = .center
        slashLbl.translatesAutoresizingMaskIntoConstraints = false
        slashLbl.widthAnchor.constraint(equalToConstant: 12).isActive = true
        bpRow.addArrangedSubview(slashLbl)
        
        diastolicTxt.placeholder = "80"
        diastolicTxt.textAlignment = .center
        diastolicTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        diastolicTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        diastolicTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        diastolicTxt.keyboardType = .numberPad
        bpRow.addArrangedSubview(diastolicTxt)
        
        NSLayoutConstraint.activate([
            bpLbl.topAnchor.constraint(equalTo: bpContainer.topAnchor),
            bpLbl.leadingAnchor.constraint(equalTo: bpContainer.leadingAnchor),
            bpBox.topAnchor.constraint(equalTo: bpLbl.bottomAnchor, constant: 4),
            bpBox.leadingAnchor.constraint(equalTo: bpContainer.leadingAnchor),
            bpBox.trailingAnchor.constraint(equalTo: bpContainer.trailingAnchor),
            bpBox.bottomAnchor.constraint(equalTo: bpContainer.bottomAnchor),
            bpRow.topAnchor.constraint(equalTo: bpBox.topAnchor),
            bpRow.bottomAnchor.constraint(equalTo: bpBox.bottomAnchor),
            bpRow.leadingAnchor.constraint(equalTo: bpBox.leadingAnchor, constant: 6),
            bpRow.trailingAnchor.constraint(equalTo: bpBox.trailingAnchor, constant: -6)
        ])
        leftCol.addArrangedSubview(bpContainer)
        
        // Right Column: Pulse + Blood Sugar
        let rightCol = UIStackView()
        rightCol.axis = .vertical
        rightCol.spacing = 10
        rightCol.distribution = .fillEqually
        genralExamStack.addArrangedSubview(rightCol)
        
        // Pulse
        let pulseContainer = UIView()
        let pulseLbl = UILabel()
        pulseLbl.text = "Pulse"
        pulseLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        pulseLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        pulseLbl.translatesAutoresizingMaskIntoConstraints = false
        pulseContainer.addSubview(pulseLbl)
        
        let pulseBox = createInputFieldBox(height: 44)
        pulseContainer.addSubview(pulseBox)
        
        pulseTxt.placeholder = "92"
        pulseTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        pulseTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        pulseTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        pulseTxt.keyboardType = .numberPad
        pulseTxt.translatesAutoresizingMaskIntoConstraints = false
        pulseBox.addSubview(pulseTxt)
        pinViewToEdges(view: pulseTxt, inside: pulseBox)
        
        NSLayoutConstraint.activate([
            pulseLbl.topAnchor.constraint(equalTo: pulseContainer.topAnchor),
            pulseLbl.leadingAnchor.constraint(equalTo: pulseContainer.leadingAnchor),
            pulseBox.topAnchor.constraint(equalTo: pulseLbl.bottomAnchor, constant: 4),
            pulseBox.leadingAnchor.constraint(equalTo: pulseContainer.leadingAnchor),
            pulseBox.trailingAnchor.constraint(equalTo: pulseContainer.trailingAnchor),
            pulseBox.bottomAnchor.constraint(equalTo: pulseContainer.bottomAnchor)
        ])
        rightCol.addArrangedSubview(pulseContainer)
        
        // Blood Sugar
        let sugarContainer = UIView()
        let sugarLbl = UILabel()
        sugarLbl.text = "Blood sugar"
        sugarLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        sugarLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        sugarLbl.translatesAutoresizingMaskIntoConstraints = false
        sugarContainer.addSubview(sugarLbl)
        
        let sugarBox = createInputFieldBox(height: 44)
        sugarContainer.addSubview(sugarBox)
        
        sugarTxt.placeholder = "—"
        sugarTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        sugarTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        sugarTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        sugarTxt.keyboardType = .decimalPad
        sugarTxt.translatesAutoresizingMaskIntoConstraints = false
        sugarBox.addSubview(sugarTxt)
        pinViewToEdges(view: sugarTxt, inside: sugarBox)
        
        NSLayoutConstraint.activate([
            sugarLbl.topAnchor.constraint(equalTo: sugarContainer.topAnchor),
            sugarLbl.leadingAnchor.constraint(equalTo: sugarContainer.leadingAnchor),
            sugarBox.topAnchor.constraint(equalTo: sugarLbl.bottomAnchor, constant: 4),
            sugarBox.leadingAnchor.constraint(equalTo: sugarContainer.leadingAnchor),
            sugarBox.trailingAnchor.constraint(equalTo: sugarContainer.trailingAnchor),
            sugarBox.bottomAnchor.constraint(equalTo: sugarContainer.bottomAnchor)
        ])
        rightCol.addArrangedSubview(sugarContainer)
        
        contentStack.addArrangedSubview(genralExamCard)
    }
    
    @objc private func genExamSwitchChanged(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.25) {
            self.genralExamStack.isHidden = !sender.isOn
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func formatAdviceTapped() {
        let vc = GeneralAdviceFormatViewController()
        // vc.initialText = generalAdviceTxt.text ?? ""
        let currentHTML: String
        if let saved = savedGeneralAdviceHTML, !saved.isEmpty {
            currentHTML = saved
        } else if let attr = generalAdviceTxt.attributedText, attr.length > 0 {
            currentHTML = AdviceHTMLHelper.attributedStringToHTML(attr)
        } else {
            currentHTML = generalAdviceTxt.text ?? ""
        }
        vc.initialText = currentHTML
        vc.onSave = { [weak self] formattedHtml in
            guard let self = self else { return }
            self.savedGeneralAdviceHTML = formattedHtml
            let attr = AdviceHTMLHelper.htmlToAttributedString(
                formattedHtml,
                font: UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),
                textColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
            )
            self.generalAdviceTxt.attributedText = attr
            // self?.generalAdviceTxt.text = formattedText
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private func populateExistingData() {
        guard let item = existingTemplate else { return }
        titleTxt.text = item.title
        chiefComplaintTxt.text = item.chiefComplain
        pastHistoryTxt.text = item.pastHistory
        
        tempTxt.text = (item.temperature == "0") ? "" : item.temperature
        pulseTxt.text = (item.pulse == "0") ? "" : item.pulse
        systolicTxt.text = (item.bloodPressureSystolic == "0") ? "" : item.bloodPressureSystolic
        diastolicTxt.text = (item.bloodPressureDiastolic == "0") ? "" : item.bloodPressureDiastolic
        sugarTxt.text = (item.bloodSugar == "0") ? "" : item.bloodSugar
        
        let shouldTurnOn: Bool
        if let gen = item.general {
            shouldTurnOn = (gen == "1")
        } else {
            let temp = item.temperature?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let pulse = item.pulse?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sys = item.bloodPressureSystolic?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let dia = item.bloodPressureDiastolic?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sugar = item.bloodSugar?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            let hasVitals = (!temp.isEmpty && temp != "0") ||
                            (!pulse.isEmpty && pulse != "0") ||
                            (!sys.isEmpty && sys != "0") ||
                            (!dia.isEmpty && dia != "0") ||
                            (!sugar.isEmpty && sugar != "0")
            shouldTurnOn = hasVitals
        }
        
        genralSwitchButton.isOn = shouldTurnOn
        genralExamStack.isHidden = !shouldTurnOn
        
        provisionalDiagnosisTxt.text = item.provisionalDiagnosis
        // generalAdviceTxt.text = item.generalAdvice
        if let advice = item.generalAdvice, !advice.isEmpty {
            savedGeneralAdviceHTML = advice
            generalAdviceTxt.attributedText = AdviceHTMLHelper.htmlToAttributedString(
                advice,
                font: UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),
                textColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
            )
        } else {
            generalAdviceTxt.text = item.generalAdvice
        }
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
            card.tag = index
            card.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editMedicineFromTemplate(_:)))
            card.addGestureRecognizer(tap)
            card.translatesAutoresizingMaskIntoConstraints = false
            
            let medName = UILabel()
            medName.attributedText = formatMedicineTitle(med.name)
            // medName.numberOfLines = 1
            medName.numberOfLines = 2
            medName.lineBreakMode = .byTruncatingTail
            medName.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(medName)
            
            // Action button stack matching Prescription screen (Edit pencil + Delete trash)
            let buttonStack = UIStackView()
            buttonStack.axis = .horizontal
            buttonStack.spacing = 10
            buttonStack.alignment = .center
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            
            let editBtn = UIButton(type: .system)
            if let pencilImg = UIImage(systemName: "pencil") {
                editBtn.setImage(pencilImg, for: .normal)
            }
            editBtn.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
            editBtn.tag = index
            editBtn.translatesAutoresizingMaskIntoConstraints = false
            editBtn.addTarget(self, action: #selector(editMedicineFromTemplateBtn(_:)), for: .touchUpInside)
            buttonStack.addArrangedSubview(editBtn)
            
            let delBtn = UIButton(type: .system)
            // delBtn.setImage(UIImage(systemName: "trash"), for: .normal)
            // delBtn.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 0.8)
            if let trashImg = UIImage(systemName: "trash") {
                delBtn.setImage(trashImg, for: .normal)
            }
            delBtn.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 0.8)
            delBtn.tag = index
            delBtn.translatesAutoresizingMaskIntoConstraints = false
            delBtn.addTarget(self, action: #selector(deleteMedicineFromTemplate(_:)), for: .touchUpInside)
            // card.addSubview(delBtn)
            buttonStack.addArrangedSubview(delBtn)
            card.addSubview(buttonStack)
            
            let medSub = UILabel()
            medSub.text = "\(med.dosage) · \(med.frequencyFirst) · \(med.duration) · \(med.meals)"
            medSub.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
            medSub.textColor = UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0)
            // medSub.numberOfLines = 1
            medSub.numberOfLines = 2
            medSub.lineBreakMode = .byTruncatingTail
            medSub.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(medSub)
            
            NSLayoutConstraint.activate([
                medName.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
                medName.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
                // medName.trailingAnchor.constraint(equalTo: delBtn.leadingAnchor, constant: -8),
                medName.trailingAnchor.constraint(lessThanOrEqualTo: buttonStack.leadingAnchor, constant: -8),
                
                // delBtn.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                // delBtn.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
                // delBtn.widthAnchor.constraint(equalToConstant: 28),
                // delBtn.heightAnchor.constraint(equalToConstant: 28),
                buttonStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
                buttonStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
                editBtn.widthAnchor.constraint(equalToConstant: 24),
                editBtn.heightAnchor.constraint(equalToConstant: 24),
                delBtn.widthAnchor.constraint(equalToConstant: 24),
                delBtn.heightAnchor.constraint(equalToConstant: 24),
                
                medSub.topAnchor.constraint(equalTo: medName.bottomAnchor, constant: 4),
                medSub.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
                // medSub.trailingAnchor.constraint(equalTo: delBtn.leadingAnchor, constant: -8),
                medSub.trailingAnchor.constraint(lessThanOrEqualTo: buttonStack.leadingAnchor, constant: -8),
                medSub.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
            ])
            
            medicinesContainerStack.addArrangedSubview(card)
        }
    }
    
    private func formatMedicineTitle(_ rawName: String) -> NSAttributedString {
        // let clean = rawName.components(separatedBy: "\n").first ?? rawName
        let clean = rawName.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    @objc private func editMedicineFromTemplateBtn(_ sender: UIButton) {
        let index = sender.tag
        guard index < medicinesList.count else { return }
        editingMedicineIndex = index
        let med = medicinesList[index]
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.delegate = self
        vc.editMed = true
        vc.editMedicne = [
            "id": med.id ?? "",
            "name": med.name,
            "dosage": med.dosage,
            "frequency_first": med.frequencyFirst,
            "duration": med.duration,
            "meals": med.meals
        ]
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func editMedicineFromTemplate(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let index = view.tag
        guard index < medicinesList.count else { return }
        editingMedicineIndex = index
        let med = medicinesList[index]
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.delegate = self
        vc.editMed = true
        vc.editMedicne = [
            "id": med.id ?? "",
            "name": med.name,
            "dosage": med.dosage,
            "frequency_first": med.frequencyFirst,
            "duration": med.duration,
            "meals": med.meals
        ]
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func addMedicineTapped() {
        editingMedicineIndex = nil
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
        
        let past = pastHistoryTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let isExamOn = genralSwitchButton.isOn
        let temp = isExamOn ? tempTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let sys = isExamOn ? systolicTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let dia = isExamOn ? diastolicTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let pulse = isExamOn ? pulseTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let sugar = isExamOn ? sugarTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        
        let template = PrescriptionTemplate(
            id: templateId,
            title: title,
            usedCount: used,
            updatedAt: updatedDate,
            chiefComplain: chiefComplaintTxt.text,
            pastHistory: (past?.isEmpty ?? true) ? nil : past,
            provisionalDiagnosis: provisionalDiagnosisTxt.text,
            // generalAdvice: generalAdviceTxt.text,
            generalAdvice: (savedGeneralAdviceHTML != nil && !savedGeneralAdviceHTML!.isEmpty) ? savedGeneralAdviceHTML : ((generalAdviceTxt.attributedText != nil && generalAdviceTxt.attributedText.length > 0) ? AdviceHTMLHelper.attributedStringToHTML(generalAdviceTxt.attributedText) : generalAdviceTxt.text),
            general: isExamOn ? "1" : "0",
            temperature: (temp?.isEmpty ?? true) ? nil : temp,
            bloodPressureSystolic: (sys?.isEmpty ?? true) ? nil : sys,
            bloodPressureDiastolic: (dia?.isEmpty ?? true) ? nil : dia,
            pulse: (pulse?.isEmpty ?? true) ? nil : pulse,
            bloodSugar: (sugar?.isEmpty ?? true) ? nil : sugar,
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
        /*
        // Existing implementation preserved:
        let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        let isExamOn = genralSwitchButton.isOn
        var param: [String: Any] = [
            "token": token,
            "language_type": code,
            "title": template.title,
            "chief_complain": template.chiefComplain ?? "",
            "past_history": template.pastHistory ?? "",
            "general": isExamOn ? "1" : "0",
            "temperature": template.temperature ?? "",
            "pulse": template.pulse ?? "",
            "blood_first": template.bloodPressureSystolic ?? "",
            "blood_second": template.bloodPressureDiastolic ?? "",
            "blood_pressure_systolic": template.bloodPressureSystolic ?? "",
            "blood_pressure_diastolic": template.bloodPressureDiastolic ?? "",
            "blood_sugar": template.bloodSugar ?? "",
            "blood_sugar_first": template.bloodSugar ?? "",
            "diagnosis": template.provisionalDiagnosis ?? "",
            "provisional_diagnosis": template.provisionalDiagnosis ?? "",
            "general_advice": template.generalAdvice ?? "",
            "advice": template.generalAdvice ?? "",
            "followup": template.followUpDays ?? "",
            "follow_up_days": template.followUpDays ?? "",
            "followup_value": template.followUpDays ?? "",
//            "investigation": template.investigations ?? [],
            "investigations": (template.investigations ?? []).joined(separator: ", ")
        ]
        
        if let meds = template.medicines {
            let medDicts = meds.map { med -> [String: Any] in
                var dict: [String: Any] = [
                    "name": med.name,
                    "dosage": med.dosage,
                    "frequency_first": med.frequencyFirst,
                    "duration": med.duration,
                    "meals": med.meals
                ]
                // Only send id if it's an existing valid integer id from the backend
                if let id = med.id, !id.isEmpty, Int(id) != nil {
                    dict["id"] = id
                }
                if let str = med.strength, !str.isEmpty {
                    dict["medicine_strength"] = str
                }
                return dict
            }
            param["medicines"] = medDicts
//            param["medicine"] = medDicts
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
        */

        // Same request structure as PrescriptionViewController (excluding booking_id, user_id, member_id, patient_name)
        let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        let cheifComplain = chiefComplaintTxt.text ?? template.chiefComplain ?? ""
        let pastHistory = pastHistoryTxt.text ?? template.pastHistory ?? ""
        let general = genralSwitchButton.isOn ? "1" : "0"
        let temprature = tempTxt.text ?? template.temperature ?? ""
        let systolicBps = systolicTxt.text ?? template.bloodPressureSystolic ?? ""
        let diaystolicBp = diastolicTxt.text ?? template.bloodPressureDiastolic ?? ""
        let pulse = pulseTxt.text ?? template.pulse ?? ""
        let bloodSugarFast = sugarTxt.text ?? template.bloodSugar ?? ""
        let bloodSugar2nd = ""
        let diagnosis = provisionalDiagnosisTxt.text ?? template.provisionalDiagnosis ?? ""
        // let generalAdvice = generalAdviceTxt.text ?? template.generalAdvice ?? ""
        let generalAdviceRaw: String
        if let saved = savedGeneralAdviceHTML, !saved.isEmpty {
            generalAdviceRaw = saved
        } else if let attr = generalAdviceTxt.attributedText, attr.length > 0 {
            generalAdviceRaw = AdviceHTMLHelper.attributedStringToHTML(attr)
        } else {
            generalAdviceRaw = generalAdviceTxt.text ?? template.generalAdvice ?? ""
        }
        let generalAdvice = AdviceHTMLHelper.convertToHTML(plainOrFormattedText: generalAdviceRaw)
        let followupValue = followUpDaysTxt.text ?? template.followUpDays ?? ""
        let followup = followupValue.isEmpty ? "0" : followupValue
        
        var medicineArray = [[String: Any]]()
        (template.medicines ?? medicinesList).forEach { slot in
            let medDict: [String: Any] = [
                "name": "\(slot.name)",
                "id": "\(slot.id ?? "")",
                "dosage": "\(slot.dosage)",
                "frequency_first": "\(slot.frequencyFirst)",
                "duration": "\(slot.duration)",
                "meals": "\(slot.meals)"
            ]
            medicineArray.append(medDict)
        }
        
        var parameter: [String: Any] = [
            "token": token,
            "language_type": code,
            "title": template.title,
            "chief_complain": cheifComplain,
            "past_history": pastHistory,
            "general": general,
            "temperature": temprature,
            "blood_first": systolicBps,
            "blood_second": diaystolicBp,
            "pulse": pulse,
            "blood_sugar_first": bloodSugarFast,
            "blood_sugar_second": bloodSugar2nd,
            "diagnosis": diagnosis,
            "investigation": investigationsTxt.text ?? "",
            "general_advice": generalAdvice,
            "followup": followup,
            "followup_value": followupValue,
            "medicines": medicineArray
        ]
        
        if let existingId = existingTemplate?.id {
            parameter["template_id"] = existingId
            parameter["id"] = existingId
            firstly {
                service!.updatePrescriptionTemplate(parameters: parameter, header: "DeviceToken")
            }.done { (resp: PrescriptionTemplateCommonResponse) in
                print("Template updated successfully on server: \(resp)")
            }.catch { error in
                print("Template update API fallback: \(error.localizedDescription)")
            }
        } else {
            firstly {
                service!.createPrescriptionTemplate(parameters: parameter, header: "DeviceToken")
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
            let cleanId = (med.id.isEmpty || Int(med.id) == nil) ? nil : med.id
            let item = TemplateMedicine(
                id: cleanId,
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
        if let idx = editingMedicineIndex, idx < medicinesList.count, let updated = passData.first {
            let cleanId = (updated.id.isEmpty || Int(updated.id) == nil) ? medicinesList[idx].id : updated.id
            medicinesList[idx] = TemplateMedicine(
                id: cleanId,
                name: updated.name,
                dosage: updated.dosage,
                frequencyFirst: updated.frequencyFirst,
                duration: updated.duration,
                meals: updated.meals
            )
            editingMedicineIndex = nil
            refreshMedicinesUI()
        }
    }
}
