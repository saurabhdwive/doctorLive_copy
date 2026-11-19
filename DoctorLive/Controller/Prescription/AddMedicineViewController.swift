//
//  AddMedicineViewController.swift
//  DoctorLive
//
//  Created by cst on 12/10/21.
//

import UIKit
import RSSelectionMenu
import PromiseKit
import DropDown

protocol DataDelegate {
    func userData(passData: [Medicine])
    func userEditData(passData: [Medicine])
}

class AddMedicineViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // Outlets preserved for logic & storyboard compatibility
    @IBOutlet var medicineNameTxt: UITextField!
    @IBOutlet var frequency1: UITextField!
    @IBOutlet var doseTxt: UITextField!
    @IBOutlet var durationTxt: UITextField!
    @IBOutlet var backView: UIView!
    @IBOutlet var mealTxt: UITextField!
    @IBOutlet var mainView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var durationView: UIView!
    @IBOutlet var mealView: UIView!
    @IBOutlet var mealLbl: UILabel!
    @IBOutlet var addMedicineLbl: UILabel!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var dosage: UILabel!
    @IBOutlet var frequencyLbl: UILabel!
    
    // Modern UI Elements
    private let sheetView = UIView()
    private let closeBtn = UIButton(type: .custom)
    private let selectedMedicineCard = UIView()
    private let medicineBrandLabel = UILabel()
    private let medicineStrengthLabel = UILabel()
    private let medicineGenericFormLabel = UILabel()
    
    private let pill1 = UIButton(type: .custom)
    private let pill2 = UIButton(type: .custom)
    private let pill3 = UIButton(type: .custom)
    private let pillCustom = UIButton(type: .custom)
    private let frequencyDescriptionLabel = UILabel()
    private let customFrequencyBox = UIView()
    private let customFrequencyTxt = InsetPaddedTextField()
    
    private var sheetBottomConstraint: NSLayoutConstraint!
    private var selectedFrequency: String = "1+1+1"
    
    var medicineEdit: Bool?
    var medicineName = String()
    var autocompleteUrls = [String]()
    var navController: UINavigationController?
    var delegate: DataDelegate?
    var controller = UIViewController()
    var dropDown = DropDown()
    var editMedicne = [String: String]()
    var editMed: Bool?
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    var investigationState: Bool = false
    var followUpState: Bool = false
    var genralExamState: Bool = false
    var workItem: DispatchWorkItem?
    
    var medicineId: String?
    var selectedMedicineItem: Medicinelisting?
    
    // MARK: - Lifecycle
    override func loadView() {
        buildModernSheetUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setupKeyboardObservers()
        setupInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Modern UI Construction
    private func buildModernSheetUI() {
        let rootView = UIView()
        rootView.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        self.view = rootView
        self.backView = rootView
        
        let backdropTap = UITapGestureRecognizer(target: self, action: #selector(backdropTapped(_:)))
        backdropTap.delegate = self
        rootView.addGestureRecognizer(backdropTap)
        
        // Sheet Card Container
        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 24
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.layer.masksToBounds = true
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView = sheetView
        rootView.addSubview(sheetView)
        
        sheetBottomConstraint = sheetView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        
        let sheetHeight = sheetView.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.78)
        sheetHeight.priority = UILayoutPriority(800)
        
        let minSheetHeight = sheetView.heightAnchor.constraint(greaterThanOrEqualToConstant: 540)
        minSheetHeight.priority = UILayoutPriority(850)
        
        let maxSheetTop = sheetView.topAnchor.constraint(greaterThanOrEqualTo: rootView.safeAreaLayoutGuide.topAnchor, constant: 30)
        
        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            sheetBottomConstraint,
            sheetHeight,
            minSheetHeight,
            maxSheetTop
        ])
        
        // 1. Header View
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.addSubview(headerView)
        
        addMedicineLbl = UILabel()
        addMedicineLbl.text = editMed == true ? "Edit Medicine".localized() : "Add Medicine".localized()
        addMedicineLbl.font = UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        addMedicineLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0) // #1E293B
        addMedicineLbl.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(addMedicineLbl)
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0) // #F1F5F9
        closeBtn.layer.cornerRadius = 16
        closeBtn.clipsToBounds = true
        if let xImg = UIImage(systemName: "xmark") {
            closeBtn.setImage(xImg, for: .normal)
            closeBtn.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0) // #64748B
        } else {
            closeBtn.setTitle("✕", for: .normal)
            closeBtn.setTitleColor(UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0), for: .normal)
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        closeBtn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeBtn)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 18),
            headerView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 34),
            
            addMedicineLbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            addMedicineLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeBtn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            closeBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: 32),
            closeBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 2. Action Button (pinned at bottom above safe area)
        addButton = UIButton(type: .system)
        addButton.setTitle(editMed == true ? "Update Medicine".localized() : "Add Medicine".localized(), for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0) // #1976D2
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addMoreTapped(_:)), for: .touchUpInside)
        sheetView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 3. Scrollable Form Content
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -14)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        // --- Component 1: Selected Medicine Card ---
        selectedMedicineCard.backgroundColor = UIColor(red: 240/255, green: 247/255, blue: 255/255, alpha: 1.0) // #F0F7FF
        selectedMedicineCard.layer.cornerRadius = 12
        selectedMedicineCard.layer.borderWidth = 1
        selectedMedicineCard.layer.borderColor = UIColor(red: 219/255, green: 234/255, blue: 254/255, alpha: 1.0).cgColor // #DBEAFE
        selectedMedicineCard.translatesAutoresizingMaskIntoConstraints = false
        selectedMedicineCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 68).isActive = true
        
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(selectMedicineTapped))
        selectedMedicineCard.addGestureRecognizer(cardTap)
        stackView.addArrangedSubview(selectedMedicineCard)
        
        let cardContentStack = UIStackView()
        cardContentStack.axis = .vertical
        cardContentStack.spacing = 4
        cardContentStack.translatesAutoresizingMaskIntoConstraints = false
        selectedMedicineCard.addSubview(cardContentStack)
        
        let line1Stack = UIStackView()
        line1Stack.axis = .horizontal
        line1Stack.spacing = 8
        line1Stack.alignment = .center
        line1Stack.translatesAutoresizingMaskIntoConstraints = false
        cardContentStack.addArrangedSubview(line1Stack)
        
        medicineBrandLabel.text = "Napa"
        medicineBrandLabel.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        medicineBrandLabel.textColor = UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0) // #1D4ED8
        medicineBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        line1Stack.addArrangedSubview(medicineBrandLabel)
        
        medicineStrengthLabel.text = "120 mg/5 ml"
        medicineStrengthLabel.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        medicineStrengthLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0) // #64748B
        medicineStrengthLabel.translatesAutoresizingMaskIntoConstraints = false
        line1Stack.addArrangedSubview(medicineStrengthLabel)
        
        let cardSpacer = UIView()
        cardSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        line1Stack.addArrangedSubview(cardSpacer)
        
        let searchIcon = UIImageView()
        if let magImg = UIImage(systemName: "magnifyingglass") {
            searchIcon.image = magImg
            searchIcon.tintColor = UIColor(red: 96/255, green: 165/255, blue: 250/255, alpha: 1.0)
        }
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        searchIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        line1Stack.addArrangedSubview(searchIcon)
        
        medicineGenericFormLabel.text = "Paracetamol · Syrup"
        medicineGenericFormLabel.font = UIFont(name: "Poppins-Regular", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5)
        medicineGenericFormLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0) // #64748B
        medicineGenericFormLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContentStack.addArrangedSubview(medicineGenericFormLabel)
        
        NSLayoutConstraint.activate([
            cardContentStack.topAnchor.constraint(equalTo: selectedMedicineCard.topAnchor, constant: 14),
            cardContentStack.bottomAnchor.constraint(equalTo: selectedMedicineCard.bottomAnchor, constant: -14),
            cardContentStack.leadingAnchor.constraint(equalTo: selectedMedicineCard.leadingAnchor, constant: 16),
            cardContentStack.trailingAnchor.constraint(equalTo: selectedMedicineCard.trailingAnchor, constant: -16)
        ])
        
        // Hidden textfield for backing compatibility
        medicineNameTxt = UITextField()
        medicineNameTxt.isHidden = true
        medicineNameTxt.text = "Napa 120 mg/5 ml\nParacetamol · Syrup"
        selectedMedicineCard.addSubview(medicineNameTxt)
        
        // --- Component 2: Dosage Section ---
        let dosageSection = UIStackView()
        dosageSection.axis = .vertical
        dosageSection.spacing = 6
        stackView.addArrangedSubview(dosageSection)
        
        dosage = UILabel()
        dosage.text = "Dosage".localized()
        dosage.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        dosage.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        dosageSection.addArrangedSubview(dosage)
        
        let doseBox = createInputFieldContainer(height: 46)
        dosageSection.addArrangedSubview(doseBox)
        
        doseTxt = InsetPaddedTextField()
        doseTxt.placeholder = "1 Tablet"
        doseTxt.text = "1 Tablet"
        doseTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        doseTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        doseTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        doseTxt.translatesAutoresizingMaskIntoConstraints = false
        doseBox.addSubview(doseTxt)
        
        NSLayoutConstraint.activate([
            doseTxt.topAnchor.constraint(equalTo: doseBox.topAnchor),
            doseTxt.bottomAnchor.constraint(equalTo: doseBox.bottomAnchor),
            doseTxt.leadingAnchor.constraint(equalTo: doseBox.leadingAnchor),
            doseTxt.trailingAnchor.constraint(equalTo: doseBox.trailingAnchor)
        ])
        
        // --- Component 3: Frequency Section ---
        let frequencySection = UIStackView()
        frequencySection.axis = .vertical
        frequencySection.spacing = 8
        stackView.addArrangedSubview(frequencySection)
        
        frequencyLbl = UILabel()
        frequencyLbl.text = "Frequency".localized()
        frequencyLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        frequencyLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        frequencySection.addArrangedSubview(frequencyLbl)
        
        let pillsStack = UIStackView()
        pillsStack.axis = .horizontal
        pillsStack.spacing = 8
        pillsStack.distribution = .fillEqually
        pillsStack.translatesAutoresizingMaskIntoConstraints = false
        pillsStack.heightAnchor.constraint(equalToConstant: 42).isActive = true
        frequencySection.addArrangedSubview(pillsStack)
        
        pill1.setTitle("1+1+1", for: .normal)
        pill2.setTitle("1+0+1", for: .normal)
        pill3.setTitle("0+0+1", for: .normal)
        pillCustom.setTitle("Custom".localized(), for: .normal)
        
        [pill1, pill2, pill3, pillCustom].forEach { pill in
            pill.addTarget(self, action: #selector(frequencyPillTapped(_:)), for: .touchUpInside)
            pillsStack.addArrangedSubview(pill)
        }
        
        frequencyDescriptionLabel.text = "Morning + afternoon + night. Prints as 1+1+1."
        frequencyDescriptionLabel.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        frequencyDescriptionLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        frequencyDescriptionLabel.numberOfLines = 0
        frequencySection.addArrangedSubview(frequencyDescriptionLabel)
        
        // Custom Frequency input (revealed when Custom is selected)
        customFrequencyBox.translatesAutoresizingMaskIntoConstraints = false
        customFrequencyBox.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        customFrequencyBox.layer.cornerRadius = 10
        customFrequencyBox.layer.borderWidth = 1
        customFrequencyBox.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        customFrequencyBox.heightAnchor.constraint(equalToConstant: 44).isActive = true
        customFrequencyBox.isHidden = true
        frequencySection.addArrangedSubview(customFrequencyBox)
        
        customFrequencyTxt.placeholder = "e.g. 1+0+0, Once daily"
        customFrequencyTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        customFrequencyTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        customFrequencyTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        customFrequencyTxt.translatesAutoresizingMaskIntoConstraints = false
        customFrequencyTxt.addTarget(self, action: #selector(customFrequencyChanged), for: .editingChanged)
        customFrequencyBox.addSubview(customFrequencyTxt)
        
        NSLayoutConstraint.activate([
            customFrequencyTxt.topAnchor.constraint(equalTo: customFrequencyBox.topAnchor),
            customFrequencyTxt.bottomAnchor.constraint(equalTo: customFrequencyBox.bottomAnchor),
            customFrequencyTxt.leadingAnchor.constraint(equalTo: customFrequencyBox.leadingAnchor),
            customFrequencyTxt.trailingAnchor.constraint(equalTo: customFrequencyBox.trailingAnchor)
        ])
        
        // Backing frequency1 textfield
        frequency1 = UITextField()
        frequency1.isHidden = true
        frequency1.text = "1+1+1"
        sheetView.addSubview(frequency1)
        
        selectFrequency(preset: "1+1+1")
        
        // --- Component 4: Duration Section ---
        let durationSection = UIStackView()
        durationSection.axis = .vertical
        durationSection.spacing = 6
        stackView.addArrangedSubview(durationSection)
        
        durationLbl = UILabel()
        durationLbl.text = "Duration".localized()
        durationLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        durationLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        durationSection.addArrangedSubview(durationLbl)
        
        let durationBox = createInputFieldContainer(height: 46)
        durationSection.addArrangedSubview(durationBox)
        self.durationView = durationBox
        
        durationTxt = InsetPaddedTextField()
        durationTxt.placeholder = "7 days"
        durationTxt.text = "7 days"
        durationTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        durationTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        durationTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        durationTxt.translatesAutoresizingMaskIntoConstraints = false
        durationBox.addSubview(durationTxt)
        
        NSLayoutConstraint.activate([
            durationTxt.topAnchor.constraint(equalTo: durationBox.topAnchor),
            durationTxt.bottomAnchor.constraint(equalTo: durationBox.bottomAnchor),
            durationTxt.leadingAnchor.constraint(equalTo: durationBox.leadingAnchor),
            durationTxt.trailingAnchor.constraint(equalTo: durationBox.trailingAnchor)
        ])
        
        // --- Component 5: Instruction Section ---
        let instructionSection = UIStackView()
        instructionSection.axis = .vertical
        instructionSection.spacing = 6
        stackView.addArrangedSubview(instructionSection)
        
        mealLbl = UILabel()
        mealLbl.text = "Instruction".localized()
        mealLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        mealLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        instructionSection.addArrangedSubview(mealLbl)
        
        let mealBox = createInputFieldContainer(height: 46)
        instructionSection.addArrangedSubview(mealBox)
        self.mealView = mealBox
        
        mealTxt = InsetPaddedTextField()
        mealTxt.placeholder = "After Meal"
        mealTxt.text = "After Meal"
        mealTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        mealTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        mealTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        mealTxt.translatesAutoresizingMaskIntoConstraints = false
        mealBox.addSubview(mealTxt)
        
        NSLayoutConstraint.activate([
            mealTxt.topAnchor.constraint(equalTo: mealBox.topAnchor),
            mealTxt.bottomAnchor.constraint(equalTo: mealBox.bottomAnchor),
            mealTxt.leadingAnchor.constraint(equalTo: mealBox.leadingAnchor),
            mealTxt.trailingAnchor.constraint(equalTo: mealBox.trailingAnchor)
        ])
        
        let hintLabel = UILabel()
        hintLabel.text = "Dosage, duration and instruction are free text — type anything."
        hintLabel.font = UIFont(name: "Poppins-Regular", size: 11.5) ?? UIFont.systemFont(ofSize: 11.5)
        hintLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        hintLabel.numberOfLines = 0
        instructionSection.addArrangedSubview(hintLabel)
    }
    
    private func createInputFieldContainer(height: CGFloat = 46) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0) // #F8FAFC
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor // #E2E8F0
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: height).isActive = true
        return container
    }
    
    // MARK: - Initial Data Population
    private func setupInitialData() {
        if editMed == true {
            addMedicineLbl.text = "Edit Medicine".localized()
            addButton.setTitle("Update Medicine".localized(), for: .normal)
            
            let rawName = editMedicne["name"] ?? ""
            self.medicineName = rawName
            self.medicineNameTxt.text = rawName
            self.medicineId = editMedicne["id"] ?? ""
            parseAndSetMedicine(rawName: rawName)
            
            if let dose = editMedicne["dosage"], !dose.isEmpty {
                doseTxt.text = dose
            }
            if let freq = editMedicne["frequency_first"], !freq.isEmpty {
                selectFrequency(preset: freq)
            }
            if let duration = editMedicne["duration"], !duration.isEmpty {
                durationTxt.text = duration
            }
            if let meals = editMedicne["meals"], !meals.isEmpty {
                mealTxt.text = meals
            }
        } else if !medicineName.isEmpty {
            parseAndSetMedicine(rawName: medicineName)
            medicineNameTxt.text = medicineName
        } else {
            // Default preview matching design artifact
            updateMedicineCardUI(brand: "Napa", strength: "120 mg/5 ml", generic: "Paracetamol", form: "Syrup")
            self.medicineName = "Napa"
            self.medicineNameTxt.text = "Napa 120 mg/5 ml\nParacetamol · Syrup"
        }
    }
    
    private func parseAndSetMedicine(rawName: String) {
        let lines = rawName.components(separatedBy: "\n")
        if lines.count >= 2 {
            let line1 = lines[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let line2 = lines[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let parts = line1.components(separatedBy: " ")
            if parts.count >= 2 {
                let brand = parts[0]
                let strength = parts.dropFirst().joined(separator: " ")
                updateMedicineCardUI(brand: brand, strength: strength, generic: line2, form: "")
            } else {
                updateMedicineCardUI(brand: line1, strength: "", generic: line2, form: "")
            }
        } else {
            let parts = rawName.components(separatedBy: " ")
            if parts.count >= 2 {
                let brand = parts[0]
                let strength = parts.dropFirst().joined(separator: " ")
                updateMedicineCardUI(brand: brand, strength: strength, generic: "Tap to search from drug database", form: "")
            } else {
                updateMedicineCardUI(brand: rawName.isEmpty ? "Select Medicine" : rawName, strength: "", generic: "Tap to search from drug database", form: "")
            }
        }
    }
    
    private func updateMedicineCardUI(brand: String, strength: String, generic: String, form: String) {
        medicineBrandLabel.text = brand.isEmpty ? "Select Medicine" : brand
        medicineStrengthLabel.text = strength
        medicineStrengthLabel.isHidden = strength.isEmpty
        
        var subParts: [String] = []
        if !generic.isEmpty { subParts.append(generic) }
        if !form.isEmpty { subParts.append(form) }
        let subtitle = subParts.joined(separator: " · ")
        medicineGenericFormLabel.text = subtitle.isEmpty ? "Tap to search from drug database" : subtitle
    }
    
    // MARK: - Frequency Handling
    @objc private func frequencyPillTapped(_ sender: UIButton) {
        view.endEditing(true)
        if sender == pill1 {
            selectFrequency(preset: "1+1+1")
        } else if sender == pill2 {
            selectFrequency(preset: "1+0+1")
        } else if sender == pill3 {
            selectFrequency(preset: "0+0+1")
        } else {
            selectFrequency(preset: "Custom")
            customFrequencyTxt.becomeFirstResponder()
        }
    }
    
    private func selectFrequency(preset: String) {
        selectedFrequency = preset
        let pills = [pill1, pill2, pill3, pillCustom]
        for pill in pills {
            let isSelected = (pill.title(for: .normal) == preset) || (preset != "1+1+1" && preset != "1+0+1" && preset != "0+0+1" && pill == pillCustom)
            stylePill(pill, selected: isSelected)
        }
        
        if preset == "1+1+1" {
            frequencyDescriptionLabel.text = "Morning + afternoon + night. Prints as 1+1+1."
            customFrequencyBox.isHidden = true
            frequency1.text = "1+1+1"
        } else if preset == "1+0+1" {
            frequencyDescriptionLabel.text = "Morning + night. Prints as 1+0+1."
            customFrequencyBox.isHidden = true
            frequency1.text = "1+0+1"
        } else if preset == "0+0+1" {
            frequencyDescriptionLabel.text = "Night only. Prints as 0+0+1."
            customFrequencyBox.isHidden = true
            frequency1.text = "0+0+1"
        } else {
            frequencyDescriptionLabel.text = "Custom frequency. Enter custom timing below."
            customFrequencyBox.isHidden = false
            if !(customFrequencyTxt.text?.isEmpty ?? true) {
                frequency1.text = customFrequencyTxt.text
            } else {
                customFrequencyTxt.text = preset != "Custom" ? preset : ""
                frequency1.text = customFrequencyTxt.text
            }
        }
    }
    
    @objc private func customFrequencyChanged() {
        frequency1.text = customFrequencyTxt.text
    }
    
    private func stylePill(_ button: UIButton, selected: Bool) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        if selected {
            button.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0) // #EFF6FF
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0).cgColor // #2563EB
            button.setTitleColor(UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0), for: .normal)
            button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        } else {
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor // #E2E8F0
            button.setTitleColor(UIColor(red: 71/255, green: 85/255, blue: 105/255, alpha: 1.0), for: .normal) // #475569
            button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    // MARK: - Actions
    @objc func selectMedicineTapped() {
        let vc = MedicineSearchVC()
        self.medicineEdit = false
        vc.medicineDetailCallback = { [weak self] item in
            guard let self = self else { return }
            self.selectedMedicineItem = item
            let brand = item.brandName ?? ""
            let strength = item.strength ?? ""
            let generic = item.genericName ?? ""
            let form = item.form ?? ""
            self.medicineName = brand
            self.medicineId = item.id ?? ""
            
            var formattedName = brand
            if !strength.isEmpty {
                formattedName += " \(strength)"
            }
            if !generic.isEmpty || !form.isEmpty {
                var subParts: [String] = []
                if !generic.isEmpty { subParts.append(generic) }
                if !form.isEmpty { subParts.append(form) }
                formattedName += "\n" + subParts.joined(separator: " · ")
            }
            self.medicineNameTxt.text = formattedName
            self.updateMedicineCardUI(brand: brand, strength: strength, generic: generic, form: form)
            
            if form.lowercased().contains("syrup") || form.lowercased().contains("suspension") {
                if self.doseTxt.text?.isEmpty ?? true || self.doseTxt.text == "1 Tablet" {
                    self.doseTxt.text = "5 ml"
                }
            } else if form.lowercased().contains("tablet") || form.lowercased().contains("capsule") {
                if self.doseTxt.text?.isEmpty ?? true || self.doseTxt.text == "5 ml" {
                    self.doseTxt.text = "1 Tablet"
                }
            }
        }
        vc.medicinecallback = { [weak self] (name, id) in
            guard let self = self else { return }
            self.medicineName = name ?? ""
            self.medicineId = id ?? ""
            if self.medicineNameTxt.text?.isEmpty ?? true {
                self.medicineNameTxt.text = name ?? ""
            }
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func addMedicneTapped(_ sender: Any) {
        selectMedicineTapped()
    }
    
    @IBAction func addMoreTapped(_ sender: Any) {
        guard let name = medicineNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            AppToast.showMessage1(message: "Please Add Medicine Name".localized(), self)
            return
        }
        guard let dose = doseTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dose.isEmpty else {
            AppToast.showMessage1(message: "Please Select doses".localized(), self)
            return
        }
        guard let freq1 = frequency1.text?.trimmingCharacters(in: .whitespacesAndNewlines), !freq1.isEmpty else {
            AppToast.showMessage1(message: "Please Add Frequency".localized(), self)
            return
        }
        guard let duration = durationTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !duration.isEmpty else {
            AppToast.showMessage1(message: "Please Add Duration".localized(), self)
            return
        }
        guard let meal = mealTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !meal.isEmpty else {
            AppToast.showMessage1(message: "Please Add Meals".localized(), self)
            return
        }
        
        let med = Medicine(
            id: self.medicineId ?? "",
            name: name,
            dosage: dose,
            frequencyFirst: freq1,
            duration: duration,
            meals: meal,
            toggleBtnState: true,
            genralExamState: self.genralExamState,
            followUpState: self.followUpState,
            investigationState: self.investigationState,
            comeFromMedicne: true
        )
        
        if editMed == true {
            self.delegate?.userEditData(passData: [med])
        } else {
            self.delegate?.userData(passData: [med])
        }
        
        dismissOrPop()
    }
    
    @objc func closeButtonTapped() {
        dismissOrPop()
    }
    
    @objc func backdropTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !sheetView.frame.contains(location) {
            dismissOrPop()
        }
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        dismissOrPop()
    }
    
    func dismissOrPop() {
        view.endEditing(true)
        if let nav = self.navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func frequencyTapped(_ sender: Any) {
        selectFrequency(preset: "Custom")
        customFrequencyTxt.becomeFirstResponder()
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        sheetBottomConstraint.constant = -max(0, bottomInset)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        sheetBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view || touch.view == backView
    }
}
