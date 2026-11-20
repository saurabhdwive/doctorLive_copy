//
//  PrescriptionViewController.swift
//  DoctorLive
//
//  Created by cst on 11/10/21.
//

import UIKit
import RSSelectionMenu
import PromiseKit
import SideMenu
import SwiftyJSON

protocol VideoCallFlowDelagate {
    func prescriptionBackFunc(_ returnToVideo: Bool, _ medicineState: Bool, _ investigationState: Bool, _ genralExamState: Bool, _ followUpState: Bool)
}

// MARK: - Modern UI Helper Views
class DashedBorderView: UIView {
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        borderLayer.strokeColor = UIColor(red: 96/255, green: 165/255, blue: 250/255, alpha: 1.0).cgColor
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 1.5
        borderLayer.lineDashPattern = [5, 4]
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
}

class InsetPaddedTextField: UITextField {
    var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}

class MultilineInputTextField: UITextView, UITextViewDelegate {
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
        setupInternalView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInternalView()
    }
    
    private func setupInternalView() {
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

// MARK: - PrescriptionViewController
class PrescriptionViewController: UIViewController, DataDelegate, DeletePresecriptionDelegate, UIGestureRecognizerDelegate {
    
    // Outlets preserved for logic & API compatibility
    @IBOutlet var userName: UILabel!
    @IBOutlet var yearOldLable: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var dateTxt: UILabel!
    @IBOutlet var investigationLbl: UILabel!
    @IBOutlet var medicineLbl: UILabel!
    @IBOutlet var titleTxt: UILabel!
    @IBOutlet var gernralExamTitle: UILabel!
    @IBOutlet var tempLbl: UILabel!
    @IBOutlet var bloodPressureLbl: UILabel!
    @IBOutlet var pluseLbl: UILabel!
    @IBOutlet var bloodSugarLbl: UILabel!
    @IBOutlet var followUpTitle: UILabel!
    
    @IBOutlet var ChiefTxtComplain: MultilineInputTextField!
    @IBOutlet var pastHistoryTxt: MultilineInputTextField!
    @IBOutlet var tempLable: UITextField!
    @IBOutlet var systolicBp: UITextField!
    @IBOutlet var diaystolicLable: UITextField!
    @IBOutlet var pulseTxt: UITextField!
    @IBOutlet var bloodSugar1: UITextField!
    @IBOutlet var provisionTxt: MultilineInputTextField!
    @IBOutlet var bloodSugar2: UITextField!
    @IBOutlet var investigationTxt: UITextField!
    @IBOutlet var genralTxt: MultilineInputTextField!
    @IBOutlet var followUpDays: UITextField!
    
    @IBOutlet var pastHistory: UIView!
    @IBOutlet var genralExaminationView: UIView!
    @IBOutlet var userDetailView: UIView!
    @IBOutlet var provisonDiagnos: UIView!
    @IBOutlet var investigationView: UIView!
    @IBOutlet var genralView: UIView!
    @IBOutlet var followUpView: UIView!
    @IBOutlet var medicineView: UIView!
    @IBOutlet var ChiefComplainView: UIView!
    
    @IBOutlet var genralSwitchButton: UISwitch!
    @IBOutlet var medicinceTogle: UISwitch!
    @IBOutlet var investigationToggle: UISwitch!
    @IBOutlet var switchButton: UISwitch!
    
    @IBOutlet var tempButton: UIButton!
    @IBOutlet var systolicButton: UIButton!
    @IBOutlet var pulseButton: UIButton!
    @IBOutlet var sugar1Button: UIButton!
    @IBOutlet var sugar2Button: UIButton!
    @IBOutlet var diastyolicButton: UIButton!
    @IBOutlet var xrayButton: UIButton!
    @IBOutlet var submItButton: UIButton!
    @IBOutlet var addMedicineView: UIButton!
    @IBOutlet var changePatientBtn: UIButton!
    
    @IBOutlet var medicineViewHeight: NSLayoutConstraint!
    @IBOutlet var investigationViewHeight: NSLayoutConstraint!
    @IBOutlet var genralViewHeight: NSLayoutConstraint!
    @IBOutlet var prescriptionHeight: NSLayoutConstraint!
    @IBOutlet var tableHightConstraint: NSLayoutConstraint!
    
    @IBOutlet var investigationDropDown: UIImageView!
    @IBOutlet var genralExamStack: UIStackView!
    @IBOutlet var tableView: UITableView!
    
    // Additional UI Elements for modern redesigned layout
    var patientSubtitleLabel = UILabel()
    var autoSaveStatusLabel = UILabel()
    var templateCardView = DashedBorderView()
    var chipsScrollView = UIScrollView()
    var chipsStackView = UIStackView()
    var formatAdviceBtn = UIButton(type: .system)
    var autoSaveTimer: Timer?
    var lastSavedDate = Date().addingTimeInterval(-12)
    var medicineContentStack = UIStackView()
    var followUpContentRow = UIView()
    var investigationContentStack = UIStackView()
    
    var selectedNames: [String] = []
    var comeFromMedicne = Bool()
    var index = Int()
    var videoCallflowdelegate: VideoCallFlowDelagate?
    var medicineData = [Medicine]()
    var specialtyListArray:[String] = Array()
    var bookingId: String?
    var avilability: String? = "1"
    var genral: String? = "1"
    var xRay = false
    var returnToVideo: Bool = false
    var xRayValue: String?
    var arrayData = [Medicine]()
    var data = [String: String]()
    var medicineDict = [String: String]()
    var controller = UIViewController()
    var prescriptionDataDict = [String: Any]()
    var comeFrom = String()
    var menu: SideMenuNavigationController?
    var medicineSwitch: Bool = true
    var investigationToggleState: Bool = true
    var genralSwitchButtonState: Bool = true
    var followUpState: Bool = true
    var bookingIdComeFromChat: String? = ""
    var isComingFromChat:Bool = false
    var initialTemplate: PrescriptionTemplate?
    var patientUserId: String?
    var bookedPatientName: String?
    var currentMemberRelationship: String?
    
    var effectivePatientUserId: String {
        if let id = patientUserId, !id.isEmpty { return id }
        if let id = data["user_id"], !id.isEmpty { return id }
        if let id = data["userId"], !id.isEmpty { return id }
        if let id = data["patient_id"], !id.isEmpty { return id }
        if let id = UserDefaults.standard.string(forKey: "current_patient_user_id"), !id.isEmpty { return id }
        return ""
    }
    
    var isPatientOtherThanMyself: Bool {
        if let rel = currentMemberRelationship?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !rel.isEmpty {
            if rel != "me" && rel != "account holder" && rel != "myself" {
                return true
            }
        }
        if let rel = data["relationship"]?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !rel.isEmpty {
            if rel != "me" && rel != "account holder" && rel != "myself" {
                return true
            }
        }
        if let rel = data["member_relationship"]?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !rel.isEmpty {
            if rel != "me" && rel != "account holder" && rel != "myself" {
                return true
            }
        }
        if let memberId = data["member_id"]?.trimmingCharacters(in: .whitespacesAndNewlines), !memberId.isEmpty {
            let rel = currentMemberRelationship?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
            if rel != "me" && rel != "account holder" && rel != "myself" {
                return true
            }
        }
        return false
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        buildModernUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validations()
        setupUi()
        
        let initialName = data["name"] ?? data["patient_name"] ?? data["memberName"] ?? bookedPatientName ?? ""
        let initialGender = data["gender"] ?? data["patient_gender"] ?? data["member_gender"] ?? ""
        let initialDob = data["date"] ?? data["dob"] ?? data["member_dob"] ?? ""
        let initialRel = data["relationship"] ?? data["member_relationship"] ?? currentMemberRelationship ?? ""
        let initialMemberId = data["member_id"]
        
        applyPatientInfo(
            name: initialName,
            gender: initialGender,
            dobOrAge: initialDob,
            relationship: initialRel,
            memberId: initialMemberId
        )
        
        if bookedPatientName == nil || bookedPatientName?.isEmpty == true {
            if !initialName.isEmpty {
                bookedPatientName = initialName
            }
        }
        
        dateTxt.text = Date.getCurrentDate()
        fetchPatientDetailsIfNeeded()
        updateInvestigationChips()
        startAutoSaveTimer()
        
        if let template = initialTemplate {
            applyTemplate(template)
        }
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var current = touch.view
        while let view = current {
            if view is UITextField || view is UITextView || view is UIControl {
                return false
            }
            current = view.superview
        }
        return true
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        investigationToggle.isOn = investigationToggleState
        medicinceTogle.isOn = medicineSwitch
        genralSwitchButton.isOn = genralSwitchButtonState
        switchButton.isOn = followUpState
        titleTxt.text = "Prescriptions".localized()
        ChiefTxtComplain.placeholder = "Chief Complain".localized()
        pastHistoryTxt.placeholder = "Past History".localized()
        provisionTxt.placeholder = "Provisional Diagnosis".localized()
        genralTxt.placeholder = "General Advice".localized()
        gernralExamTitle.text = "General Examination".localized()
        medicineLbl.text = "Medicine".localized()
        tempLbl.text = "Temperature".localized()
        bloodPressureLbl.text = "Blood Pressure".localized()
        pluseLbl.text = "Pulse".localized()
        investigationLbl.text = "Investigation".localized()
        bloodSugarLbl.text = "Blood Sugar".localized()
        submItButton.setTitle("Submit".localized(), for: .normal)
        addMedicineView.setTitle("+ Add Medicine".localized(), for: .normal)
        followUpTitle.text = "Follow Up".localized()
        
        if comeFromMedicne == true {
            print("hi")
            investigationToggle.isOn = investigationToggleState
            investigationContentStack.isHidden = !investigationToggleState
            investigationTxt.isHidden = !investigationToggleState
            investigationDropDown.isHidden = !investigationToggleState
            updateInvestigationChips()
        } else {
            if comeFrom == "videoCallViaChat" {
                savePrescriptionData()
            } else {
                let bookingIdFromChat = UserDefaults.standard.string(forKey: "bookingIdComeFromChat")
                if bookingIdFromChat == bookingId {
                    savePrescriptionData()
                } else {
                    print("hi")
                    pastHistoryTxt.text = ""
                    provisionTxt.text = ""
                    tempLable.text = ""
                    bloodSugar1.text = ""
                    bloodSugar2.text = ""
                    systolicBp.text = ""
                    diaystolicLable.text = ""
                    ChiefTxtComplain.text = ""
                    pulseTxt.text = ""
                    genralTxt.text = ""
                    followUpDays.text = ""
                    investigationTxt.text = ""
                    arrayData.removeAll()
                }
            }
        }
        
        genralSwitchButton.isOn = genralSwitchButtonState
        investigationToggle.isOn = investigationToggleState
        medicinceTogle.isOn = medicineSwitch
        switchButton.isOn = followUpState
        
        genralExamStack.isHidden = !genralSwitchButtonState
        investigationContentStack.isHidden = !investigationToggleState
        investigationTxt.isHidden = !investigationToggleState
        investigationDropDown.isHidden = !investigationToggleState
        medicineContentStack.isHidden = !medicineSwitch
        followUpContentRow.isHidden = !followUpState
        
        self.genral = genralSwitchButtonState ? "1" : "0"
        self.avilability = followUpState ? "1" : "0"
        
        updatePatientSubtitle()
        updateInvestigationChips()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        autoSaveTimer?.invalidate()
        savePrescriptionData1()
    }
    
    // MARK: - Patient Info & Auto-save helpers
    func applyPatientInfo(name: String?, gender: String?, dobOrAge: String?, relationship: String?, memberId: String? = nil) {
        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !trimmedName.isEmpty && trimmedName.lowercased() != "me" {
            userName.text = trimmedName
            self.data["name"] = trimmedName
            if bookedPatientName == nil || bookedPatientName?.isEmpty == true {
                bookedPatientName = trimmedName
            }
        } else if (userName.text ?? "").isEmpty {
            let fallbackName = (bookedPatientName != nil && !bookedPatientName!.isEmpty) ? bookedPatientName! : "Patient".localized()
            userName.text = fallbackName
        }
        
        if let memberId = memberId, !memberId.isEmpty {
            self.data["member_id"] = memberId
        }
        
        if let rel = relationship?.trimmingCharacters(in: .whitespacesAndNewlines), !rel.isEmpty {
            let cleanRel = (rel.lowercased() == "me") ? "Account holder" : rel.capitalized
            currentMemberRelationship = cleanRel
            self.data["relationship"] = cleanRel
        }
        
        if let g = gender?.trimmingCharacters(in: .whitespacesAndNewlines), !g.isEmpty {
            let formattedG = PatientMember.formatGender(g)
            self.gender.text = formattedG
            self.data["gender"] = g
        }
        
        if let dob = dobOrAge?.trimmingCharacters(in: .whitespacesAndNewlines), !dob.isEmpty {
            let formattedA = PatientMember.formatAge(from: dob)
            self.yearOldLable.text = formattedA
            self.data["date"] = formattedA
            self.data["dob"] = dob
        }
        
        updatePatientSubtitle()
    }
    
    func updatePatientSubtitle() {
        let genderStr = gender.text ?? ""
        var ageStr = yearOldLable.text ?? ""
        if !ageStr.isEmpty {
            ageStr = PatientMember.formatAge(from: ageStr)
        }
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateStr = df.string(from: Date())
        
        var parts: [String] = []
        if let rel = currentMemberRelationship, !rel.isEmpty {
            parts.append(rel)
        }
        if !genderStr.isEmpty { parts.append(genderStr) }
        if !ageStr.isEmpty { parts.append(ageStr) }
        if !dateStr.isEmpty { parts.append(dateStr) }
        patientSubtitleLabel.text = parts.joined(separator: " · ")
    }
    
    func fetchPatientDetailsIfNeeded() {
        let uid = effectivePatientUserId
        guard !uid.isEmpty else { return }
        
        var params: [String: Any] = [:]
        if let intId = Int(uid) {
            params["user_id"] = intId
        } else {
            params["user_id"] = uid
        }
        
        firstly {
            service!.getMembers(parameters: params, header: "DeviceToken")
        }.done { [weak self] (response: MembersResponse) in
            guard let self = self else { return }
            let members = response.data ?? []
            guard !members.isEmpty else { return }
            
            let targetMember: PatientMember?
            if let memberId = self.data["member_id"], !memberId.isEmpty {
                targetMember = members.first(where: { $0.member_id == memberId })
            } else if let currentName = self.userName.text, !currentName.isEmpty, currentName != "Patient".localized() {
                targetMember = members.first(where: { ($0.member_name ?? "").caseInsensitiveCompare(currentName) == .orderedSame })
                               ?? members.first(where: { ($0.member_relationship ?? "").lowercased() == "me" })
                               ?? members.first
            } else {
                targetMember = members.first(where: { ($0.member_relationship ?? "").lowercased() == "me" })
                               ?? members.first
            }
            
            guard let member = targetMember else { return }
            
            let resolvedName: String
            if let mName = member.member_name, !mName.isEmpty, mName.lowercased() != "me" {
                resolvedName = mName
            } else {
                let existing = (self.userName.text != "Patient".localized()) ? (self.userName.text ?? "") : ""
                resolvedName = !existing.isEmpty ? existing : (self.bookedPatientName ?? "Patient".localized())
            }
            
            self.applyPatientInfo(
                name: resolvedName,
                gender: member.member_gender,
                dobOrAge: member.member_dob,
                relationship: member.displayRelationship,
                memberId: member.member_id
            )
        }.catch { error in
            print("fetchPatientDetailsIfNeeded error: \(error.localizedDescription)")
        }
    }
    
    func startAutoSaveTimer() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateAutoSaveBanner()
        }
    }
    
    func updateAutoSaveBanner() {
        let elapsed = Int(Date().timeIntervalSince(lastSavedDate))
        if elapsed < 5 {
            autoSaveStatusLabel.text = "✓ Draft saved just now"
        } else if elapsed < 60 {
            autoSaveStatusLabel.text = "✓ Draft saved \(elapsed) seconds ago"
        } else {
            let mins = elapsed / 60
            autoSaveStatusLabel.text = "✓ Draft saved \(mins)m ago"
        }
    }
    
    func updateInvestigationChips() {
        chipsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let raw = investigationTxt.text ?? ""
        var items = raw.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        // If empty, supply preview suggestions if needed
        if items.isEmpty && (investigationToggle?.isOn ?? false) {
            chipsScrollView.isHidden = true
            return
        }
        
        if items.isEmpty {
            chipsScrollView.isHidden = true
        } else {
            chipsScrollView.isHidden = false
            for item in items {
                let pill = createChipPill(title: item)
                chipsStackView.addArrangedSubview(pill)
            }
        }
    }
    
    private func createChipPill(title: String) -> UIView {
        let chip = UIView()
        chip.backgroundColor = UIColor(red: 235/255, green: 245/255, blue: 255/255, alpha: 1.0) // #EBF5FF
        chip.layer.cornerRadius = 14
        chip.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0) // #1D4ED8
        label.translatesAutoresizingMaskIntoConstraints = false
        chip.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: chip.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: chip.bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: chip.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: chip.trailingAnchor, constant: -12),
            chip.heightAnchor.constraint(equalToConstant: 28)
        ])
        return chip
    }
    
    // MARK: - Save / Refill Prescriptions
    func savePrescriptionData() {
        let pastHistory = PrescriptionDetail.pasthistory ?? ""
        let provisionProfile = PrescriptionDetail.provisonalDiagnosis ?? ""
        let chiefComplain = PrescriptionDetail.cheifComaplain ?? ""
        let temprature = PrescriptionDetail.temprature ?? ""
        let bloodPressure1 = PrescriptionDetail.bloodPresure1 ?? ""
        let bloodPressure2 = PrescriptionDetail.bloodPresure2 ?? ""
        let puluse = PrescriptionDetail.pluse ?? ""
        let bloodsugar1 = PrescriptionDetail.bloodsugar1 ?? ""
        let bloodsugar2 = PrescriptionDetail.bloodsugar1 ?? ""
        let genralAdvice = PrescriptionDetail.genralAdvice ?? ""
        let followUpday = PrescriptionDetail.followUP ?? ""
        let investigation = PrescriptionDetail.investigationGuide ?? ""
        let medicineRefillData = PrescriptionDetail.medicineData
        if pastHistory.isEmpty || provisionProfile.isEmpty || temprature.isEmpty || bloodPressure1.isEmpty || bloodPressure2.isEmpty || puluse.isEmpty || bloodsugar1.isEmpty || bloodsugar2.isEmpty || genralAdvice.isEmpty || followUpday.isEmpty || investigation.isEmpty || chiefComplain.isEmpty == false {
            pastHistoryTxt.text = pastHistory
            provisionTxt.text = provisionProfile
            tempLable.text = temprature
            bloodSugar1.text = bloodsugar1
            bloodSugar2.text = bloodsugar2
            systolicBp.text = bloodPressure1
            diaystolicLable.text = bloodPressure2
            pulseTxt.text = puluse
            ChiefTxtComplain.text = chiefComplain
            investigationTxt.text = investigation
            genralTxt.text = genralAdvice
            followUpDays.text = followUpday
            if let medicineDatas = medicineRefillData, !medicineDatas.isEmpty {
                arrayData = medicineDatas
                tableView.reloadData()
            }
        } else {
            pastHistoryTxt.text = ""
            provisionTxt.text = ""
            tempLable.text = ""
            bloodSugar1.text = ""
            bloodSugar2.text = ""
            systolicBp.text = ""
            diaystolicLable.text = ""
            ChiefTxtComplain.text = ""
            pulseTxt.text = ""
            genralTxt.text = ""
            followUpDays.text = ""
            self.investigationTxt.text = ""
            self.arrayData.removeAll()
        }
        updateInvestigationChips()
    }
    
    fileprivate func savePrescriptionData1() {
        lastSavedDate = Date()
        updateAutoSaveBanner()
        if comeFrom == "videoCallViaChat" {
            PrescriptionDetail.pasthistory = pastHistoryTxt.text ?? ""
            PrescriptionDetail.provisonalDiagnosis = provisionTxt.text ?? ""
            PrescriptionDetail.bloodPresure1 = systolicBp.text ?? ""
            PrescriptionDetail.bloodPresure2 = diaystolicLable.text ?? ""
            PrescriptionDetail.temprature = tempLable.text ?? ""
            PrescriptionDetail.pluse = pulseTxt.text ?? ""
            PrescriptionDetail.bloodsugar1 = bloodSugar1.text ?? ""
            PrescriptionDetail.bloodsugar2 = bloodSugar2.text ?? ""
            PrescriptionDetail.genralAdvice = genralTxt.text ?? ""
            PrescriptionDetail.followUP = followUpDays.text ?? ""
            PrescriptionDetail.cheifComaplain = ChiefTxtComplain.text ?? ""
            PrescriptionDetail.genralExamToggle = genralSwitchButton
            PrescriptionDetail.medicineData = arrayData
            PrescriptionDetail.investigationGuide = investigationTxt.text ?? ""
        }
    }
    
    func setupUi() {
        submItButton.layer.cornerRadius = 12
        addMedicineView.layer.cornerRadius = 8
        prescriptionHeight.constant = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PrescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "PrescriptionTableViewCell")
        print("arrrray\(arrayData)")
    }
    
    func userData(passData: [Medicine]) {
        self.arrayData.append(contentsOf: passData)
        self.medicineSwitch = passData.first?.toggleBtnState ?? true
        self.followUpState = passData.first?.followUpState ?? true
        self.genralSwitchButtonState = passData.first?.genralExamState ?? true
        self.investigationToggleState = passData.first?.investigationState ?? false
        PrescriptionDetail.medicineData = arrayData
        self.comeFromMedicne = passData.first?.comeFromMedicne ?? true
        self.tableView.reloadData()
    }
    
    func userEditData(passData: [Medicine]) {
        if index < arrayData.count && !passData.isEmpty {
            self.arrayData[index] = passData[0]
        } else {
            self.arrayData.remove(at: index)
        }
        PrescriptionDetail.medicineData = arrayData
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func changePatientBtn_Action(_ sender: Any) {
        let uid = self.effectivePatientUserId
        if uid.isEmpty {
            let alert = UIAlertController(title: "Patient User ID", message: "Please enter the patient's account user_id to load family members:", preferredStyle: .alert)
            alert.addTextField { tf in
                tf.placeholder = "e.g. 55"
                tf.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
                guard let self = self, let enteredId = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !enteredId.isEmpty else { return }
                self.patientUserId = enteredId
                self.data["user_id"] = enteredId
                UserDefaults.standard.set(enteredId, forKey: "current_patient_user_id")
                self.changePatientBtn_Action(sender)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        let bottomSheet = ChangePatientBottomSheetViewController()
        bottomSheet.userId = uid
        bottomSheet.currentPatientName = self.userName.text
        bottomSheet.bookedPatientName = self.bookedPatientName ?? self.userName.text
        bottomSheet.currentMemberId = self.data["member_id"]
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .crossDissolve
        bottomSheet.onPatientConfirmed = { [weak self] member in
            guard let self = self else { return }
            self.applyPatientInfo(
                name: member.member_name,
                gender: member.member_gender,
                dobOrAge: member.member_dob,
                relationship: member.displayRelationship,
                memberId: member.member_id
            )
            self.savePrescriptionData1()
        }
        self.present(bottomSheet, animated: true)
    }
    
    @objc func investigationTextChanged() {
        updateInvestigationChips()
    }
    
    func applyTemplate(_ template: PrescriptionTemplate) {
        self.comeFromMedicne = true
        if let chief = template.chiefComplain, !chief.isEmpty {
            self.ChiefTxtComplain.text = chief
        }
        if let past = template.pastHistory, !past.isEmpty {
            self.pastHistoryTxt.text = past
        }
        if let diag = template.provisionalDiagnosis, !diag.isEmpty {
            self.provisionTxt.text = diag
        }
        var hasVitals = false
        if let temp = template.temperature, !temp.isEmpty {
            self.tempLable.text = temp
            hasVitals = true
        }
        if let pulse = template.pulse, !pulse.isEmpty {
            self.pulseTxt.text = pulse
            hasVitals = true
        }
        if let sys = template.bloodPressureSystolic, !sys.isEmpty {
            self.systolicBp.text = sys
            hasVitals = true
        }
        if let dia = template.bloodPressureDiastolic, !dia.isEmpty {
            self.diaystolicLable.text = dia
            hasVitals = true
        }
        if let sugar = template.bloodSugar, !sugar.isEmpty {
            self.bloodSugar1.text = sugar
            hasVitals = true
        }
        let shouldTurnOnExam: Bool
        if let gen = template.general {
            shouldTurnOnExam = (gen == "1")
        } else {
            shouldTurnOnExam = hasVitals
        }
        self.genralSwitchButton.isOn = shouldTurnOnExam
        self.genralExamSwitch(self.genralSwitchButton)
        if let tests = template.investigations, !tests.isEmpty {
            self.selectedNames = tests
            let text = tests.joined(separator: ", ")
            self.investigationTxt.text = text
            self.investigationToggleState = true
            self.investigationToggle.isOn = true
            self.investigationContentStack.isHidden = false
            self.investigationTxt.isHidden = false
            self.investigationDropDown.isHidden = false
            self.chipsScrollView.isHidden = false
            self.updateInvestigationChips()
            PrescriptionDetail.investigationGuide = text
        } else {
            self.selectedNames = []
            self.investigationTxt.text = ""
            self.investigationToggleState = false
            self.investigationToggle.isOn = false
            self.investigationContentStack.isHidden = true
            self.investigationTxt.isHidden = true
            self.investigationDropDown.isHidden = true
            self.chipsScrollView.isHidden = true
            PrescriptionDetail.investigationGuide = ""
        }
        if let advice = template.generalAdvice, !advice.isEmpty {
            self.genralTxt.text = AdviceHTMLHelper.htmlToPlainText(advice)
            PrescriptionDetail.genralAdvice = self.genralTxt.text
        }
        if let followUp = template.followUpDays, !followUp.isEmpty {
            self.followUpDays.text = followUp
            self.switchButton.isOn = true
            self.followUpSwitch(self.switchButton)
        }
        if let meds = template.medicines, !meds.isEmpty {
            self.arrayData = meds.map { med in
                Medicine(
                    id: med.id ?? UUID().uuidString,
                    name: med.name,
                    dosage: med.dosage,
                    frequencyFirst: med.frequencyFirst,
                    duration: med.duration,
                    meals: med.meals,
                    toggleBtnState: true,
                    genralExamState: true,
                    followUpState: true,
                    investigationState: true,
                    comeFromMedicne: true
                )
            }
            self.medicinceTogle.isOn = true
            self.medicineToggle(self.medicinceTogle)
            self.tableHightConstraint.constant = CGFloat(self.arrayData.count * 160)
            self.tableView.reloadData()
        } else {
            self.arrayData.removeAll()
            self.tableHightConstraint.constant = 0
            self.tableView.reloadData()
        }
        self.savePrescriptionData1()
        AppToast.showMessage(message: "Applied template: \(template.title)")
    }
    
    @objc func selectTemplateTapped() {
        self.comeFromMedicne = true
        let vc = PrescriptionTemplatesViewController()
        vc.isSelectMode = true
        vc.onSelectTemplate = { [weak self] template in
            self?.applyTemplate(template)
        }
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func formatGeneralAdviceTapped() {
        self.comeFromMedicne = true
        let vc = GeneralAdviceFormatViewController()
        vc.initialText = genralTxt.text ?? ""
        vc.onSave = { [weak self] formattedText in
            guard let self = self else { return }
            self.genralTxt.text = formattedText
            self.savePrescriptionData1()
        }
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func investigationToggleTapped(_ sender: UISwitch) {
        self.investigationToggleState = sender.isOn
        investigationTxt.isHidden = !sender.isOn
        investigationDropDown.isHidden = !sender.isOn
        UIView.animate(withDuration: 0.25) {
            self.investigationContentStack.isHidden = !sender.isOn
            self.view.layoutIfNeeded()
        }
        updateInvestigationChips()
    }
    
    @IBAction func medicineToggle(_ sender: UISwitch) {
        self.medicineSwitch = sender.isOn
        UIView.animate(withDuration: 0.25) {
            self.medicineContentStack.isHidden = !sender.isOn
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func menuButton(_ sender: Any) {
        savePrescriptionData1()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func noticficationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "NotificationViewController")
        show(secondVC, sender: self)
    }
    
    func buttonTapped(cell: PrescriptionTableViewCell){
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            guard let indexPath = self?.tableView.indexPath(for: cell) else {
                return
            }
            self?.tableView.beginUpdates()
            self?.arrayData.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            self?.tableView.endUpdates()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.tableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    @objc func buttonEditTapped(sender: UIButton) {
        self.index = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        medicineDict = ["id": "\(arrayData[index].id)", "name": "\(arrayData[index].name)", "dosage": "\(arrayData[index].dosage)", "frequency_first": "\(arrayData[index].frequencyFirst)","duration":"\(arrayData[index].duration)", "meals": "\(arrayData[index].meals)"]
        let vc = view.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.editMedicne = medicineDict
        vc.editMed = true
        vc.delegate = self
        vc.medicineEdit = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func genralExamSwitch(_ sender: UISwitch) {
        self.genralSwitchButtonState = sender.isOn
        self.genral = sender.isOn ? "1" : "0"
        UIView.animate(withDuration: 0.25) {
            self.genralExamStack.isHidden = !sender.isOn
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func tepmButtonTapped(_ sender: Any) {
        let data: [String] = ["97.5 °F", "98.5 °F", "99.5 °F", "100.5 °F", "101.2 °F", "102.0 °F"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.tempLable.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width > 0 ? tempButton.frame.width : 200, height: 180), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodPressure(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110", "120", "130", "140"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.systolicBp.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: systolicButton.frame.width > 0 ? systolicButton.frame.width : 160, height: 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodPresure2(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110", "120", "130", "140", "150", "160"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.diaystolicLable.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: diastyolicButton.frame.width > 0 ? diastyolicButton.frame.width : 160, height: 250), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func pulse(_ sender: Any) {
        let data: [String] = ["60", "70", "72", "80", "85", "90", "92", "100", "110"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.pulseTxt.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: pulseButton.frame.width > 0 ? pulseButton.frame.width : 200, height: 230), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodSugar1(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110", "120", "140"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.bloodSugar1.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: sugar1Button.frame.width > 0 ? sugar1Button.frame.width : 160, height: 230), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodSugar2(_ sender: Any) {
        let data: [String] = ["100", "110", "120", "130", "140", "160", "180"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.bloodSugar2.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: sugar2Button.frame.width > 0 ? sugar2Button.frame.width : 160, height: 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func xrayButtonTapped(_ sender: UIButton) {
        let menu = RSSelectionMenu(selectionStyle: .multiple, dataSource: specialtyListArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return self?.specialtyListArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.selectedNames = selectedItems
            let items = self.selectedNames.joined(separator:", ")
            self.investigationTxt.text = items
            self.updateInvestigationChips()
        }
        menu.show(style: .actionSheet(title: nil, action: "Done".localized(), height: nil), from: self)
    }
    
    @IBAction func addMedicineTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.delegate = self
        vc.controller = self
        vc.investigationState = investigationToggleState
        vc.followUpState = followUpState
        vc.genralExamState = genralSwitchButtonState
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func followUpSwitch(_ sender: UISwitch) {
        self.followUpState = sender.isOn
        self.avilability = sender.isOn ? "1" : "0"
        UIView.animate(withDuration: 0.25) {
            self.followUpContentRow.isHidden = !sender.isOn
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        print("🔘 [Submit] Submit button clicked")
        if self.ChiefTxtComplain.text?.isEmpty ?? false {
            print("⚠️ [Submit] Validation failed: Chief Complain is empty")
            AppToast.showMessage(message: "Please Add Chief Complain".localized())
        } else if self.provisionTxt.text?.isEmpty ?? false {
            print("⚠️ [Submit] Validation failed: Provisional Diagnosis is empty")
            AppToast.showMessage(message: "Please Add provisonal Diagnosis".localized())
        } else if self.genralTxt.text?.isEmpty ?? false {
            print("⚠️ [Submit] Validation failed: General Advice is empty")
            AppToast.showMessage(message: "Please Add General Advice".localized())
        } else {
            let alertController = UIAlertController(title: "Alert!".localized(), message: "Are you sure you want to save this prescription?".localized(), preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Yes".localized(), style: .default) { (action:UIAlertAction!) in
                print("✅ [Submit] Doctor confirmed: Saving prescription...")
                self.performSavePrescription()
            }
            alertController.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel) { (action:UIAlertAction!) in
                print("❌ [Submit] Doctor cancelled prescription save")
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion:nil)
            return
        }
    }
    
    // MARK: - Modern UI Construction
    private func buildModernUI() {
        let rootView = UIView()
        rootView.backgroundColor = UIColor(red: 244/255, green: 247/255, blue: 251/255, alpha: 1.0) // #F4F7FB
        self.view = rootView
        
        // 1. Navigation Header View
        let navBarView = UIView()
        navBarView.backgroundColor = rootView.backgroundColor
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(navBarView)
        
        let backBtn = UIButton(type: .custom)
        if let backImg = UIImage(systemName: "chevron.left") {
            backBtn.setImage(backImg, for: .normal)
            backBtn.tintColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        } else if let backImg = UIImage(named: "back1") {
            backBtn.setImage(backImg, for: .normal)
        }
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(menuButton(_:)), for: .touchUpInside)
        navBarView.addSubview(backBtn)
        
        titleTxt = UILabel()
        titleTxt.text = "Prescription"
        titleTxt.font = UIFont(name: "Poppins-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        titleTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        titleTxt.textAlignment = .center
        titleTxt.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(titleTxt)
        
        let notifBtn = UIButton(type: .custom)
        if let notifImg = UIImage(systemName: "bell") {
            notifBtn.setImage(notifImg, for: .normal)
            notifBtn.tintColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        } else if let notifImg = UIImage(named: "NotificationIcon") {
            notifBtn.setImage(notifImg, for: .normal)
        }
        notifBtn.translatesAutoresizingMaskIntoConstraints = false
        notifBtn.addTarget(self, action: #selector(noticficationButton(_:)), for: .touchUpInside)
        navBarView.addSubview(notifBtn)
        
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 44),
            
            backBtn.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 16),
            backBtn.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 32),
            backBtn.heightAnchor.constraint(equalToConstant: 32),
            
            titleTxt.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            titleTxt.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            
            notifBtn.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -16),
            notifBtn.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            notifBtn.widthAnchor.constraint(equalToConstant: 32),
            notifBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 2. Auto-save Banner
        let autoSaveBanner = UIView()
        autoSaveBanner.backgroundColor = UIColor(red: 234/255, green: 247/255, blue: 238/255, alpha: 1.0) // #EAF7EE
        autoSaveBanner.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(autoSaveBanner)
        
        autoSaveStatusLabel.text = "✓ Draft saved 12 seconds ago"
        autoSaveStatusLabel.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        autoSaveStatusLabel.textColor = UIColor(red: 30/255, green: 122/255, blue: 55/255, alpha: 1.0) // #1E7A37
        autoSaveStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        autoSaveBanner.addSubview(autoSaveStatusLabel)
        
        let autoSaveHintLabel = UILabel()
        autoSaveHintLabel.text = "Auto-saves as you write"
        autoSaveHintLabel.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        autoSaveHintLabel.textColor = UIColor(red: 92/255, green: 138/255, blue: 105/255, alpha: 1.0) // #5C8A69
        autoSaveHintLabel.textAlignment = .right
        autoSaveHintLabel.translatesAutoresizingMaskIntoConstraints = false
        autoSaveBanner.addSubview(autoSaveHintLabel)
        
        NSLayoutConstraint.activate([
            autoSaveBanner.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            autoSaveBanner.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            autoSaveBanner.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            autoSaveBanner.heightAnchor.constraint(equalToConstant: 36),
            
            autoSaveStatusLabel.leadingAnchor.constraint(equalTo: autoSaveBanner.leadingAnchor, constant: 16),
            autoSaveStatusLabel.centerYAnchor.constraint(equalTo: autoSaveBanner.centerYAnchor),
            
            autoSaveHintLabel.trailingAnchor.constraint(equalTo: autoSaveBanner.trailingAnchor, constant: -16),
            autoSaveHintLabel.centerYAnchor.constraint(equalTo: autoSaveBanner.centerYAnchor)
        ])
        
        // 3. Fixed Bottom Bar with Submit Button
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = rootView.backgroundColor
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(bottomBarView)
        
        submItButton = UIButton(type: .system)
        submItButton.setTitle("Submit", for: .normal)
        submItButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        submItButton.setTitleColor(.white, for: .normal)
        submItButton.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0) // #1976D2
        submItButton.layer.cornerRadius = 10
        submItButton.clipsToBounds = true
        submItButton.translatesAutoresizingMaskIntoConstraints = false
        submItButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        bottomBarView.addSubview(submItButton)
        
        NSLayoutConstraint.activate([
            bottomBarView.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 68),
            
            submItButton.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 8),
            submItButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            submItButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16),
            submItButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 4. ScrollView with Card Content
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: autoSaveBanner.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor)
        ])
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 14
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 14),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        // --- Card 1: Patient Card (userDetailView) ---
        userDetailView = createCardView()
        contentStackView.addArrangedSubview(userDetailView)
        
        let avatarCircle = UIView()
        avatarCircle.backgroundColor = UIColor(red: 235/255, green: 243/255, blue: 252/255, alpha: 1.0) // #EBF3FC
        avatarCircle.layer.cornerRadius = 22
        avatarCircle.layer.masksToBounds = true
        avatarCircle.translatesAutoresizingMaskIntoConstraints = false
        userDetailView.addSubview(avatarCircle)
        
        let avatarIcon = UIImageView()
        avatarIcon.contentMode = .scaleAspectFit
        if let personImg = UIImage(systemName: "person") {
            avatarIcon.image = personImg
            avatarIcon.tintColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        } else if let userImg = UIImage(named: "User-1") {
            avatarIcon.image = userImg
        }
        avatarIcon.translatesAutoresizingMaskIntoConstraints = false
        avatarCircle.addSubview(avatarIcon)
        
        userName = UILabel()
        userName.text = ""
        userName.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        userName.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userDetailView.addSubview(userName)
        
        patientSubtitleLabel.text = ""
        patientSubtitleLabel.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        patientSubtitleLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        patientSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userDetailView.addSubview(patientSubtitleLabel)
        
        // Hidden outlets kept for logic
        yearOldLable = UILabel()
        gender = UILabel()
        dateTxt = UILabel()
        
        changePatientBtn = UIButton(type: .system)
        changePatientBtn.setTitle("Change patient", for: .normal)
        changePatientBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        changePatientBtn.setTitleColor(UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0), for: .normal)
        changePatientBtn.backgroundColor = .white
        changePatientBtn.layer.cornerRadius = 8
        changePatientBtn.layer.borderWidth = 1.5
        changePatientBtn.layer.borderColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0).cgColor
        changePatientBtn.translatesAutoresizingMaskIntoConstraints = false
        changePatientBtn.addTarget(self, action: #selector(changePatientBtn_Action(_:)), for: .touchUpInside)
        userDetailView.addSubview(changePatientBtn)
        
        NSLayoutConstraint.activate([
            avatarCircle.leadingAnchor.constraint(equalTo: userDetailView.leadingAnchor, constant: 14),
            avatarCircle.centerYAnchor.constraint(equalTo: userDetailView.centerYAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 44),
            avatarCircle.heightAnchor.constraint(equalToConstant: 44),
            
            avatarIcon.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            avatarIcon.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),
            avatarIcon.widthAnchor.constraint(equalToConstant: 22),
            avatarIcon.heightAnchor.constraint(equalToConstant: 22),
            
            userName.leadingAnchor.constraint(equalTo: avatarCircle.trailingAnchor, constant: 12),
            userName.topAnchor.constraint(equalTo: userDetailView.topAnchor, constant: 16),
            userName.trailingAnchor.constraint(lessThanOrEqualTo: changePatientBtn.leadingAnchor, constant: -8),
            
            patientSubtitleLabel.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            patientSubtitleLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 3),
            patientSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: changePatientBtn.leadingAnchor, constant: -8),
            patientSubtitleLabel.bottomAnchor.constraint(equalTo: userDetailView.bottomAnchor, constant: -16),
            
            changePatientBtn.trailingAnchor.constraint(equalTo: userDetailView.trailingAnchor, constant: -14),
            changePatientBtn.centerYAnchor.constraint(equalTo: userDetailView.centerYAnchor),
            changePatientBtn.widthAnchor.constraint(equalToConstant: 120),
            changePatientBtn.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // --- Card 2: Select Template Card ---
        templateCardView.backgroundColor = UIColor(red: 240/255, green: 247/255, blue: 255/255, alpha: 1.0) // #F0F7FF
        templateCardView.layer.cornerRadius = 12
        templateCardView.clipsToBounds = true
        templateCardView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(templateCardView)
        
        let templateIcon = UIImageView()
        templateIcon.contentMode = .scaleAspectFit
        if let docImg = UIImage(systemName: "rectangle.split.2x1") {
            templateIcon.image = docImg
            templateIcon.tintColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        } else if let defImg = UIImage(named: "prescription") {
            templateIcon.image = defImg
        }
        templateIcon.translatesAutoresizingMaskIntoConstraints = false
        templateCardView.addSubview(templateIcon)
        
        let templateTitle = UILabel()
        templateTitle.text = "Select template"
        templateTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        templateTitle.textColor = UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0) // #1D4ED8
        templateTitle.translatesAutoresizingMaskIntoConstraints = false
        templateCardView.addSubview(templateTitle)
        
        let templateSub = UILabel()
        templateSub.text = "Load a saved prescription, then edit it"
        templateSub.font = UIFont(name: "Poppins-Regular", size: 11.5) ?? UIFont.systemFont(ofSize: 11.5, weight: .regular)
        templateSub.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        templateSub.translatesAutoresizingMaskIntoConstraints = false
        templateCardView.addSubview(templateSub)
        
        let templateChevron = UIImageView()
        templateChevron.contentMode = .scaleAspectFit
        if let chevImg = UIImage(systemName: "chevron.down") {
            templateChevron.image = chevImg
            templateChevron.tintColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        } else if let chevImg = UIImage(named: "down_arrow") {
            templateChevron.image = chevImg
        }
        templateChevron.translatesAutoresizingMaskIntoConstraints = false
        templateCardView.addSubview(templateChevron)
        
        let templateTapBtn = UIButton(type: .custom)
        templateTapBtn.translatesAutoresizingMaskIntoConstraints = false
        templateTapBtn.addTarget(self, action: #selector(selectTemplateTapped), for: .touchUpInside)
        templateCardView.addSubview(templateTapBtn)
        
        NSLayoutConstraint.activate([
            templateIcon.leadingAnchor.constraint(equalTo: templateCardView.leadingAnchor, constant: 14),
            templateIcon.centerYAnchor.constraint(equalTo: templateCardView.centerYAnchor),
            templateIcon.widthAnchor.constraint(equalToConstant: 22),
            templateIcon.heightAnchor.constraint(equalToConstant: 22),
            
            templateTitle.leadingAnchor.constraint(equalTo: templateIcon.trailingAnchor, constant: 12),
            templateTitle.topAnchor.constraint(equalTo: templateCardView.topAnchor, constant: 12),
            templateTitle.trailingAnchor.constraint(lessThanOrEqualTo: templateChevron.leadingAnchor, constant: -8),
            
            templateSub.leadingAnchor.constraint(equalTo: templateTitle.leadingAnchor),
            templateSub.topAnchor.constraint(equalTo: templateTitle.bottomAnchor, constant: 2),
            templateSub.trailingAnchor.constraint(lessThanOrEqualTo: templateChevron.leadingAnchor, constant: -8),
            templateSub.bottomAnchor.constraint(equalTo: templateCardView.bottomAnchor, constant: -12),
            
            templateChevron.trailingAnchor.constraint(equalTo: templateCardView.trailingAnchor, constant: -14),
            templateChevron.centerYAnchor.constraint(equalTo: templateCardView.centerYAnchor),
            templateChevron.widthAnchor.constraint(equalToConstant: 16),
            templateChevron.heightAnchor.constraint(equalToConstant: 16),
            
            templateTapBtn.topAnchor.constraint(equalTo: templateCardView.topAnchor),
            templateTapBtn.bottomAnchor.constraint(equalTo: templateCardView.bottomAnchor),
            templateTapBtn.leadingAnchor.constraint(equalTo: templateCardView.leadingAnchor),
            templateTapBtn.trailingAnchor.constraint(equalTo: templateCardView.trailingAnchor)
        ])
        
        // --- Card 3: Chief Complain ---
        ChiefComplainView = createCardView()
        contentStackView.addArrangedSubview(ChiefComplainView)
        
        let chiefTitle = UILabel()
        chiefTitle.text = "Chief Complain"
        chiefTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        chiefTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        chiefTitle.translatesAutoresizingMaskIntoConstraints = false
        ChiefComplainView.addSubview(chiefTitle)
        
        let chiefBox = createInputFieldContainer(height: 70)
        ChiefComplainView.addSubview(chiefBox)
        
        ChiefTxtComplain = MultilineInputTextField()
        ChiefTxtComplain.placeholder = "Chief Complain"
        ChiefTxtComplain.translatesAutoresizingMaskIntoConstraints = false
        chiefBox.addSubview(ChiefTxtComplain)
        
        NSLayoutConstraint.activate([
            chiefTitle.topAnchor.constraint(equalTo: ChiefComplainView.topAnchor, constant: 14),
            chiefTitle.leadingAnchor.constraint(equalTo: ChiefComplainView.leadingAnchor, constant: 14),
            chiefTitle.trailingAnchor.constraint(equalTo: ChiefComplainView.trailingAnchor, constant: -14),
            
            chiefBox.topAnchor.constraint(equalTo: chiefTitle.bottomAnchor, constant: 10),
            chiefBox.leadingAnchor.constraint(equalTo: ChiefComplainView.leadingAnchor, constant: 14),
            chiefBox.trailingAnchor.constraint(equalTo: ChiefComplainView.trailingAnchor, constant: -14),
            chiefBox.bottomAnchor.constraint(equalTo: ChiefComplainView.bottomAnchor, constant: -14),
            
            ChiefTxtComplain.topAnchor.constraint(equalTo: chiefBox.topAnchor),
            ChiefTxtComplain.bottomAnchor.constraint(equalTo: chiefBox.bottomAnchor),
            ChiefTxtComplain.leadingAnchor.constraint(equalTo: chiefBox.leadingAnchor),
            ChiefTxtComplain.trailingAnchor.constraint(equalTo: chiefBox.trailingAnchor)
        ])
        
        // --- Card 4: Past History ---
        pastHistory = createCardView()
        contentStackView.addArrangedSubview(pastHistory)
        
        let pastTitle = UILabel()
        pastTitle.text = "Past History"
        pastTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        pastTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        pastTitle.translatesAutoresizingMaskIntoConstraints = false
        pastHistory.addSubview(pastTitle)
        
        let pastBox = createInputFieldContainer(height: 70)
        pastHistory.addSubview(pastBox)
        
        pastHistoryTxt = MultilineInputTextField()
        pastHistoryTxt.placeholder = "Past History"
        pastHistoryTxt.translatesAutoresizingMaskIntoConstraints = false
        pastBox.addSubview(pastHistoryTxt)
        
        NSLayoutConstraint.activate([
            pastTitle.topAnchor.constraint(equalTo: pastHistory.topAnchor, constant: 14),
            pastTitle.leadingAnchor.constraint(equalTo: pastHistory.leadingAnchor, constant: 14),
            pastTitle.trailingAnchor.constraint(equalTo: pastHistory.trailingAnchor, constant: -14),
            
            pastBox.topAnchor.constraint(equalTo: pastTitle.bottomAnchor, constant: 10),
            pastBox.leadingAnchor.constraint(equalTo: pastHistory.leadingAnchor, constant: 14),
            pastBox.trailingAnchor.constraint(equalTo: pastHistory.trailingAnchor, constant: -14),
            pastBox.bottomAnchor.constraint(equalTo: pastHistory.bottomAnchor, constant: -14),
            
            pastHistoryTxt.topAnchor.constraint(equalTo: pastBox.topAnchor),
            pastHistoryTxt.bottomAnchor.constraint(equalTo: pastBox.bottomAnchor),
            pastHistoryTxt.leadingAnchor.constraint(equalTo: pastBox.leadingAnchor),
            pastHistoryTxt.trailingAnchor.constraint(equalTo: pastBox.trailingAnchor)
        ])
        
        // --- Card 5: General Examination (genralExaminationView) ---
        genralExaminationView = createCardView()
        contentStackView.addArrangedSubview(genralExaminationView)
        
        let genralCardStack = UIStackView()
        genralCardStack.axis = .vertical
        genralCardStack.spacing = 14
        genralCardStack.translatesAutoresizingMaskIntoConstraints = false
        genralExaminationView.addSubview(genralCardStack)
        
        let genralHeaderRow = UIStackView()
        genralHeaderRow.axis = .horizontal
        genralHeaderRow.alignment = .center
        genralHeaderRow.distribution = .equalSpacing
        genralHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        genralCardStack.addArrangedSubview(genralHeaderRow)
        
        gernralExamTitle = UILabel()
        gernralExamTitle.text = "General Examination"
        gernralExamTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        gernralExamTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        genralHeaderRow.addArrangedSubview(gernralExamTitle)
        
        genralSwitchButton = UISwitch()
        genralSwitchButton.onTintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        genralSwitchButton.isOn = true
        genralSwitchButton.addTarget(self, action: #selector(genralExamSwitch(_:)), for: .valueChanged)
        genralHeaderRow.addArrangedSubview(genralSwitchButton)
        
        genralExamStack = UIStackView()
        genralExamStack.axis = .horizontal
        genralExamStack.distribution = .fillEqually
        genralExamStack.spacing = 12
        genralExamStack.translatesAutoresizingMaskIntoConstraints = false
        genralCardStack.addArrangedSubview(genralExamStack)
        
        // Left Column (Temperature, Blood pressure)
        let leftCol = UIStackView()
        leftCol.axis = .vertical
        leftCol.spacing = 10
        leftCol.distribution = .fillEqually
        genralExamStack.addArrangedSubview(leftCol)
        
        // Temperature
        let tempContainer = UIView()
        tempLbl = UILabel()
        tempLbl.text = "Temperature"
        tempLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        tempLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        tempLbl.translatesAutoresizingMaskIntoConstraints = false
        tempContainer.addSubview(tempLbl)
        
        let tempBox = createInputFieldContainer(height: 44)
        tempContainer.addSubview(tempBox)
        
        tempLable = InsetPaddedTextField()
        tempLable.placeholder = "101.2 °F"
        tempLable.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        tempLable.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        tempLable.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        tempLable.keyboardType = .numbersAndPunctuation
        tempLable.isUserInteractionEnabled = true
        tempLable.translatesAutoresizingMaskIntoConstraints = false
        tempBox.addSubview(tempLable)
        
        tempButton = UIButton(type: .custom)
        tempButton.isHidden = true
        tempBox.addSubview(tempButton)
        
        NSLayoutConstraint.activate([
            tempLbl.topAnchor.constraint(equalTo: tempContainer.topAnchor),
            tempLbl.leadingAnchor.constraint(equalTo: tempContainer.leadingAnchor),
            
            tempBox.topAnchor.constraint(equalTo: tempLbl.bottomAnchor, constant: 4),
            tempBox.leadingAnchor.constraint(equalTo: tempContainer.leadingAnchor),
            tempBox.trailingAnchor.constraint(equalTo: tempContainer.trailingAnchor),
            tempBox.bottomAnchor.constraint(equalTo: tempContainer.bottomAnchor),
            
            tempLable.topAnchor.constraint(equalTo: tempBox.topAnchor),
            tempLable.bottomAnchor.constraint(equalTo: tempBox.bottomAnchor),
            tempLable.leadingAnchor.constraint(equalTo: tempBox.leadingAnchor),
            tempLable.trailingAnchor.constraint(equalTo: tempBox.trailingAnchor)
        ])
        leftCol.addArrangedSubview(tempContainer)
        
        // Blood pressure
        let bpContainer = UIView()
        bloodPressureLbl = UILabel()
        bloodPressureLbl.text = "Blood pressure"
        bloodPressureLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        bloodPressureLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        bloodPressureLbl.translatesAutoresizingMaskIntoConstraints = false
        bpContainer.addSubview(bloodPressureLbl)
        
        let bpBox = createInputFieldContainer(height: 44)
        bpContainer.addSubview(bpBox)
        
        let bpRow = UIStackView()
        bpRow.axis = .horizontal
        bpRow.distribution = .fillProportionally
        bpRow.spacing = 2
        bpRow.translatesAutoresizingMaskIntoConstraints = false
        bpBox.addSubview(bpRow)
        
        systolicBp = InsetPaddedTextField()
        systolicBp.placeholder = "120"
        systolicBp.textAlignment = .center
        systolicBp.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        systolicBp.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        systolicBp.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        systolicBp.keyboardType = .numberPad
        systolicBp.isUserInteractionEnabled = true
        systolicBp.translatesAutoresizingMaskIntoConstraints = false
        bpRow.addArrangedSubview(systolicBp)
        
        let slashLbl = UILabel()
        slashLbl.text = "/"
        slashLbl.font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        slashLbl.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        slashLbl.textAlignment = .center
        slashLbl.translatesAutoresizingMaskIntoConstraints = false
        slashLbl.widthAnchor.constraint(equalToConstant: 12).isActive = true
        bpRow.addArrangedSubview(slashLbl)
        
        diaystolicLable = InsetPaddedTextField()
        diaystolicLable.placeholder = "80"
        diaystolicLable.textAlignment = .center
        diaystolicLable.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        diaystolicLable.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        diaystolicLable.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        diaystolicLable.keyboardType = .numberPad
        diaystolicLable.isUserInteractionEnabled = true
        diaystolicLable.translatesAutoresizingMaskIntoConstraints = false
        bpRow.addArrangedSubview(diaystolicLable)
        
        systolicButton = UIButton(type: .custom)
        systolicButton.isHidden = true
        bpBox.addSubview(systolicButton)
        
        diastyolicButton = UIButton(type: .custom)
        diastyolicButton.isHidden = true
        bpBox.addSubview(diastyolicButton)
        
        NSLayoutConstraint.activate([
            bloodPressureLbl.topAnchor.constraint(equalTo: bpContainer.topAnchor),
            bloodPressureLbl.leadingAnchor.constraint(equalTo: bpContainer.leadingAnchor),
            
            bpBox.topAnchor.constraint(equalTo: bloodPressureLbl.bottomAnchor, constant: 4),
            bpBox.leadingAnchor.constraint(equalTo: bpContainer.leadingAnchor),
            bpBox.trailingAnchor.constraint(equalTo: bpContainer.trailingAnchor),
            bpBox.bottomAnchor.constraint(equalTo: bpContainer.bottomAnchor),
            
            bpRow.topAnchor.constraint(equalTo: bpBox.topAnchor),
            bpRow.bottomAnchor.constraint(equalTo: bpBox.bottomAnchor),
            bpRow.leadingAnchor.constraint(equalTo: bpBox.leadingAnchor, constant: 6),
            bpRow.trailingAnchor.constraint(equalTo: bpBox.trailingAnchor, constant: -6)
        ])
        leftCol.addArrangedSubview(bpContainer)
        
        // Right Column (Pulse, Blood sugar)
        let rightCol = UIStackView()
        rightCol.axis = .vertical
        rightCol.spacing = 10
        rightCol.distribution = .fillEqually
        genralExamStack.addArrangedSubview(rightCol)
        
        // Pulse
        let pulseContainer = UIView()
        pluseLbl = UILabel()
        pluseLbl.text = "Pulse"
        pluseLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        pluseLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        pluseLbl.translatesAutoresizingMaskIntoConstraints = false
        pulseContainer.addSubview(pluseLbl)
        
        let pulseBox = createInputFieldContainer(height: 44)
        pulseContainer.addSubview(pulseBox)
        
        pulseTxt = InsetPaddedTextField()
        pulseTxt.placeholder = "92"
        pulseTxt.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        pulseTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        pulseTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        pulseTxt.keyboardType = .numberPad
        pulseTxt.isUserInteractionEnabled = true
        pulseTxt.translatesAutoresizingMaskIntoConstraints = false
        pulseBox.addSubview(pulseTxt)
        
        pulseButton = UIButton(type: .custom)
        pulseButton.isHidden = true
        pulseBox.addSubview(pulseButton)
        
        NSLayoutConstraint.activate([
            pluseLbl.topAnchor.constraint(equalTo: pulseContainer.topAnchor),
            pluseLbl.leadingAnchor.constraint(equalTo: pulseContainer.leadingAnchor),
            
            pulseBox.topAnchor.constraint(equalTo: pluseLbl.bottomAnchor, constant: 4),
            pulseBox.leadingAnchor.constraint(equalTo: pulseContainer.leadingAnchor),
            pulseBox.trailingAnchor.constraint(equalTo: pulseContainer.trailingAnchor),
            pulseBox.bottomAnchor.constraint(equalTo: pulseContainer.bottomAnchor),
            
            pulseTxt.topAnchor.constraint(equalTo: pulseBox.topAnchor),
            pulseTxt.bottomAnchor.constraint(equalTo: pulseBox.bottomAnchor),
            pulseTxt.leadingAnchor.constraint(equalTo: pulseBox.leadingAnchor),
            pulseTxt.trailingAnchor.constraint(equalTo: pulseBox.trailingAnchor)
        ])
        rightCol.addArrangedSubview(pulseContainer)
        
        // Blood sugar
        let sugarContainer = UIView()
        bloodSugarLbl = UILabel()
        bloodSugarLbl.text = "Blood sugar"
        bloodSugarLbl.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        bloodSugarLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        bloodSugarLbl.translatesAutoresizingMaskIntoConstraints = false
        sugarContainer.addSubview(bloodSugarLbl)
        
        let sugarBox = createInputFieldContainer(height: 44)
        sugarContainer.addSubview(sugarBox)
        
        let sugarRow = UIStackView()
        sugarRow.axis = .horizontal
        sugarRow.distribution = .fillEqually
        sugarRow.spacing = 4
        sugarRow.translatesAutoresizingMaskIntoConstraints = false
        sugarBox.addSubview(sugarRow)
        
        bloodSugar1 = InsetPaddedTextField()
        bloodSugar1.placeholder = "—"
        bloodSugar1.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        bloodSugar1.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        bloodSugar1.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        bloodSugar1.keyboardType = .decimalPad
        bloodSugar1.isUserInteractionEnabled = true
        bloodSugar1.translatesAutoresizingMaskIntoConstraints = false
        sugarRow.addArrangedSubview(bloodSugar1)
        
        bloodSugar2 = InsetPaddedTextField()
        bloodSugar2.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        bloodSugar2.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        bloodSugar2.isHidden = true
        bloodSugar2.translatesAutoresizingMaskIntoConstraints = false
        sugarRow.addArrangedSubview(bloodSugar2)
        
        sugar1Button = UIButton(type: .custom)
        sugar1Button.isHidden = true
        sugarBox.addSubview(sugar1Button)
        
        sugar2Button = UIButton(type: .custom)
        sugar2Button.isHidden = true
        sugarBox.addSubview(sugar2Button)
        
        NSLayoutConstraint.activate([
            bloodSugarLbl.topAnchor.constraint(equalTo: sugarContainer.topAnchor),
            bloodSugarLbl.leadingAnchor.constraint(equalTo: sugarContainer.leadingAnchor),
            
            sugarBox.topAnchor.constraint(equalTo: bloodSugarLbl.bottomAnchor, constant: 4),
            sugarBox.leadingAnchor.constraint(equalTo: sugarContainer.leadingAnchor),
            sugarBox.trailingAnchor.constraint(equalTo: sugarContainer.trailingAnchor),
            sugarBox.bottomAnchor.constraint(equalTo: sugarContainer.bottomAnchor),
            
            sugarRow.topAnchor.constraint(equalTo: sugarBox.topAnchor),
            sugarRow.bottomAnchor.constraint(equalTo: sugarBox.bottomAnchor),
            sugarRow.leadingAnchor.constraint(equalTo: sugarBox.leadingAnchor, constant: 6),
            sugarRow.trailingAnchor.constraint(equalTo: sugarBox.trailingAnchor, constant: -6),
            
            bloodSugar1.topAnchor.constraint(equalTo: sugarBox.topAnchor),
            bloodSugar1.bottomAnchor.constraint(equalTo: sugarBox.bottomAnchor),
            bloodSugar1.leadingAnchor.constraint(equalTo: sugarBox.leadingAnchor),
            bloodSugar1.trailingAnchor.constraint(equalTo: sugarBox.trailingAnchor)
        ])
        rightCol.addArrangedSubview(sugarContainer)
        
        NSLayoutConstraint.activate([
            genralCardStack.topAnchor.constraint(equalTo: genralExaminationView.topAnchor, constant: 16),
            genralCardStack.bottomAnchor.constraint(equalTo: genralExaminationView.bottomAnchor, constant: -16),
            genralCardStack.leadingAnchor.constraint(equalTo: genralExaminationView.leadingAnchor, constant: 14),
            genralCardStack.trailingAnchor.constraint(equalTo: genralExaminationView.trailingAnchor, constant: -14)
        ])
        
        // --- Card 6: Provisional Diagnosis ---
        provisonDiagnos = createCardView()
        contentStackView.addArrangedSubview(provisonDiagnos)
        
        let provTitle = UILabel()
        provTitle.text = "Provisional Diagnosis"
        provTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        provTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        provTitle.translatesAutoresizingMaskIntoConstraints = false
        provisonDiagnos.addSubview(provTitle)
        
        let provBox = createInputFieldContainer(height: 70)
        provisonDiagnos.addSubview(provBox)
        
        provisionTxt = MultilineInputTextField()
        provisionTxt.placeholder = "Provisional Diagnosis"
        provisionTxt.translatesAutoresizingMaskIntoConstraints = false
        provBox.addSubview(provisionTxt)
        
        NSLayoutConstraint.activate([
            provTitle.topAnchor.constraint(equalTo: provisonDiagnos.topAnchor, constant: 14),
            provTitle.leadingAnchor.constraint(equalTo: provisonDiagnos.leadingAnchor, constant: 14),
            provTitle.trailingAnchor.constraint(equalTo: provisonDiagnos.trailingAnchor, constant: -14),
            
            provBox.topAnchor.constraint(equalTo: provTitle.bottomAnchor, constant: 10),
            provBox.leadingAnchor.constraint(equalTo: provisonDiagnos.leadingAnchor, constant: 14),
            provBox.trailingAnchor.constraint(equalTo: provisonDiagnos.trailingAnchor, constant: -14),
            provBox.bottomAnchor.constraint(equalTo: provisonDiagnos.bottomAnchor, constant: -14),
            
            provisionTxt.topAnchor.constraint(equalTo: provBox.topAnchor),
            provisionTxt.bottomAnchor.constraint(equalTo: provBox.bottomAnchor),
            provisionTxt.leadingAnchor.constraint(equalTo: provBox.leadingAnchor),
            provisionTxt.trailingAnchor.constraint(equalTo: provBox.trailingAnchor)
        ])
        
        // --- Card 7: Investigation (investigationView) ---
        investigationView = createCardView()
        contentStackView.addArrangedSubview(investigationView)
        
        let investCardStack = UIStackView()
        investCardStack.axis = .vertical
        investCardStack.spacing = 12
        investCardStack.translatesAutoresizingMaskIntoConstraints = false
        investigationView.addSubview(investCardStack)
        
        let investHeaderRow = UIStackView()
        investHeaderRow.axis = .horizontal
        investHeaderRow.alignment = .center
        investHeaderRow.distribution = .equalSpacing
        investHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        investCardStack.addArrangedSubview(investHeaderRow)
        
        investigationLbl = UILabel()
        investigationLbl.text = "Investigation"
        investigationLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        investigationLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        investHeaderRow.addArrangedSubview(investigationLbl)
        
        investigationToggle = UISwitch()
        investigationToggle.onTintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        investigationToggle.isOn = true
        investigationToggle.addTarget(self, action: #selector(investigationToggleTapped(_:)), for: .valueChanged)
        investHeaderRow.addArrangedSubview(investigationToggle)
        
        investigationContentStack.axis = .vertical
        investigationContentStack.spacing = 10
        investigationContentStack.translatesAutoresizingMaskIntoConstraints = false
        investCardStack.addArrangedSubview(investigationContentStack)
        
        // Chips ScrollView
        chipsScrollView.showsHorizontalScrollIndicator = false
        chipsScrollView.translatesAutoresizingMaskIntoConstraints = false
        investigationContentStack.addArrangedSubview(chipsScrollView)
        
        chipsStackView.axis = .horizontal
        chipsStackView.spacing = 8
        chipsStackView.alignment = .center
        chipsStackView.translatesAutoresizingMaskIntoConstraints = false
        chipsScrollView.addSubview(chipsStackView)
        
        let chipsHeight = chipsScrollView.heightAnchor.constraint(equalToConstant: 32)
        chipsHeight.priority = UILayoutPriority(999)
        chipsHeight.isActive = true
        
        NSLayoutConstraint.activate([
            chipsStackView.topAnchor.constraint(equalTo: chipsScrollView.topAnchor),
            chipsStackView.bottomAnchor.constraint(equalTo: chipsScrollView.bottomAnchor),
            chipsStackView.leadingAnchor.constraint(equalTo: chipsScrollView.leadingAnchor),
            chipsStackView.trailingAnchor.constraint(equalTo: chipsScrollView.trailingAnchor),
            chipsStackView.heightAnchor.constraint(equalTo: chipsScrollView.heightAnchor)
        ])
        
        // Investigation Search Container
        let investBox = createInputFieldContainer(height: 44)
        investigationContentStack.addArrangedSubview(investBox)
        
        investigationTxt = InsetPaddedTextField()
        investigationTxt.placeholder = "Search and add an investigation..."
        investigationTxt.font = UIFont(name: "Poppins-Regular", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5)
        investigationTxt.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        investigationTxt.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        investigationTxt.isUserInteractionEnabled = true
        investigationTxt.translatesAutoresizingMaskIntoConstraints = false
        investigationTxt.addTarget(self, action: #selector(investigationTextChanged), for: .editingChanged)
        investBox.addSubview(investigationTxt)
        
        investigationDropDown = UIImageView()
        investigationDropDown.contentMode = .scaleAspectFit
        if let dropImg = UIImage(systemName: "chevron.down") {
            investigationDropDown.image = dropImg
            investigationDropDown.tintColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        } else if let dropImg = UIImage(named: "down_arrow") {
            investigationDropDown.image = dropImg
        }
        investigationDropDown.translatesAutoresizingMaskIntoConstraints = false
        investBox.addSubview(investigationDropDown)
        
        xrayButton = UIButton(type: .custom)
        xrayButton.translatesAutoresizingMaskIntoConstraints = false
        xrayButton.addTarget(self, action: #selector(xrayButtonTapped(_:)), for: .touchUpInside)
        investBox.addSubview(xrayButton)
        
        NSLayoutConstraint.activate([
            investCardStack.topAnchor.constraint(equalTo: investigationView.topAnchor, constant: 16),
            investCardStack.bottomAnchor.constraint(equalTo: investigationView.bottomAnchor, constant: -16),
            investCardStack.leadingAnchor.constraint(equalTo: investigationView.leadingAnchor, constant: 14),
            investCardStack.trailingAnchor.constraint(equalTo: investigationView.trailingAnchor, constant: -14),
            
            investigationTxt.topAnchor.constraint(equalTo: investBox.topAnchor),
            investigationTxt.bottomAnchor.constraint(equalTo: investBox.bottomAnchor),
            investigationTxt.leadingAnchor.constraint(equalTo: investBox.leadingAnchor),
            investigationTxt.trailingAnchor.constraint(equalTo: xrayButton.leadingAnchor),
            
            investigationDropDown.trailingAnchor.constraint(equalTo: investBox.trailingAnchor, constant: -14),
            investigationDropDown.centerYAnchor.constraint(equalTo: investBox.centerYAnchor),
            investigationDropDown.widthAnchor.constraint(equalToConstant: 14),
            investigationDropDown.heightAnchor.constraint(equalToConstant: 14),
            
            xrayButton.topAnchor.constraint(equalTo: investBox.topAnchor),
            xrayButton.bottomAnchor.constraint(equalTo: investBox.bottomAnchor),
            xrayButton.trailingAnchor.constraint(equalTo: investBox.trailingAnchor),
            xrayButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // --- Card 8: Medicine (medicineView) ---
        medicineView = createCardView()
        contentStackView.addArrangedSubview(medicineView)
        
        let medCardStack = UIStackView()
        medCardStack.axis = .vertical
        medCardStack.spacing = 14
        medCardStack.translatesAutoresizingMaskIntoConstraints = false
        medicineView.addSubview(medCardStack)
        
        let medHeaderRow = UIStackView()
        medHeaderRow.axis = .horizontal
        medHeaderRow.alignment = .center
        medHeaderRow.distribution = .equalSpacing
        medHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        medCardStack.addArrangedSubview(medHeaderRow)
        
        medicineLbl = UILabel()
        medicineLbl.text = "Medicine"
        medicineLbl.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        medicineLbl.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        medHeaderRow.addArrangedSubview(medicineLbl)
        
        medicinceTogle = UISwitch()
        medicinceTogle.onTintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        medicinceTogle.isOn = true
        medicinceTogle.addTarget(self, action: #selector(medicineToggle(_:)), for: .valueChanged)
        medHeaderRow.addArrangedSubview(medicinceTogle)
        
        medicineContentStack.axis = .vertical
        medicineContentStack.spacing = 12
        medicineContentStack.translatesAutoresizingMaskIntoConstraints = false
        medCardStack.addArrangedSubview(medicineContentStack)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        medicineContentStack.addArrangedSubview(tableView)
        
        tableHightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHightConstraint.priority = UILayoutPriority(999)
        tableHightConstraint.isActive = true
        
        addMedicineView = UIButton(type: .system)
        addMedicineView.setTitle("+ Add Medicine", for: .normal)
        addMedicineView.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        addMedicineView.setTitleColor(.white, for: .normal)
        addMedicineView.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0) // #1976D2
        addMedicineView.layer.cornerRadius = 8
        addMedicineView.clipsToBounds = true
        addMedicineView.translatesAutoresizingMaskIntoConstraints = false
        let addMedHeight = addMedicineView.heightAnchor.constraint(equalToConstant: 44)
        addMedHeight.priority = UILayoutPriority(999)
        addMedHeight.isActive = true
        addMedicineView.addTarget(self, action: #selector(addMedicineTapped(_:)), for: .touchUpInside)
        medicineContentStack.addArrangedSubview(addMedicineView)
        
        NSLayoutConstraint.activate([
            medCardStack.topAnchor.constraint(equalTo: medicineView.topAnchor, constant: 16),
            medCardStack.bottomAnchor.constraint(equalTo: medicineView.bottomAnchor, constant: -16),
            medCardStack.leadingAnchor.constraint(equalTo: medicineView.leadingAnchor, constant: 14),
            medCardStack.trailingAnchor.constraint(equalTo: medicineView.trailingAnchor, constant: -14)
        ])
        
        // --- Card 9: General Advice (genralView) ---
        genralView = createCardView()
        contentStackView.addArrangedSubview(genralView)
        
        let genralTitle = UILabel()
        genralTitle.text = "General Advice"
        genralTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        genralTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        genralTitle.translatesAutoresizingMaskIntoConstraints = false
        genralView.addSubview(genralTitle)
        
        formatAdviceBtn.setTitle(" ≡ Format", for: .normal)
        formatAdviceBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5, weight: .medium)
        formatAdviceBtn.setTitleColor(UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0), for: .normal)
        formatAdviceBtn.backgroundColor = .white
        formatAdviceBtn.layer.cornerRadius = 8
        formatAdviceBtn.layer.borderWidth = 1.5
        formatAdviceBtn.layer.borderColor = UIColor(red: 29/255, green: 112/255, blue: 184/255, alpha: 1.0).cgColor
        formatAdviceBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        formatAdviceBtn.translatesAutoresizingMaskIntoConstraints = false
        formatAdviceBtn.addTarget(self, action: #selector(formatGeneralAdviceTapped), for: .touchUpInside)
        genralView.addSubview(formatAdviceBtn)
        
        let genralBox = createInputFieldContainer(height: 96)
        genralView.addSubview(genralBox)
        
        genralTxt = MultilineInputTextField()
        genralTxt.placeholder = "General Advice"
        genralTxt.translatesAutoresizingMaskIntoConstraints = false
        genralBox.addSubview(genralTxt)
        
        NSLayoutConstraint.activate([
            genralTitle.leadingAnchor.constraint(equalTo: genralView.leadingAnchor, constant: 14),
            genralTitle.topAnchor.constraint(equalTo: genralView.topAnchor, constant: 14),
            
            formatAdviceBtn.trailingAnchor.constraint(equalTo: genralView.trailingAnchor, constant: -14),
            formatAdviceBtn.centerYAnchor.constraint(equalTo: genralTitle.centerYAnchor),
            formatAdviceBtn.heightAnchor.constraint(equalToConstant: 30),
            
            genralBox.topAnchor.constraint(equalTo: formatAdviceBtn.bottomAnchor, constant: 10),
            genralBox.leadingAnchor.constraint(equalTo: genralView.leadingAnchor, constant: 14),
            genralBox.trailingAnchor.constraint(equalTo: genralView.trailingAnchor, constant: -14),
            genralBox.bottomAnchor.constraint(equalTo: genralView.bottomAnchor, constant: -14),
            
            genralTxt.topAnchor.constraint(equalTo: genralBox.topAnchor),
            genralTxt.bottomAnchor.constraint(equalTo: genralBox.bottomAnchor),
            genralTxt.leadingAnchor.constraint(equalTo: genralBox.leadingAnchor),
            genralTxt.trailingAnchor.constraint(equalTo: genralBox.trailingAnchor)
        ])
        
        // --- Card 10: Follow Up (followUpView) ---
        followUpView = createCardView()
        contentStackView.addArrangedSubview(followUpView)
        
        let followUpCardStack = UIStackView()
        followUpCardStack.axis = .vertical
        followUpCardStack.spacing = 14
        followUpCardStack.translatesAutoresizingMaskIntoConstraints = false
        followUpView.addSubview(followUpCardStack)
        
        let followUpHeaderRow = UIStackView()
        followUpHeaderRow.axis = .horizontal
        followUpHeaderRow.alignment = .center
        followUpHeaderRow.distribution = .equalSpacing
        followUpHeaderRow.translatesAutoresizingMaskIntoConstraints = false
        followUpCardStack.addArrangedSubview(followUpHeaderRow)
        
        followUpTitle = UILabel()
        followUpTitle.text = "Follow Up"
        followUpTitle.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        followUpTitle.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        followUpHeaderRow.addArrangedSubview(followUpTitle)
        
        switchButton = UISwitch()
        switchButton.onTintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        switchButton.isOn = true
        switchButton.addTarget(self, action: #selector(followUpSwitch(_:)), for: .valueChanged)
        followUpHeaderRow.addArrangedSubview(switchButton)
        
        followUpContentRow = UIView()
        followUpContentRow.translatesAutoresizingMaskIntoConstraints = false
        followUpCardStack.addArrangedSubview(followUpContentRow)
        
        let afterLbl = UILabel()
        afterLbl.text = "After"
        afterLbl.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        afterLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        afterLbl.translatesAutoresizingMaskIntoConstraints = false
        followUpContentRow.addSubview(afterLbl)
        
        let followUpDaysBox = createInputFieldContainer(height: 38)
        followUpDaysBox.translatesAutoresizingMaskIntoConstraints = false
        followUpContentRow.addSubview(followUpDaysBox)
        
        followUpDays = InsetPaddedTextField()
        followUpDays.placeholder = "7"
        followUpDays.textAlignment = .center
        followUpDays.keyboardType = .numberPad
        followUpDays.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        followUpDays.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        followUpDays.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
        followUpDays.isUserInteractionEnabled = true
        followUpDays.translatesAutoresizingMaskIntoConstraints = false
        followUpDaysBox.addSubview(followUpDays)
        
        let daysLbl = UILabel()
        daysLbl.text = "days"
        daysLbl.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        daysLbl.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        daysLbl.translatesAutoresizingMaskIntoConstraints = false
        followUpContentRow.addSubview(daysLbl)
        
        let rowHeight = followUpContentRow.heightAnchor.constraint(equalToConstant: 38)
        rowHeight.priority = UILayoutPriority(999)
        rowHeight.isActive = true
        
        NSLayoutConstraint.activate([
            followUpCardStack.topAnchor.constraint(equalTo: followUpView.topAnchor, constant: 16),
            followUpCardStack.bottomAnchor.constraint(equalTo: followUpView.bottomAnchor, constant: -16),
            followUpCardStack.leadingAnchor.constraint(equalTo: followUpView.leadingAnchor, constant: 14),
            followUpCardStack.trailingAnchor.constraint(equalTo: followUpView.trailingAnchor, constant: -14),
            
            afterLbl.leadingAnchor.constraint(equalTo: followUpContentRow.leadingAnchor),
            afterLbl.centerYAnchor.constraint(equalTo: followUpContentRow.centerYAnchor),
            
            followUpDaysBox.leadingAnchor.constraint(equalTo: afterLbl.trailingAnchor, constant: 10),
            followUpDaysBox.centerYAnchor.constraint(equalTo: followUpContentRow.centerYAnchor),
            followUpDaysBox.widthAnchor.constraint(equalToConstant: 64),
            followUpDaysBox.heightAnchor.constraint(equalToConstant: 38),
            
            followUpDays.topAnchor.constraint(equalTo: followUpDaysBox.topAnchor),
            followUpDays.bottomAnchor.constraint(equalTo: followUpDaysBox.bottomAnchor),
            followUpDays.leadingAnchor.constraint(equalTo: followUpDaysBox.leadingAnchor),
            followUpDays.trailingAnchor.constraint(equalTo: followUpDaysBox.trailingAnchor),
            
            daysLbl.leadingAnchor.constraint(equalTo: followUpDaysBox.trailingAnchor, constant: 10),
            daysLbl.centerYAnchor.constraint(equalTo: followUpContentRow.centerYAnchor)
        ])
        
        // Dummy constraints so legacy constraint references don't crash
        genralViewHeight = NSLayoutConstraint()
        investigationViewHeight = NSLayoutConstraint()
        medicineViewHeight = NSLayoutConstraint()
        prescriptionHeight = NSLayoutConstraint()
    }
    
    private func createCardView() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor // #E2E8F0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.03
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    private func createInputFieldContainer(height: CGFloat = 44) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0) // #F8FAFC
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor // #E2E8F0
        container.translatesAutoresizingMaskIntoConstraints = false
        let h = container.heightAnchor.constraint(equalToConstant: height)
        h.priority = UILayoutPriority(999)
        h.isActive = true
        return container
    }
}

extension Date {
    static func getCurrentDateWithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

struct PrescriptionDetail {
    static var pasthistory: String?
    static var cheifComaplain: String?
    static var temprature: String?
    static var bloodPresure1: String?
    static var bloodPresure2: String?
    static var pluse: String?
    static var bloodsugar1: String?
    static var bloodsugar2: String?
    static var provisonalDiagnosis: String?
    static var investigationGuide: String?
    static var genralAdvice: String?
    static var followUP: String?
    static var genralExamToggle: UISwitch?
    static var followUpToggle: Bool?
    static var medicineData: [Medicine]?
}
