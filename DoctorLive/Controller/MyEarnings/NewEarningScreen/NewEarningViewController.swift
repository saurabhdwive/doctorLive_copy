
 import UIKit
import PromiseKit

// MARK: - Models

enum ConsultationStatus: String {
    case unpaid
    case paid
    case voided
    case pending
}

struct Consultation {
    let id: Int
    let booking: String
    let patient: String
    let date: String
    let fees: Double
    let paidFees: Double
    let doctorFees: Double
    let status: ConsultationStatus
    var payoutId: String?
    var transactionId: String?
    var voidedFrom: String?
    var voidReason: String?
    var voidedDate: String?
    var clawback: Bool
    var note: String?
    let patient_id:String?

    init(
        id: Int,
        booking: String,
        patient: String,
        date: String,
        fees: Double,
        paidFees: Double,
        doctorFees: Double,
        status: ConsultationStatus,
        payoutId: String? = nil,
        transactionId: String? = nil,
        voidedFrom: String? = nil,
        voidReason: String? = nil,
        voidedDate: String? = nil,
        clawback: Bool = false,
        note: String? = nil,
        patient_id:String? = nil
    ) {
        self.id = id
        self.booking = booking
        self.patient = patient
        self.date = date
        self.fees = fees
        self.paidFees = paidFees
        self.doctorFees = doctorFees
        self.status = status
        self.payoutId = payoutId
        self.transactionId = transactionId
        self.voidedFrom = voidedFrom
        self.voidReason = voidReason
        self.voidedDate = voidedDate
        self.clawback = clawback
        self.note = note
        self.patient_id = patient_id
    }
}

struct Payout {
    let id: String
    let date: String
    let amount: Double
    let method: String
    let items: [Int]
    var note: String?
}

// MARK: - Theme

enum Theme {

    static let red = UIColor(hex: 0xE11D2E)
    static let redDark = UIColor(hex: 0xB71424)

    static let accent = UIColor(hex: 0x3B6EF0)
    static let accentDark = UIColor(hex: 0x2952C4)
    static let accentLight = UIColor(hex: 0xEAF0FE)

    static let ink = UIColor(hex: 0x1B2430)
    static let ink2 = UIColor(hex: 0x4B5563)
    static let ink3 = UIColor(hex: 0x8A93A3)

    static let line = UIColor(hex: 0xE6E9EF)
    static let line2 = UIColor(hex: 0xEEF1F5)

    static let bg = UIColor(hex: 0xF6F7FA)
    static let card = UIColor.white

    static let success = UIColor(hex: 0x1C8A5A)
    static let successBg = UIColor(hex: 0xE7F6EF)

    static let warn = UIColor(hex: 0xB5720B)
    static let warnBg = UIColor(hex: 0xFDF3E1)

    static let danger = UIColor(hex: 0xC23A3A)
    static let dangerBg = UIColor(hex: 0xFCEBEB)
}


//// MARK: - UIColor Hex
//
//extension UIColor {
//
//    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
//
//        self.init(
//            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
//            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
//            blue: CGFloat(hex & 0xFF) / 255.0,
//            alpha: alpha
//        )
//    }
//    
//    convenience init(hex: UInt32, alpha: CGFloat) {
//           let red = CGFloat((hex & 0xFF0000) >> 16) / 256.0
//           let green = CGFloat((hex & 0xFF00) >> 8) / 256.0
//           let blue = CGFloat(hex & 0xFF) / 256.0
//
//           self.init(red: red, green: green, blue: blue, alpha: alpha)
//       }
//}
// MARK: - UIColor Hex

extension UIColor {

    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }

    convenience init(hex32: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex32 & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex32 & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex32 & 0xFF) / 255.0

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
}


// MARK: - Helpers

func fmt(_ value: Float) -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.maximumFractionDigits = 0

    return formatter.string(
        from: NSNumber(value: value)
    ) ?? "0"
}


// MARK: - ViewModel

final class EarningViewModel {

    var consultations: [Consultation] = []
    var payouts: [Payout] = []
    var payoutConsultations: [Consultation] = []
    var selectedTab: Int = 0
    var expandedPayoutIndex: Int?

//    var paidTotal: Double {
//
//        consultations
//            .filter { $0.status == .paid }
//            .reduce(0) {
//                $0 + $1.doctorFees
//            }
//    }
//
//    var dueTotal: Double {
//
//        consultations
//            .filter { $0.status == .unpaid }
//            .reduce(0) {
//                $0 + $1.doctorFees
//            }
//    }
//
//    var totalEarning: Double {
//
//        paidTotal + dueTotal
//    }
    var paidTotal: Float = 0
    var dueTotal: Float = 0
    var totalEarning: Float = 0
    
    var unpaidConsultations: [Consultation] {

        consultations.filter {
            $0.status == .unpaid
        }
    }

    func consultation(by id: Int) -> Consultation? {
        consultations.first {
            $0.id == id
        }
    }

    func togglePayout(_ index: Int) {

        if expandedPayoutIndex == index {
            expandedPayoutIndex = nil
        } else {
            expandedPayoutIndex = index
        }
    }
}


// MARK: - Base View

class RoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}


// MARK: - Status Badge

final class StatusBadgeView: UILabel {

    private let consultation: Consultation

    init(consultation: Consultation) {

        self.consultation = consultation

        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + padding.left + padding.right,
            height: size.height + padding.top + padding.bottom
        )
    }

    private func setup() {

        let result: (String, UIColor, UIColor)

        switch consultation.status {

        case .unpaid:
            result = ("Due", Theme.warn, Theme.warnBg)

        case .paid:
            result = ("Paid out", Theme.success, Theme.successBg)

        case .voided:

            let text =
                "Voided" +
                (consultation.voidedFrom == "paid"
                 ? " · refunded"
                 : "")

            result = (
                text,
                Theme.ink3,
                Theme.line2
            )

        case .pending:

            result = (
                "Paid out request",
//                Theme.accent,
                UIColor(named: "ButtonBlueColor") ?? .black,
                Theme.accentLight
            )
        }

        text = result.0
        textColor = result.1
        backgroundColor = result.2

        font = .systemFont(
            ofSize: 10.5,
            weight: .bold
        )

        textAlignment = .center

        layer.cornerRadius = 10
        clipsToBounds = true

        setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
    }
}


// MARK: - Consultation Cell

final class ConsultationCell: UITableViewCell {

    static let identifier = "ConsultationCell"

    var consultation: Consultation? {
        didSet {
            configure()
        }
    }

    private let patientLabel = UILabel()
    private let bookingLabel = UILabel()
    private let amountLabel = UILabel()
    private let badge = UIView()

    private let badgeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        backgroundColor = .clear
        selectionStyle = .none

        let card = UIView()
        card.backgroundColor = Theme.card
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 1
        card.layer.borderColor = Theme.line.cgColor

        contentView.addSubview(card)

        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            card.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),

            card.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            card.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            card.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            )
        ])

        patientLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )

        patientLabel.textColor = Theme.ink
        patientLabel.numberOfLines = 0

        bookingLabel.font = .systemFont(
            ofSize: 13.5
        )

        bookingLabel.textColor = Theme.ink3

        amountLabel.font = .systemFont(
            ofSize: 17,
            weight: .heavy
        )

        amountLabel.textColor = Theme.ink

        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true

        badge.addSubview(badgeLabel)

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        badgeLabel.font = .systemFont(
            ofSize: 12.5,
            weight: .bold
        )

        badgeLabel.textAlignment = .center

        NSLayoutConstraint.activate([

            badgeLabel.topAnchor.constraint(
                equalTo: badge.topAnchor,
                constant: 3
            ),

            badgeLabel.bottomAnchor.constraint(
                equalTo: badge.bottomAnchor,
                constant: -3
            ),

            badgeLabel.leadingAnchor.constraint(
                equalTo: badge.leadingAnchor,
                constant: 9
            ),

            badgeLabel.trailingAnchor.constraint(
                equalTo: badge.trailingAnchor,
                constant: -9
            )
        ])

        card.addSubview(patientLabel)
        card.addSubview(bookingLabel)
        card.addSubview(badge)
        card.addSubview(amountLabel)

        patientLabel.translatesAutoresizingMaskIntoConstraints = false
        bookingLabel.translatesAutoresizingMaskIntoConstraints = false
        badge.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            patientLabel.topAnchor.constraint(
                equalTo: card.topAnchor,
                constant: 13
            ),

            patientLabel.leadingAnchor.constraint(
                equalTo: card.leadingAnchor,
                constant: 13
            ),

            patientLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: amountLabel.leadingAnchor,
                constant: -8
            ),

            bookingLabel.topAnchor.constraint(
                equalTo: patientLabel.bottomAnchor,
                constant: 4
            ),

            bookingLabel.leadingAnchor.constraint(
                equalTo: patientLabel.leadingAnchor
            ),

            bookingLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: amountLabel.leadingAnchor,
                constant: -8
            ),

            badge.topAnchor.constraint(
                equalTo: bookingLabel.bottomAnchor,
                constant: 5
            ),

            badge.leadingAnchor.constraint(
                equalTo: patientLabel.leadingAnchor
            ),

            badge.bottomAnchor.constraint(
                equalTo: card.bottomAnchor,
                constant: -13
            ),

            amountLabel.topAnchor.constraint(
                equalTo: card.topAnchor,
                constant: 13
            ),

            amountLabel.trailingAnchor.constraint(
                equalTo: card.trailingAnchor,
                constant: -13
            )
        ])
    }

    private func configure() {

        guard let c = consultation else {
            return
        }

        patientLabel.text = c.patient

        bookingLabel.text =
            "Booking #\(c.booking) · \(c.date)"

        amountLabel.text =
        "৳\(fmt(Float(c.doctorFees)))"

        switch c.status {

        case .unpaid:

            badgeLabel.text = "Due"
            badgeLabel.textColor = Theme.warn
            badge.backgroundColor = Theme.warnBg

        case .paid:

            badgeLabel.text = "Paid out"
            badgeLabel.textColor = Theme.success
            badge.backgroundColor = Theme.successBg

        case .voided:

            badgeLabel.text =
                "Voided" +
                (c.voidedFrom == "paid"
                 ? " · refunded"
                 : "")

            badgeLabel.textColor = Theme.ink3
            badge.backgroundColor = Theme.line2

            amountLabel.textColor = Theme.ink3

            let attributed = NSAttributedString(
                string: "৳\(fmt(Float(c.doctorFees)))",
                attributes: [
                    .strikethroughStyle:
                        NSUnderlineStyle.single.rawValue,
                    .strikethroughColor:
                        Theme.ink3
                ]
            )

            amountLabel.attributedText = attributed

        case .pending:

            badgeLabel.text =
                "Paid out request"

            badgeLabel.textColor = UIColor(
                    red: 0.85,
                    green: 0.55,
                    blue: 0.05,
                    alpha: 1.0
                )
                badge.backgroundColor = UIColor(
                    red: 1.0,
                    green: 0.93,
                    blue: 0.78,
                    alpha: 1.0
                )
        }
    }
}


// MARK: - Payout Cell

final class PayoutCell: UITableViewCell {

    static let identifier = "PayoutCell"

    private let card = UIView()

    private let payoutIDLabel = UILabel()
    private let infoLabel = UILabel()
    private let amountLabel = UILabel()
    private let arrowImageView = UIImageView()

    private let detailsStack = UIStackView()

    private var isExpanded = false

    var payout: Payout?
    var consultations: [Consultation] = []

    var onTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        backgroundColor = .clear
        selectionStyle = .none

        card.backgroundColor = Theme.card
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 1
        card.layer.borderColor = Theme.line.cgColor

        contentView.addSubview(card)

        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            card.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),

            card.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            card.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            card.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            )
        ])

        payoutIDLabel.font = .systemFont(
            ofSize: 15,
            weight: .bold
        )

        payoutIDLabel.textColor = Theme.ink

        infoLabel.font = .systemFont(
            ofSize: 13
        )

        infoLabel.textColor = Theme.ink3

        amountLabel.font = .systemFont(
            ofSize: 17,
            weight: .heavy
        )

        amountLabel.textColor = Theme.ink

        arrowImageView.image =
            UIImage(systemName: "chevron.down")

        arrowImageView.tintColor = Theme.ink3

        let headerButton = UIButton(type: .system)

        headerButton.addTarget(
            self,
            action: #selector(headerTapped),
            for: .touchUpInside
        )

        card.addSubview(headerButton)

        headerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            headerButton.topAnchor.constraint(
                equalTo: card.topAnchor
            ),

            headerButton.leadingAnchor.constraint(
                equalTo: card.leadingAnchor
            ),

            headerButton.trailingAnchor.constraint(
                equalTo: card.trailingAnchor
            ),

            headerButton.heightAnchor.constraint(
                equalToConstant: 66
            )
        ])

        headerButton.addSubview(payoutIDLabel)
        headerButton.addSubview(infoLabel)
        headerButton.addSubview(amountLabel)
        headerButton.addSubview(arrowImageView)

        payoutIDLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            payoutIDLabel.topAnchor.constraint(
                equalTo: headerButton.topAnchor,
                constant: 13
            ),

            payoutIDLabel.leadingAnchor.constraint(
                equalTo: headerButton.leadingAnchor,
                constant: 13
            ),

            infoLabel.topAnchor.constraint(
                equalTo: payoutIDLabel.bottomAnchor,
                constant: 2
            ),

            infoLabel.leadingAnchor.constraint(
                equalTo: payoutIDLabel.leadingAnchor
            ),

            amountLabel.centerYAnchor.constraint(
                equalTo: headerButton.centerYAnchor
            ),

            amountLabel.trailingAnchor.constraint(
                equalTo: arrowImageView.leadingAnchor,
                constant: -8
            ),

            arrowImageView.trailingAnchor.constraint(
                equalTo: headerButton.trailingAnchor,
                constant: -12
            ),

            arrowImageView.centerYAnchor.constraint(
                equalTo: headerButton.centerYAnchor
            ),

            arrowImageView.widthAnchor.constraint(
                equalToConstant: 14
            )
        ])

        detailsStack.axis = .vertical
        detailsStack.spacing = 0

        card.addSubview(detailsStack)

        detailsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            detailsStack.topAnchor.constraint(
                equalTo: headerButton.bottomAnchor
            ),

            detailsStack.leadingAnchor.constraint(
                equalTo: card.leadingAnchor
            ),

            detailsStack.trailingAnchor.constraint(
                equalTo: card.trailingAnchor
            ),

            detailsStack.bottomAnchor.constraint(
                equalTo: card.bottomAnchor
            )
        ])
    }

    func configure(
        payout: Payout,
        consultations: [Consultation],
        expanded: Bool
    ) {

        self.payout = payout
        self.consultations = consultations
        self.isExpanded = expanded

        payoutIDLabel.text = "PAY-\(payout.id)"

        infoLabel.text =
            "\(payout.date) · \(payout.method)"

        amountLabel.text =
        "৳\(fmt(Float(payout.amount)))"

        detailsStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        detailsStack.isHidden = !expanded

        arrowImageView.transform =
            expanded
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity

        guard expanded else {
            return
        }

        for id in payout.items {

            guard let consultation =
                    consultations.first(where: { $0.id == id })
            else {
                continue
            }

            let row = createDetailRow(
                consultation: consultation
            )

            detailsStack.addArrangedSubview(row)
        }

         if let note = payout.note {

            let noteContainer = UIView()
            noteContainer.backgroundColor = Theme.dangerBg
            
            let noteLabel = UILabel()
            noteLabel.text = note
            noteLabel.numberOfLines = 0
            noteLabel.font = .systemFont(ofSize: 13.5)
            noteLabel.textColor = Theme.danger
            
            noteContainer.addSubview(noteLabel)
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noteLabel.topAnchor.constraint(equalTo: noteContainer.topAnchor, constant: 10),
                noteLabel.bottomAnchor.constraint(equalTo: noteContainer.bottomAnchor, constant: -10),
                noteLabel.leadingAnchor.constraint(equalTo: noteContainer.leadingAnchor, constant: 14),
                noteLabel.trailingAnchor.constraint(equalTo: noteContainer.trailingAnchor, constant: -14)
            ])

            detailsStack.addArrangedSubview(noteContainer)
         }
    }

    private func createDetailRow(
        consultation: Consultation
    ) -> UIView {

        let container = UIView()

        container.backgroundColor = Theme.card

        let leftLabel = UILabel()

        leftLabel.font = .systemFont(
            ofSize: 14
        )

        leftLabel.textColor = Theme.ink2
        leftLabel.numberOfLines = 0

        var title =
            "#\(consultation.booking) — \(consultation.patient)"

        if consultation.status == .voided,
           let date = consultation.voidedDate {

            let dateText = " (reversed \(date))"
            title += dateText
            
            let attr = NSMutableAttributedString(string: title)
            let nsRange = NSRange(title.range(of: dateText)!, in: title)
            attr.addAttribute(.foregroundColor, value: Theme.danger, range: nsRange)
            attr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            leftLabel.attributedText = attr
        } else {
            leftLabel.text = title
        }

        let amountLabel = UILabel()

        amountLabel.text =
        "৳\(fmt(Float(consultation.doctorFees)))"

        amountLabel.font = .systemFont(
            ofSize: 14,
            weight: .bold
        )

        amountLabel.textColor = Theme.ink

        container.addSubview(leftLabel)
        container.addSubview(amountLabel)

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            leftLabel.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 9
            ),

            leftLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 14
            ),

            leftLabel.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -9
            ),

            amountLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: leftLabel.trailingAnchor,
                constant: 8
            ),

            amountLabel.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -14
            ),

            amountLabel.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            )
        ])

        let line = UIView()
        line.backgroundColor = Theme.line2

        container.addSubview(line)

        line.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            line.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 14
            ),

            line.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -14
            ),

            line.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),

            line.heightAnchor.constraint(
                equalToConstant: 1
            )
        ])

        return container
    }

    @objc private func headerTapped() {
        onTap?()
    }
}


// MARK: - Earning View Controller

final class EarningViewController: UIViewController {

    private let vm = EarningViewModel()

    private var tableView: UITableView!
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private let refreshControl = UIRefreshControl()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let totalEarningLabel = UILabel()
    private let paidLabel = UILabel()
    private let dueLabel = UILabel()

    private let consultationsButton = UIButton(type: .system)
    private let payoutButton = UIButton(type: .system)
    
    private let filterContainer = UIView()
    private let filterButton = UIButton(type: .system)
    private var filterContainerHeightConstraint: NSLayoutConstraint!
    private var currentFilter: ConsultationStatus? = nil

    private let bottomRequestButton = UIButton(type: .system)

    private var detailConsultation: Consultation?

    private var showRequestSheet = false

    private var selectedConsultations = Set<Int>()

    private var requestMode = 0
    var notifyId: String?
    // 0 = Select Consultations
    // 1 = Whole Balance

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = Theme.bg

        setupUI()
        reloadData()
        fetchEarnings()
        
       
    }

    // MARK: UI

    private func setupUI() {

        setupNavigationHeader()
        setupScrollView()
        setupEarningCard()
        setupStats()
        setupSegments()
        setupTable()
        setupBottomButton()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           tableView.layoutIfNeeded()

           let height = tableView.contentSize.height
           let finalHeight = height == 0 ? 150 : height

           if tableViewHeightConstraint.constant != finalHeight {
               tableViewHeightConstraint.constant = finalHeight
           }
       }

    private func setupNavigationHeader() {

        let header = UIView()

        view.addSubview(header)

        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            header.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            header.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            header.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            header.heightAnchor.constraint(
                equalToConstant: 55
            )
        ])

//        let logoLabel = UILabel()
//
//        let logoText = NSMutableAttributedString(
//            string: "Dr.",
//            attributes: [
//                .foregroundColor: Theme.accent
//            ]
//        )
//
//        logoText.append(
//            NSAttributedString(
//                string: "LIVE",
//                attributes: [
//                    .foregroundColor: Theme.red
//                ]
//            )
//        )
//
//        logoLabel.attributedText = logoText
//
//        logoLabel.font = .systemFont(
//            ofSize: 19,
//            weight: .heavy
//        )

        let backButton = UIButton(type: .system)

          let backImage = UIImage(
              named: "Path 25"
          )

          backButton.setImage(
              backImage,
              for: .normal
          )

          backButton.tintColor = Theme.ink

          backButton.addTarget(
              self,
              action: #selector(backButtonTapped),
              for: .touchUpInside
          )
        
//        let doctorLabel = UILabel()

//        doctorLabel.text = "Doctor"
//        doctorLabel.font = .systemFont(
//            ofSize: 13,
//            weight: .semibold
//        )
//
//        doctorLabel.textColor = Theme.ink2
//        doctorLabel.backgroundColor = Theme.line2
//
//        doctorLabel.textAlignment = .center
//
//        doctorLabel.layer.cornerRadius = 12
//        doctorLabel.clipsToBounds = true

        header.addSubview(backButton)
//        header.addSubview(doctorLabel)

        let titleLabel = UILabel()
        titleLabel.text = "My Earning"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = Theme.ink
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)

        backButton.translatesAutoresizingMaskIntoConstraints = false
//        doctorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            backButton.leadingAnchor.constraint(
                equalTo: header.leadingAnchor,
                constant: 16
            ),

            backButton.centerYAnchor.constraint(
                equalTo: header.centerYAnchor
            ),

//            doctorLabel.trailingAnchor.constraint(
//                equalTo: header.trailingAnchor,
//                constant: -16
//            ),

            titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),

//            doctorLabel.centerYAnchor.constraint(
//                equalTo: header.centerYAnchor
//            ),

//            doctorLabel.widthAnchor.constraint(
//                equalToConstant: 62
//            ),

//            doctorLabel.heightAnchor.constraint(
//                equalToConstant: 25
//            )
        ])
    }
    @objc private func backButtonTapped() {
        // navigationController?.popViewController(animated: true)
         let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
    }

    private func setupScrollView() {

        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 55
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -78
            )
        ])

        scrollView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),

            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),

            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),

            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            )
        ])
    }

    private func setupEarningCard() {

        let card = UIView()

        card.backgroundColor = UIColor(named: "ButtonBlueColor") ??  Theme.accent
        card.layer.cornerRadius = 18

        contentView.addSubview(card)

        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            card.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            card.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            card.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            card.heightAnchor.constraint(
                equalToConstant: 105
            )
        ])

        let title = UILabel()

        title.text = "Total Earning"
        title.font = .systemFont(
            ofSize: 14
        )

        title.textColor =
            UIColor.white.withAlphaComponent(0.85)

        totalEarningLabel.font =
            .systemFont(
                ofSize: 30,
                weight: .heavy
            )

        totalEarningLabel.textColor = .white

        card.addSubview(title)
        card.addSubview(totalEarningLabel)

        title.translatesAutoresizingMaskIntoConstraints = false
        totalEarningLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            title.topAnchor.constraint(
                equalTo: card.topAnchor,
                constant: 20
            ),

            title.leadingAnchor.constraint(
                equalTo: card.leadingAnchor,
                constant: 20
            ),

            totalEarningLabel.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: 2
            ),

            totalEarningLabel.leadingAnchor.constraint(
                equalTo: title.leadingAnchor
            )
        ])
    }

    private func setupStats() {

        let stack = UIStackView()

        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually

        contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: totalEarningLabel.superview!.bottomAnchor,
                constant: 12
            ),

            stack.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            stack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            stack.heightAnchor.constraint(
                equalToConstant: 75
            )
        ])

        stack.addArrangedSubview(
            createStatBox(
                title: "PAID",
                label: paidLabel,
                color: Theme.success
            )
        )

        stack.addArrangedSubview(
            createStatBox(
                title: "DUE",
                label: dueLabel,
                color: Theme.warn
            )
        )
    }

    private func createStatBox(
        title: String,
        label: UILabel,
        color: UIColor
    ) -> UIView {

        let container = UIView()

        container.backgroundColor = Theme.card
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor =
            Theme.line.cgColor

        let titleLabel = UILabel()

        titleLabel.text = title
        titleLabel.font = .systemFont(
            ofSize: 13
        )

        titleLabel.textColor = Theme.ink3

        label.font = .systemFont(
            ofSize: 20,
            weight: .heavy
        )

        label.textColor = color

        container.addSubview(titleLabel)
        container.addSubview(label)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 12
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 14
            ),

            label.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 2
            ),

            label.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            )
        ])

        return container
    }

    private func setupSegments() {

        let container = UIView()

        container.backgroundColor = Theme.line2
        container.layer.cornerRadius = 10

        contentView.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(
                equalTo: paidLabel.superview!.bottomAnchor,
                constant: 16
            ),

            container.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            container.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            container.heightAnchor.constraint(
                equalToConstant: 44
            )
        ])

        configureSegmentButton(
            consultationsButton,
            title: "Recent Consultations"
        )

        configureSegmentButton(
            payoutButton,
            title: "Payout History"
        )

        consultationsButton.addTarget(
            self,
            action: #selector(showConsultations),
            for: .touchUpInside
        )

        payoutButton.addTarget(
            self,
            action: #selector(showPayouts),
            for: .touchUpInside
        )

        let stack = UIStackView(
            arrangedSubviews: [
                consultationsButton,
                payoutButton
            ]
        )

        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually

        container.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 3
            ),

            stack.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -3
            ),

            stack.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 3
            ),

            stack.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -3
            )
        ])
        
        contentView.addSubview(filterContainer)
        filterContainer.translatesAutoresizingMaskIntoConstraints = false
        
        filterContainerHeightConstraint = filterContainer.heightAnchor.constraint(equalToConstant: 30)
        
        NSLayoutConstraint.activate([
            filterContainer.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
            filterContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filterContainerHeightConstraint
        ])
        
        filterButton.setTitle(" Filter: All", for: .normal)
        let filterIcon = UIImage(systemName: "line.3.horizontal.decrease.circle")
        filterButton.setImage(filterIcon, for: .normal)
        filterButton.tintColor = Theme.ink
        filterButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        filterButton.contentHorizontalAlignment = .left
        
        if #available(iOS 14.0, *) {
            filterButton.showsMenuAsPrimaryAction = true
            setupFilterMenu()
        } else {
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
        
        filterContainer.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: filterContainer.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: filterContainer.bottomAnchor),
            filterButton.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: filterContainer.trailingAnchor)
        ])
    }

    private func configureSegmentButton(
        _ button: UIButton,
        title: String
    ) {

        button.setTitle(
            title,
            for: .normal
        )

        button.titleLabel?.font =
            .systemFont(
                ofSize: 14.5,
                weight: .bold
            )

        button.setTitleColor(
            Theme.ink3,
            for: .normal
        )

        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
    }

    private func updateSegmentUI() {

        let selected =
            UIColor.white

        if vm.selectedTab == 0 {

            consultationsButton.backgroundColor = selected

            consultationsButton.setTitleColor(
//                Theme.accent,
                UIColor(named: "ButtonBlueColor") ?? Theme.accent,
                for: .normal
            )

            payoutButton.backgroundColor = .clear

            payoutButton.setTitleColor(
                Theme.ink3,
                for: .normal
            )

        } else {

            payoutButton.backgroundColor = selected

            payoutButton.setTitleColor(
//                Theme.accent,
                UIColor(named: "ButtonBlueColor") ?? Theme.accent,
                for: .normal
            )

            consultationsButton.backgroundColor = .clear

            consultationsButton.setTitleColor(
                Theme.ink3,
                for: .normal
            )
        }
    }

//    private func setupTable() {
//
//        tableView = UITableView(
//            frame: .zero,
//            style: .plain
//        )
//
//        tableView.backgroundColor = .clear
//
//        tableView.separatorStyle = .none
//
//        tableView.showsVerticalScrollIndicator = false
//
//        tableView.register(
//            ConsultationCell.self,
//            forCellReuseIdentifier:
//                ConsultationCell.identifier
//        )
//
//        tableView.register(
//            PayoutCell.self,
//            forCellReuseIdentifier:
//                PayoutCell.identifier
//        )
//
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        contentView.addSubview(tableView)
//
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            tableView.topAnchor.constraint(
//                equalTo: payoutButton.superview!.bottomAnchor,
//                constant: 10
//            ),
//
//            tableView.leadingAnchor.constraint(
//                equalTo: contentView.leadingAnchor,
//                constant: 16
//            ),
//
//            tableView.trailingAnchor.constraint(
//                equalTo: contentView.trailingAnchor,
//                constant: -16
//            ),
//
//            tableView.heightAnchor.constraint(
//                greaterThanOrEqualToConstant: 100
//            ),
//
//            tableView.bottomAnchor.constraint(
//                equalTo: contentView.bottomAnchor,
//                constant: -20
//            )
//        ])
//    }
    
    private func setupTable() {

        tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.register(
            ConsultationCell.self,
            forCellReuseIdentifier: ConsultationCell.identifier
        )

        tableView.register(
            PayoutCell.self,
            forCellReuseIdentifier: PayoutCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        contentView.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableViewHeightConstraint =
            tableView.heightAnchor.constraint(equalToConstant: 0)

        tableViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: filterContainer.bottomAnchor,
                constant: 10
            ),

            tableView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            tableView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            tableView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ])
    }
    
    
    @objc private func refreshData() {
        if vm.selectedTab == 0 {
            fetchEarnings(isRefreshControl: true)
        } else {
            guard let token = UserDefaults.standard.string(forKey: Constants.accessToken),
                  let code = UserDefaults.standard.string(forKey: Constants.languageCode) else {
                refreshControl.endRefreshing()
                return
            }
            let parameter = ["language_type": code, "token": token]
            myWidhrawApi(param: parameter,isRefreshControl: true)
        }
    }
    
    private func reloadData() {

        totalEarningLabel.text = "৳\(fmt(vm.totalEarning))"
        paidLabel.text = "৳\(fmt(vm.paidTotal))"
        dueLabel.text = "৳\(fmt(vm.dueTotal))"

        updateSegmentUI()

        let isEmpty: Bool
        if vm.selectedTab == 0 {
            let filteredConsultations = currentFilter == nil ? vm.consultations : vm.consultations.filter { $0.status == currentFilter }
            isEmpty = filteredConsultations.isEmpty
            filterContainer.isHidden = false
            filterContainerHeightConstraint.constant = 30
        } else {
            isEmpty = vm.payouts.isEmpty
            filterContainer.isHidden = true
            filterContainerHeightConstraint.constant = 0
        }
        showDataNotFoundLabel(isEmpty)

        tableView.reloadData()
    }
    
    private func updateTableViewHeight() {

        tableView.layoutIfNeeded()

        let height = tableView.contentSize.height
        let finalHeight = height == 0 ? 150 : height

        tableViewHeightConstraint.constant = finalHeight
    }

    private func setupBottomButton() {

        bottomRequestButton.setTitle(
            "＋  Request Payout",
            for: .normal
        )

        bottomRequestButton.setTitleColor(
            .white,
            for: .normal
        )

        bottomRequestButton.titleLabel?.font =
            .systemFont(
                ofSize: 16,
                weight: .bold
            )

        bottomRequestButton.backgroundColor = UIColor(named: "ButtonBlueColor") ?? Theme.accent
//            Theme.accent

        bottomRequestButton.layer.cornerRadius = 14

        bottomRequestButton.addTarget(
            self,
            action: #selector(requestPayoutTapped),
            for: .touchUpInside
        )

        view.addSubview(bottomRequestButton)

        bottomRequestButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            bottomRequestButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),

            bottomRequestButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            bottomRequestButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -12
            ),

            bottomRequestButton.heightAnchor.constraint(
                equalToConstant: 52
            )
        ])
    }

    // MARK: Data

//    private func reloadData() {
//
//        totalEarningLabel.text =
//            "৳\(fmt(vm.totalEarning))"
//
//        paidLabel.text =
//            "৳\(fmt(vm.paidTotal))"
//
//        dueLabel.text =
//            "৳\(fmt(vm.dueTotal))"
//
//        updateSegmentUI()
//
//        tableView.reloadData()
//    }

    // MARK: Filter Actions
    
    @available(iOS 14.0, *)
    private func setupFilterMenu() {
        let allAction = UIAction(title: "All", state: currentFilter == nil ? .on : .off) { [weak self] _ in
            self?.applyFilter(nil)
        }
        let paidAction = UIAction(title: "Paid", state: currentFilter == .paid ? .on : .off) { [weak self] _ in
            self?.applyFilter(.paid)
        }
        let dueAction = UIAction(title: "Due", state: currentFilter == .unpaid ? .on : .off) { [weak self] _ in
            self?.applyFilter(.unpaid)
        }
        let voidAction = UIAction(title: "Void", state: currentFilter == .voided ? .on : .off) { [weak self] _ in
            self?.applyFilter(.voided)
        }
        let pendingAction = UIAction(title: "Pending", state: currentFilter == .pending ? .on : .off) { [weak self] _ in
            self?.applyFilter(.pending)
        }
        
        let menu = UIMenu(title: "Filter Consultations", children: [allAction, paidAction, dueAction, voidAction, pendingAction])
        filterButton.menu = menu
    }
    
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Filter Consultations", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in self?.applyFilter(nil) }))
        alert.addAction(UIAlertAction(title: "Paid", style: .default, handler: { [weak self] _ in self?.applyFilter(.paid) }))
        alert.addAction(UIAlertAction(title: "Due", style: .default, handler: { [weak self] _ in self?.applyFilter(.unpaid) }))
        alert.addAction(UIAlertAction(title: "Void", style: .default, handler: { [weak self] _ in self?.applyFilter(.voided) }))
        alert.addAction(UIAlertAction(title: "Pending", style: .default, handler: { [weak self] _ in self?.applyFilter(.pending) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func applyFilter(_ status: ConsultationStatus?) {
        currentFilter = status
        
        var title = " Filter: All"
        switch status {
        case .paid: title = " Filter: Paid"
        case .unpaid: title = " Filter: Due"
        case .voided: title = " Filter: Void"
        case .pending: title = " Filter: Pending"
        case .none: title = " Filter: All"
        }
        filterButton.setTitle(title, for: .normal)
        
        if #available(iOS 14.0, *) {
            setupFilterMenu()
        }
        fetchEarnings()
        reloadData()
    }
    
    private func fetchEarnings(isRefreshControl: Bool = false) {
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        var parameter = ["language_type": code,
                         "token": token,
                         "type": "call"]
        if let notifyId = notifyId {
            parameter["notify_id"] = notifyId
        }
        if let filter = currentFilter {
            switch filter {
            case .paid: parameter["status"] = "Paid"
            case .unpaid: parameter["status"] = "UnPaid"
            case .voided: parameter["status"] = "Void"
            case .pending: parameter["status"] = "Pending Withdrawal Request"
            }
        }
        getEarningsApi(param: parameter, isRefreshControl: isRefreshControl)
    }

    // MARK: Segment Actions

    @objc private func showConsultations() {

        vm.selectedTab = 0
        vm.expandedPayoutIndex = nil

        reloadData()
    }

    @objc private func showPayouts() {

        vm.selectedTab = 1

//        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken),
//              let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        
//        var parameter: [String: String] = [
//            "language_type": code,
//            "token": token,
//            "type": "call"
//        ]
//        if let notifyId = notifyId {
//            parameter["notify_id"] = notifyId
//        }
//        
//        getPayoutsApi(param: parameter)
        
        var parameter1 = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter1 = ["language_type": code,
                     "token": token]
        myWidhrawApi(param: parameter1)

        reloadData()
    }

    // MARK: Consultation Detail

    private func showConsultationDetail(
        _ consultation: Consultation
    ) {

        detailConsultation = consultation

        let controller =
            ConsultationDetailViewController(
                consultation: consultation
            )

        controller.modalPresentationStyle =
            .pageSheet

        if let sheet =
            controller.sheetPresentationController {

            sheet.detents = [
                .medium(),
                .large()
            ]

            sheet.prefersGrabberVisible = true
        }

        present(
            controller,
            animated: true
        )
    }
    

    // MARK: Request Payout

    @objc private func requestPayoutTapped() {

        let controller =
            RequestPayoutViewController(
                viewModel: vm
            )

        controller.onSubmit = {
            [weak self] total in

            self?.dismiss(
                animated: true
            ) {
                self?.showToast(
                    "Request sent — ৳\(fmt(Float(total))) — admin will review it in Accounts > Requests"
                )
                self?.fetchEarnings()
            }
        }

        controller.modalPresentationStyle =
            .pageSheet

        if let sheet =
            controller.sheetPresentationController {

            sheet.detents = [
                .medium(),
                .large()
            ]

            sheet.prefersGrabberVisible = true
        }

        present(
            controller,
            animated: true
        )
    }

    // MARK: Toast

    private func showToast(
        _ message: String
    ) {

        let container = UIView()
        container.backgroundColor = Theme.ink
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        let toast = UILabel()
        toast.text = message
        toast.textColor = .white
        toast.font = .systemFont(ofSize: 15)
        toast.numberOfLines = 0
        toast.textAlignment = .center
        toast.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(toast)
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),

            toast.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            toast.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            toast.topAnchor.constraint(equalTo: container.topAnchor, constant: 11),
            toast.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -11)
        ])

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.6
        ) {
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    container.alpha = 0
                },
                completion: { _ in
                    container.removeFromSuperview()
                }
            )
        }
    }
}


// MARK: - UITableViewDataSource

extension EarningViewController:
    UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        if vm.selectedTab == 0 {
            if let filter = currentFilter {
                return vm.consultations.filter { $0.status == filter }.count
            }
            return vm.consultations.count
        }

        return vm.payouts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        if vm.selectedTab == 0 {

            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        ConsultationCell.identifier,
                    for: indexPath
                ) as! ConsultationCell

            let filteredConsultations = currentFilter == nil ? vm.consultations : vm.consultations.filter { $0.status == currentFilter }
            cell.consultation =
                filteredConsultations[indexPath.row]

            return cell

        } else {

            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        PayoutCell.identifier,
                    for: indexPath
                ) as! PayoutCell

            let payout =
                vm.payouts[indexPath.row]

            cell.configure(
                payout: payout,
                consultations: vm.consultations + vm.payoutConsultations,
                expanded:
                    vm.expandedPayoutIndex ==
                        indexPath.row
            )

            cell.onTap = {
                [weak self] in

                guard let self else {
                    return
                }

                self.vm.togglePayout(
                    indexPath.row
                )

                self.tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic
                )

                self.updateTableViewHeight()
            }

            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension EarningViewController:
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        guard vm.selectedTab == 0 else {
            return
        }

        let filteredConsultations = currentFilter == nil ? vm.consultations : vm.consultations.filter { $0.status == currentFilter }
        let consultation =
            filteredConsultations[indexPath.row]

        showConsultationDetail(
            consultation
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        UITableView.automaticDimension
    }
}
 

import UIKit

//extension UIViewController {
//
//    /// Returns a custom detent that matches this controller's content height,
//    /// capped between `minHeight` and `maxHeight`.
//    func contentSizedDetent(
//        minHeight: CGFloat = 180,
//        maxHeight: CGFloat? = nil
//    ) -> UISheetPresentationController.Detent {
//        if #available(iOS 16.0, *) {
//            return .custom(identifier: .init("contentSize")) { [weak self] context in
//                guard let self else { return minHeight }
//                
//                // Force the layout pass so we get real numbers
//                self.view.layoutIfNeeded()
//                
//                let targetWidth = self.view.bounds.width > 0
//                ? self.view.bounds.width
//                : self.view.window?.bounds.width ?? UIScreen.main.bounds.width
//                
//                let fittingSize = CGSize(
//                    width: targetWidth,
//                    height: UIView.layoutFittingCompressedSize.height
//                )
//                
//                let height = self.view.systemLayoutSizeFitting(
//                    fittingSize,
//                    withHorizontalFittingPriority: .required,
//                    verticalFittingPriority: .fittingSizeLevel
//                ).height
//                
//                let cap = maxHeight ?? (context.maximumDetentValue - 20)
//                return min(max(height, minHeight), cap)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        }
//    }
//}

struct MyEarningNewResponse: Codable {
    let myearning: MyEarningData?
}

struct MyEarningData: Codable {
    let earning: [MyEarningItem]?
    let due:Float?
    let totalEarning:String?
    let paid:Float?
}

struct MyEarningItem: Codable {
    let id: String?
    let doctor_name: String?
    let patient_name: String?
    let booking_id: String?
    let booking: String?
    let booking_date: String?
    let amount: String?
    let commission: String?
    let pay_amount: String?
    let earning_status: String?
    let void_reason: String?
    let void_reference: String?
    let void_date: String?
    let patient_id:String?
}

extension EarningViewController {
    
    func getEarningsApi(param: [String: String],isRefreshControl:Bool = false){
        if isRefreshControl == false{
            LoaderController.sharedInstance.showLoader(view: self.view)
        }
        firstly {
            service!.myEarning(parameters: param, header: "DeviceToken")
        }.done { (model: MyEarningNewResponse) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                self.showDataNotFoundLabel(true)
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func myWidhrawApi(param: [String: String],isRefreshControl:Bool = false){
        if isRefreshControl == false{
            LoaderController.sharedInstance.showLoader(view: self.view)
        }
        firstly {
            service!.myWidhraw(parameters: param, header: "DeviceToken")
        }.done { (model: MyWithdrawNewResponse) in
            self.myWidhrawResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func handleResponse(model: MyEarningNewResponse){
        print("model", model)
        if let model = model.myearning{
            vm.paidTotal = Float(model.paid ?? 0)
            vm.dueTotal = Float(model.due ?? 0)
            vm.totalEarning = Float(model.totalEarning ?? "") ?? 0
        }
        if let items = model.myearning?.earning {
            let consultations = items.map { item -> Consultation in
                let statusStr = (item.earning_status ?? "").lowercased()
                var status: ConsultationStatus = .paid
                if statusStr == "void" {
                    status = .voided
                } else if statusStr == "unpaid" {
                    status = .unpaid
                } else if statusStr == "pending withdrawal request" {
                    status = .pending
                }
                return Consultation(
                    id: Int(item.id ?? "") ?? 0,
                    booking: item.booking_id ?? "",
                    patient: item.patient_name ?? "",
                    date: item.booking_date ?? "",
                    fees: Double(item.pay_amount ?? "0") ?? 0.0,
                    paidFees: Double(item.pay_amount ?? "0") ?? 0.0,
                    doctorFees: Double(item.amount ?? "0") ?? 0.0,
                    status: status,
                    transactionId: item.id,
                    voidReason: item.void_reason,
                    voidedDate: item.void_date,
                    patient_id: item.patient_id
                )
            }
            self.vm.consultations = consultations
            
            if consultations.isEmpty {
                self.showDataNotFoundLabel(true)
            } else {
                self.showDataNotFoundLabel(false)
            }
            
            self.reloadData()
        }else{
            self.showDataNotFoundLabel(true)
        }
    }
    
    private func myWidhrawResponse(model: MyWithdrawNewResponse){
        print("model", model)
         
        if let items = model.mywithdraw?.earning {
            var allPayoutConsultations: [Consultation] = []
            
            let payouts = items.map { item -> Payout in
                let patients = item.patients ?? []
                let itemIds = patients.compactMap { Int($0.patient_id ?? "0") }
                
                for patient in patients {
                    let statusStr = (patient.earning_status ?? "").lowercased()
                    var status: ConsultationStatus = .paid
                    if statusStr == "void" {
                        status = .voided
                    } else if statusStr == "unpaid" {
                        status = .unpaid
                    } else if statusStr == "pending" {
                        status = .pending
                    }
                    
                    let consultation = Consultation(
                        id: Int(patient.patient_id ?? "0") ?? 0,
                        booking: patient.booking_id ?? "", 
                        patient: patient.patient_name ?? "",
                        date: "",
                        fees: Double(patient.amount ?? "0") ?? 0.0,
                        paidFees: Double(patient.amount ?? "0") ?? 0.0,
                        doctorFees: Double(patient.amount ?? "0") ?? 0.0,
                        status: status,
                        voidReason: patient.void_reason,
                        voidedDate: patient.void_date
                    )
                    allPayoutConsultations.append(consultation)
                }
                
                return Payout(
                    id: item.id ?? "",
                    date: item.created_date ?? "",
                    amount: Double(item.fees ?? 0.0),
                    method: item.bank_name ?? "",
                    items: itemIds,
                    note: nil
                )
            }
            self.vm.payouts = payouts
            self.vm.payoutConsultations = allPayoutConsultations
            
            if payouts.isEmpty {
                self.showDataNotFoundLabel(true)
            } else {
                self.showDataNotFoundLabel(false)
            }
            
            self.reloadData()
        } else {
            self.showDataNotFoundLabel(true)
        }
    }
    private func showDataNotFoundLabel(_ show: Bool) {
        let labelTag = 9999
        if show {
            if self.tableView.viewWithTag(labelTag) == nil {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 100))
                label.text = "Data not found"
                label.textAlignment = .center
                label.tag = labelTag
                label.textColor = .gray
                self.tableView.backgroundView = label
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
        } else {
            self.tableView.backgroundView?.isHidden = true
        }
    }
}

struct MyWithdrawNewResponse: Codable {
    let mywithdraw: MyWithdrawData?
}

struct MyWithdrawData: Codable {
    let earning: [MyWithdrawItem]?
}

struct MyWithdrawItem: Codable {
    let id: String?
    let bank_name: String?
    let account_number: String?
    let created_date: String?
    let fees: Double?
    let status: String?
    let patients: [MyWithdrawPatient]?
}

struct MyWithdrawPatient: Codable {
    let patient_id: String?
    let patient_name: String?
    let amount: String?
    let earning_status: String?
    let void_reason: String?
    let void_reference: String?
    let void_date: String?
    let booking_id:String?
}
