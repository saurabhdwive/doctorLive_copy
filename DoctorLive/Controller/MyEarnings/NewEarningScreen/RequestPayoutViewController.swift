 

import Foundation
import UIKit
import PromiseKit


// MARK: - Request Payout View Controller

final class RequestPayoutViewController:
    UIViewController {

    private let vm: EarningViewModel

    private var mode = 0

    private var selecteddd = Set<Int>()

    var onSubmit: ((Double) -> Void)?

    private let tableView = IntrinsicTableView()

    private let selectButton =
        UIButton(type: .system)

    private let wholeButton =
        UIButton(type: .system)

    private let amountLabel = UILabel()
    private let dataNotFoundLabel = UILabel()

    private let wholeBalanceCard = UIView()
    private let wholeBalanceLabel = UILabel()
    
    private let summary = UIView()

    init(viewModel: EarningViewModel) {

        self.vm = viewModel

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = Theme.card

        setupUI()
        updateUI()
    }

    private func setupUI() {

        let scrollView = UIScrollView()

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let bottomStack = UIStackView()
        bottomStack.axis = .vertical
        bottomStack.spacing = 16
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack)

        NSLayoutConstraint.activate([
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: bottomStack.topAnchor,
                constant: -10
            )
        ])

        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 0

        scrollView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 18
            ),

            stack.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                constant: 18
            ),

            stack.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                constant: -18
            ),

            stack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -26
            )
        ])

        let title = UILabel()

        title.text = "Request Payout"

        title.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )

        title.textColor = Theme.ink

        stack.addArrangedSubview(title)

        let subtitle = UILabel()

        subtitle.text =
            "Select specific consultations, or request everything currently due."

        subtitle.font = .systemFont(
            ofSize: 13
        )

        subtitle.textColor = Theme.ink3
        subtitle.numberOfLines = 0

        stack.setCustomSpacing(
            4,
            after: title
        )

        stack.addArrangedSubview(subtitle)

        let segmentStack =
            UIStackView(
                arrangedSubviews: [
                    selectButton,
                    wholeButton
                ]
            )

        segmentStack.axis = .horizontal
        segmentStack.spacing = 8
        segmentStack.distribution = .fillEqually

        selectButton.setTitle(
            "Select Consultations",
            for: .normal
        )

        wholeButton.setTitle(
            "Whole Balance",
            for: .normal
        )

        selectButton.addTarget(
            self,
            action: #selector(selectMode),
            for: .touchUpInside
        )

        wholeButton.addTarget(
            self,
            action: #selector(wholeMode),
            for: .touchUpInside
        )

        segmentStack.heightAnchor.constraint(
            equalToConstant: 42
        ).isActive = true

        stack.setCustomSpacing(
            14,
            after: subtitle
        )

        stack.addArrangedSubview(
            segmentStack
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(
            RequestConsultationCell.self,
            forCellReuseIdentifier:
                RequestConsultationCell.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self

        tableView.isScrollEnabled = false

        stack.setCustomSpacing(
            10,
            after: segmentStack
        )

        stack.addArrangedSubview(
            tableView
        )

        dataNotFoundLabel.text = "No Due Consultation"
        dataNotFoundLabel.textAlignment = .center
        dataNotFoundLabel.textColor = .gray
        dataNotFoundLabel.isHidden = true
        dataNotFoundLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stack.addArrangedSubview(dataNotFoundLabel)
        
        wholeBalanceCard.backgroundColor = Theme.line2 // light gray background
        wholeBalanceCard.layer.cornerRadius = 10
        wholeBalanceCard.isHidden = true
        wholeBalanceLabel.numberOfLines = 0
        
        wholeBalanceCard.addSubview(wholeBalanceLabel)
        wholeBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wholeBalanceLabel.topAnchor.constraint(equalTo: wholeBalanceCard.topAnchor, constant: 16),
            wholeBalanceLabel.bottomAnchor.constraint(equalTo: wholeBalanceCard.bottomAnchor, constant: -16),
            wholeBalanceLabel.leadingAnchor.constraint(equalTo: wholeBalanceCard.leadingAnchor, constant: 16),
            wholeBalanceLabel.trailingAnchor.constraint(equalTo: wholeBalanceCard.trailingAnchor, constant: -16)
        ])
        
        stack.addArrangedSubview(wholeBalanceCard)

        summary.backgroundColor = Theme.accentLight
        summary.layer.cornerRadius = 10

        let requesting = UILabel()

        requesting.text = "Requesting"
        requesting.font = .systemFont(
            ofSize: 13.5
        )

        requesting.textColor = Theme.ink2

        amountLabel.font = .systemFont(
            ofSize: 15,
            weight: .heavy
        )

        amountLabel.textColor =
            Theme.accentDark

        summary.addSubview(requesting)
        summary.addSubview(amountLabel)

        requesting.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            requesting.topAnchor.constraint(
                equalTo: summary.topAnchor,
                constant: 13
            ),

            requesting.leadingAnchor.constraint(
                equalTo: summary.leadingAnchor,
                constant: 13
            ),

            requesting.bottomAnchor.constraint(
                equalTo: summary.bottomAnchor,
                constant: -13
            ),

            amountLabel.centerYAnchor.constraint(
                equalTo: requesting.centerYAnchor
            ),

            amountLabel.trailingAnchor.constraint(
                equalTo: summary.trailingAnchor,
                constant: -13
            )
        ])

        summary.heightAnchor.constraint(
            equalToConstant: 46
        ).isActive = true

        bottomStack.addArrangedSubview(summary)

        let submit =
            UIButton(type: .system)

        submit.setTitle(
            "Submit Request",
            for: .normal
        )

        submit.setTitleColor(
            .white,
            for: .normal
        )

        submit.titleLabel?.font =
            .systemFont(
                ofSize: 15,
                weight: .bold
            )

        submit.backgroundColor =  UIColor(named: "ButtonBlueColor") ?? Theme.accent
//            Theme.accent

        submit.layer.cornerRadius = 12

        submit.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true

        submit.addTarget(
            self,
            action: #selector(submitTapped),
            for: .touchUpInside
        )

        bottomStack.setCustomSpacing(
            16,
            after: summary
        )

        bottomStack.addArrangedSubview(submit)

        let cancel =
            UIButton(type: .system)

        cancel.setTitle(
            "Cancel",
            for: .normal
        )

        cancel.setTitleColor(
            Theme.ink2,
            for: .normal
        )

        cancel.titleLabel?.font =
            .systemFont(
                ofSize: 14.5,
                weight: .semibold
            )

        cancel.layer.borderWidth = 1
        cancel.layer.borderColor =
            Theme.line.cgColor

        cancel.layer.cornerRadius = 12

        cancel.heightAnchor.constraint(
            equalToConstant: 46
        ).isActive = true

        cancel.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside
        )

        bottomStack.setCustomSpacing(
            12,
            after: submit
        )

        bottomStack.addArrangedSubview(cancel)
    }

    private var selectedTotal: Double {

        if mode == 1 {

            return vm.unpaidConsultations.reduce(0) {
                $0 + $1.doctorFees
            }
        }

        return vm.unpaidConsultations
            .filter {
                selecteddd.contains($0.id)
            }
            .reduce(0) {
                $0 + $1.doctorFees
            }
    }

    private func updateUI() {

        amountLabel.text =
        "৳\(fmt(Float(selectedTotal)))"

        configureModeButton(
            selectButton,
            selected: mode == 0
        )

        configureModeButton(
            wholeButton,
            selected: mode == 1
        )

        let isUnpaidEmpty = vm.unpaidConsultations.isEmpty

        if mode == 1 {
            wholeBalanceCard.isHidden = false
            tableView.isHidden = true
            dataNotFoundLabel.isHidden = true
            
            let count = vm.unpaidConsultations.count
            let total = vm.dueTotal
            let text = "Requesting your whole current unpaid balance — \(count) consultation(s), ৳\(fmt(Float(selectedTotal))) total. Admin will see this as one request covering all of them."
            
            let attrStr = NSMutableAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: Theme.ink2])
            
            if let range = text.range(of: "whole current unpaid balance") {
                let nsRange = NSRange(range, in: text)
                attrStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
                attrStr.addAttribute(.foregroundColor, value: Theme.ink, range: nsRange)
            }
            wholeBalanceLabel.attributedText = attrStr
        } else {
            wholeBalanceCard.isHidden = true
            tableView.isHidden = isUnpaidEmpty
            dataNotFoundLabel.isHidden = !isUnpaidEmpty
        }

        tableView.reloadData()

        view.layoutIfNeeded()
    }

    private func configureModeButton(
        _ button: UIButton,
        selected: Bool
    ) {

        button.backgroundColor = Theme.card
//            selected
//            ?  Theme.accentLight
//            : Theme.card

        button.setTitleColor(
            selected
            ?  UIColor(named: "ButtonBlueColor") ?? Theme.accent
            : Theme.ink2,
            for: .normal
        )
        button.titleLabel?.font =  .systemFont(
            ofSize: 14,
            weight: .semibold
        )

        button.layer.borderWidth = 1

        button.layer.borderColor =
            selected
        ? UIColor(named: "ButtonBlueColor")?.cgColor ?? Theme.accent.cgColor
            : Theme.line.cgColor

        button.layer.cornerRadius = 9
    }

    

    @objc private func selectMode() {

        mode = 0
        selecteddd.removeAll()

        updateUI()
    }

    @objc private func wholeMode() {

        mode = 1
        selecteddd.removeAll()

        updateUI()
    }

    @objc private func submitTapped() {

        guard selectedTotal > 0 else {
            if mode == 0{
                showToast(message: "Please select consultation")
            }else{
                showToast(message: "Amount must be greater than 0")
            }
            return
        }

        var param: [String: Any] = [:]
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken),
              let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        
        param["token"] = token
        if mode == 1{
            param["withdraw_amount"] = Int(selectedTotal)
        }
        param["language_type"] = code
        param["bank_id"] = UserDefaults.standard.string(forKey: Constants.bankId)
        
        if mode == 0 {
            var patientsArray: [[String: String]] = []
            for id in selecteddd {
                if let cons = vm.consultations.first(where: { $0.id == id }) {
                    var arr = [
                        "patient_id": "\(cons.patient_id ?? "")",
                        "transaction_id": "\(cons.id)"
                    ]
                    if mode == 0 {
                        arr["withdraw_amount"] = "\(Int(cons.doctorFees))"
                    }
                    patientsArray.append(arr)
                }
            }
            if let theJSONData = try? JSONSerialization.data(withJSONObject: patientsArray, options: []),
               let theJSONText = String(data: theJSONData, encoding: .ascii) {
                param["patients"] = theJSONText
            }
        }
        withdrawRequestApi(param: param)
    }
    private func withdrawRequestApi(param: [String: Any]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.widhrawAmount(parameters: param, header: "DeviceToken")
        }.done { (model: WidhrawRequestModel) in
            self.myWidhrawResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                AppToast.showMessage1(message: error.localizedDescription, self)
                LoaderController.sharedInstance.removeLoader()
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    private func myWidhrawResponse(model:WidhrawRequestModel){
        if model.status?.lowercased() == "success" || model.status?.lowercased() == "true"{
            self.onSubmit?(self.selectedTotal)
            self.dismiss(animated: true)
        } else {
            let errorMsg = model.message ?? "Something went wrong"
            AppToast.showMessage1(message: errorMsg, self)
        }
    }

    @objc private func cancelTapped() {

        dismiss(
            animated: true
        )
    }
}


// MARK: - Request Payout Table

extension RequestPayoutViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        vm.unpaidConsultations.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    RequestConsultationCell.identifier,
                for: indexPath
            ) as! RequestConsultationCell

        let consultation =
            vm.unpaidConsultations[indexPath.row]

        cell.configure(
            consultation: consultation,
            checked:
                selecteddd.contains(
                    consultation.id
                )
        )

        cell.onCheck = {
            [weak self] in

            guard let self else {
                return
            }

            let id = consultation.id

            if self.selecteddd.contains(id) {

                self.selecteddd.remove(id)

            } else {

                self.selecteddd.insert(id)
            }

            self.updateUI()
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        guard mode == 0 else {
            return
        }

        let consultation =
            vm.unpaidConsultations[indexPath.row]

        if selecteddd.contains(
            consultation.id
        ) {

            selecteddd.remove(
                consultation.id
            )

        } else {

            selecteddd.insert(
                consultation.id
            )
        }

        updateUI()
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        58
    }
}


// MARK: - Request Consultation Cell

final class RequestConsultationCell:
    UITableViewCell {

    static let identifier =
        "RequestConsultationCell"

    private let checkButton =
        UIButton(type: .system)

    private let patientLabel = UILabel()
    private let bookingLabel = UILabel()
    private let amountLabel = UILabel()

    var consultation: Consultation?

    var isChecked = false {
        didSet {
            updateCheck()
        }
    }

    var onCheck: (() -> Void)?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    private func setupUI() {

        backgroundColor = .clear
        selectionStyle = .none

        checkButton.addTarget(
            self,
            action: #selector(checkTapped),
            for: .touchUpInside
        )

        patientLabel.font =
            .systemFont(
                ofSize: 14,
                weight: .semibold
            )

        patientLabel.textColor = Theme.ink

        bookingLabel.font =
            .systemFont(
                ofSize: 13
            )

        bookingLabel.textColor = Theme.ink3

        amountLabel.font =
            .systemFont(
                ofSize: 15,
                weight: .bold
            )

        amountLabel.textColor = Theme.ink

        contentView.addSubview(checkButton)
        contentView.addSubview(patientLabel)
        contentView.addSubview(bookingLabel)
        contentView.addSubview(amountLabel)

        checkButton.translatesAutoresizingMaskIntoConstraints = false
        patientLabel.translatesAutoresizingMaskIntoConstraints = false
        bookingLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            checkButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            checkButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            checkButton.widthAnchor.constraint(
                equalToConstant: 28
            ),

            checkButton.heightAnchor.constraint(
                equalToConstant: 28
            ),

            patientLabel.leadingAnchor.constraint(
                equalTo: checkButton.trailingAnchor,
                constant: 4
            ),

            patientLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            patientLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: amountLabel.leadingAnchor,
                constant: -8
            ),

            bookingLabel.leadingAnchor.constraint(
                equalTo: patientLabel.leadingAnchor
            ),

            bookingLabel.topAnchor.constraint(
                equalTo: patientLabel.bottomAnchor,
                constant: 2
            ),

            bookingLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),

            amountLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            amountLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            )
        ])

        updateCheck()
    }

    func configure(
        consultation: Consultation,
        checked: Bool
    ) {

        self.consultation = consultation
        self.isChecked = checked

        patientLabel.text =
            consultation.patient

        bookingLabel.text =
            "#\(consultation.booking) · \(consultation.date)"

        amountLabel.text =
        "৳\(fmt(Float(consultation.doctorFees)))"
    }

    private func updateCheck() {

        let imageName =
            isChecked
            ? "checkmark.square.fill"
            : "square"

        checkButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )

        checkButton.tintColor =
            isChecked
            ? UIColor(named: "ButtonBlueColor") ?? Theme.accent
            : Theme.ink3
    }

    @objc private func checkTapped() {

        onCheck?()
    }
}

final class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
