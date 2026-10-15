 
import UIKit
import Foundation

//MARK: -  DoctorCardTableViewCell

final class DoctorCardTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DoctorCardTableViewCell"

    // MARK: - Callbacks

    var onChat: (() -> Void)?
    var onToggleExpand: (() -> Void)?
    var onLoadMore: (() -> Void)?
    var onBookingTap: ((Booking) -> Void)?
    var onPrescriptionOpen: ((String) -> Void)?

    // MARK: - State

    private(set) var isExpanded = false
    private var bookings: [Booking] = []

    // MARK: - UI

    private let cardView = UIView()
    private let bookingCountView = UIView()
    private let bookingCountImageView = UIImageView()
    private let bookingCountLabel1 = UILabel()

    private let avatarView = UIView()
    private let avatarImageView = UIImageView()
    private let initialsLabel = UILabel()

    private let specialtyLabel = UILabel()
    private let doctorNameLabel = UILabel()
    private let bookingCountLabel = UILabel()

    private let chatButton = UIButton(type: .system)
    private let expandButton = UIButton(type: .system)

    private let bookingsStackView = UIStackView()
    private let loadMoreButton = UIButton(type: .system)

    private let timerPillView = UIView()
    private let timerPillLabel = UILabel()

    private var timerPillTopConstraint: NSLayoutConstraint!
    var timerPillHeightConstraint: NSLayoutConstraint!
    var chatBtnTopConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        selectionStyle = .none

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupCard()
        setupTotalBookingCount()
        setupAvatar()
        setupLabels()
        setupButtons()
        setupBookingsStack()
        setupLoadMoreButton()
        setupConstraints()
    }

    // MARK: - Card

    private func setupCard() {

//        cardView.backgroundColor = .white
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor( red: 221/255,green: 230/255,blue: 242/255,alpha: 1).cgColor
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 18
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0,height: 3)
//        UIColor( red: 0.85,green: 0.91,blue: 0.97,alpha: 1)

        contentView.addSubview(cardView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    // MARK: - Booking Count
    private func setupTotalBookingCount(){
        
        bookingCountView.backgroundColor = UIColor( red: 239/255,green: 244/255,blue: 252/255,alpha: 1)
        bookingCountView.layer.cornerRadius = 12
        bookingCountView.clipsToBounds = true

        bookingCountImageView.image = UIImage(
            systemName: "video.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .bold
                )
        )
        bookingCountImageView.tintColor = UIColor(
            red: 0.11,
            green: 0.37,
            blue: 0.79,
            alpha: 1
        )
        bookingCountImageView.contentMode = .scaleAspectFit

        bookingCountLabel1.text = "\(bookings.count)"
        bookingCountLabel1.textColor = UIColor(
            red: 0.11,
            green: 0.37,
            blue: 0.79,
            alpha: 1
        )
        bookingCountLabel1.font = .systemFont(
            ofSize: 10.5,
            weight: .bold
        )
        bookingCountLabel1.textAlignment = .center

        cardView.addSubview(bookingCountView)

        bookingCountView.addSubview(bookingCountImageView)
        bookingCountView.addSubview(bookingCountLabel1)
        bookingCountView.translatesAutoresizingMaskIntoConstraints = false
        bookingCountImageView.translatesAutoresizingMaskIntoConstraints = false
        bookingCountLabel1.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Avatar

    private func setupAvatar() {

        avatarView.layer.cornerRadius = 14
        avatarView.clipsToBounds = true

        // Approximation of SwiftUI:
        // LinearGradient(.blue -> .indigo)
        avatarView.backgroundColor = UIColor(named: "ButtonBlueColor") ?? .black

        cardView.addSubview(avatarView)

        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        initialsLabel.textColor = .white
//        initialsLabel.font = .boldSystemFont(ofSize: 16)
        initialsLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        initialsLabel.textAlignment = .center

        avatarView.addSubview(initialsLabel)

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Labels

    private func setupLabels() {

        specialtyLabel.font = .boldSystemFont(ofSize: 11)
        specialtyLabel.textColor = UIColor(
            red: 0.12,
            green: 0.62,
            blue: 0.33,
            alpha: 1
        )
        
        doctorNameLabel.textColor = UIColor(
            red: 0.06,
            green: 0.11,
            blue: 0.18,
            alpha: 1
        )

        doctorNameLabel.font = .systemFont(
            ofSize: 15,
            weight: .bold
        )
        

        doctorNameLabel.textColor = .label

        bookingCountLabel.font =
            .systemFont(
                ofSize: 11.5,
                weight: .regular
            )
         bookingCountLabel.textColor = UIColor(
            red: 0.36,
            green: 0.42,
            blue: 0.51,
            alpha: 1
        )

        cardView.addSubview(specialtyLabel)
        cardView.addSubview(doctorNameLabel)
        cardView.addSubview(bookingCountLabel)

        specialtyLabel.translatesAutoresizingMaskIntoConstraints = false
        doctorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bookingCountLabel.translatesAutoresizingMaskIntoConstraints = false

        timerPillView.backgroundColor = UIColor(red: 254/255, green: 246/255, blue: 231/255, alpha: 1)
        timerPillView.layer.cornerRadius = 14
        
        timerPillLabel.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        timerPillLabel.textColor = UIColor(red: 176/255, green: 125/255, blue: 24/255, alpha: 1)
        
        timerPillView.addSubview(timerPillLabel)
        cardView.addSubview(timerPillView)
        
        timerPillView.translatesAutoresizingMaskIntoConstraints = false
        timerPillLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Buttons

    private func setupButtons() {

        var chatConfig =
            UIButton.Configuration.filled()
        chatConfig.baseBackgroundColor =  UIColor(named: "ButtonBlueColor") ?? .black

        chatConfig.title = "Chat"
        chatConfig.image = UIImage(
            systemName: "message.fill"
        )

        chatConfig.imagePadding = 6
        chatConfig.cornerStyle = .large

        chatButton.configuration = chatConfig
        chatButton.titleLabel?.font = .systemFont(
                ofSize: 12.5,
                weight: .bold
            )

        chatButton.addTarget(
            self,
            action: #selector(chatTapped),
            for: .touchUpInside
        )

        var expandConfig =
            UIButton.Configuration.bordered()
        expandConfig.baseForegroundColor =  UIColor(named: "ThemeColor") ?? .black
        expandConfig.baseBackgroundColor = UIColor( red: 239/255,green: 244/255,blue: 252/255,alpha: 1)

        expandConfig.image = UIImage(
            systemName: "chevron.up"
        )

        expandConfig.cornerStyle = .medium

        expandButton.configuration = expandConfig

        expandButton.addTarget(
            self,
            action: #selector(expandTapped),
            for: .touchUpInside
        )

        cardView.addSubview(chatButton)
        cardView.addSubview(expandButton)

        chatButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Bookings

    private func setupBookingsStack() {

        bookingsStackView.axis = .vertical
        bookingsStackView.spacing = 7
        bookingsStackView.alignment = .fill
        bookingsStackView.distribution = .fill

        cardView.addSubview(bookingsStackView)

        bookingsStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            // Card

            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            cardView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),

            // Avatar

            avatarView.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 16
            ),

            avatarView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 16
            ),

            avatarView.widthAnchor.constraint(
                equalToConstant: 50
            ),

            avatarView.heightAnchor.constraint(
                equalToConstant: 50
            ),

            // Avatar ImageView

            avatarImageView.topAnchor.constraint(
                equalTo: avatarView.topAnchor
            ),

            avatarImageView.leadingAnchor.constraint(
                equalTo: avatarView.leadingAnchor
            ),

            avatarImageView.trailingAnchor.constraint(
                equalTo: avatarView.trailingAnchor
            ),

            avatarImageView.bottomAnchor.constraint(
                equalTo: avatarView.bottomAnchor
            ),

            // Initials

            initialsLabel.centerXAnchor.constraint(
                equalTo: avatarView.centerXAnchor
            ),

            initialsLabel.centerYAnchor.constraint(
                equalTo: avatarView.centerYAnchor
            ),

            // Specialty

            specialtyLabel.topAnchor.constraint(
                equalTo: avatarView.topAnchor
            ),

            specialtyLabel.leadingAnchor.constraint(
                equalTo: avatarView.trailingAnchor,
                constant: 12
            ),

            specialtyLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: bookingCountView.leadingAnchor,
                constant: -8
            ),

            // Doctor name

            doctorNameLabel.topAnchor.constraint(
                equalTo: specialtyLabel.bottomAnchor,
                constant: 3
            ),

            doctorNameLabel.leadingAnchor.constraint(
                equalTo: specialtyLabel.leadingAnchor
            ),

            doctorNameLabel.trailingAnchor.constraint(
                equalTo: specialtyLabel.trailingAnchor
            ),

            // Booking count

            bookingCountLabel.topAnchor.constraint(
                equalTo: doctorNameLabel.bottomAnchor,
                constant: 3
            ),

            bookingCountLabel.leadingAnchor.constraint(
                equalTo: doctorNameLabel.leadingAnchor
            ),

            bookingCountLabel.trailingAnchor.constraint(
                equalTo: doctorNameLabel.trailingAnchor
            ),

            // Timer Pill

            timerPillView.leadingAnchor.constraint(equalTo: bookingCountLabel.leadingAnchor),
            timerPillLabel.centerYAnchor.constraint(equalTo: timerPillView.centerYAnchor),
            timerPillLabel.leadingAnchor.constraint(equalTo: timerPillView.leadingAnchor, constant: 12),
            timerPillLabel.trailingAnchor.constraint(equalTo: timerPillView.trailingAnchor, constant: -12),

            // Chat button

            chatButton.topAnchor.constraint(
                greaterThanOrEqualTo: avatarView.bottomAnchor,
                constant: 12
            ),

            chatButton.leadingAnchor.constraint(
//                equalTo: cardView.leadingAnchor,
//                constant: 16
                equalTo: avatarView.trailingAnchor,
                constant: 12
            ),

            chatButton.heightAnchor.constraint(
                equalToConstant: 40
            ),

            // Expand button

            expandButton.leadingAnchor.constraint(
                equalTo: chatButton.trailingAnchor,
                constant: 8
            ),

            expandButton.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -16
            ),

            expandButton.centerYAnchor.constraint(
                equalTo: chatButton.centerYAnchor
            ),

            expandButton.widthAnchor.constraint(
                equalToConstant: 40
            ),

            expandButton.heightAnchor.constraint(
                equalToConstant: 40
            ),

            // Chat button takes remaining space

            chatButton.trailingAnchor.constraint(
                equalTo: expandButton.leadingAnchor,
                constant: -8
            ),

            // Bookings

            bookingsStackView.topAnchor.constraint(
                equalTo: chatButton.bottomAnchor,
                constant: 10
            ),

            bookingsStackView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 16
            ),

            bookingsStackView.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -16
            ),

            // Load More Button (below stack view)

            loadMoreButton.topAnchor.constraint(
                equalTo: bookingsStackView.bottomAnchor,
                constant: 8
            ),

            loadMoreButton.centerXAnchor.constraint(
                equalTo: cardView.centerXAnchor
            ),
            
            bookingCountView.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 14
            ),

            bookingCountView.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -14
            ),

            bookingCountView.heightAnchor.constraint(
                equalToConstant: 24
            ),

            bookingCountImageView.leadingAnchor.constraint(
                equalTo: bookingCountView.leadingAnchor,
                constant: 9
            ),

            bookingCountImageView.centerYAnchor.constraint(
                equalTo: bookingCountView.centerYAnchor
            ),

            bookingCountImageView.widthAnchor.constraint(
                equalToConstant: 14
            ),

            bookingCountImageView.heightAnchor.constraint(
                equalToConstant: 14
            ),

            bookingCountLabel1.leadingAnchor.constraint(
                equalTo: bookingCountImageView.trailingAnchor,
                constant: 5
            ),

            bookingCountLabel1.trailingAnchor.constraint(
                equalTo: bookingCountView.trailingAnchor,
                constant: -9
            ),

            bookingCountLabel1.centerYAnchor.constraint(
                equalTo: bookingCountView.centerYAnchor
            )
        ])
        
        timerPillTopConstraint = timerPillView.topAnchor.constraint(equalTo: bookingCountLabel.bottomAnchor, constant: 0)
        timerPillHeightConstraint = timerPillView.heightAnchor.constraint(equalToConstant: 0)
        chatBtnTopConstraint = chatButton.topAnchor.constraint(greaterThanOrEqualTo: timerPillView.bottomAnchor, constant: 0)

        timerPillTopConstraint.isActive = true
        timerPillHeightConstraint.isActive = true
        chatBtnTopConstraint.isActive = true

        bottomConstraint = chatButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        bottomConstraint?.isActive = true
    }

    // MARK: - Load More Button Setup

    private func setupLoadMoreButton() {
        var config = UIButton.Configuration.borderless()
        config.title = "Load More"
        config.baseForegroundColor = .systemBlue
        config.buttonSize = .small
        loadMoreButton.configuration = config
        loadMoreButton.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
        loadMoreButton.isHidden = true
        cardView.addSubview(loadMoreButton)
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Configure

    func configure(
        doctorName: String,
        specialty: String,
        imageUrl: String? = nil,
        bookings: [Booking],
        expanded: Bool,
        chatButtonTitle:String,
        totalBookings: Int? = nil
    ) {

        self.isExpanded = expanded
        self.bookings = bookings
        self.loadMoreButton.configuration?.showsActivityIndicator = false


        doctorNameLabel.text = doctorName
        chatButton.setTitle(chatButtonTitle, for: .normal)

        specialtyLabel.text =
            specialty.uppercased()

        if bookings.isEmpty {

            bookingCountLabel.isHidden = true
            bookingCountLabel1.text = "0"

        } else {

            bookingCountLabel.isHidden = false

            let count = bookings.count

//            bookingCountLabel.text =
//                "\(count) booking\(count == 1 ? "" : "s")"
            bookingCountLabel.text = "Last booking · \(Booking.formattedDateeee(bookings.first?.date ?? Date())) \(bookings.first?.time ?? "")"
            bookingCountLabel1.text = "\(totalBookings ?? count)"
        }

        if let imageUrl = imageUrl, let url = URL(string: imageUrl.replacingOccurrences(of: " ", with: "%20")), !imageUrl.isEmpty {
            avatarImageView.isHidden = false
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "my_health"))
            initialsLabel.isHidden = true
        } else {
            avatarImageView.isHidden = true
            avatarImageView.image = nil
            initialsLabel.isHidden = false
            initialsLabel.text =
                makeInitials(from: doctorName)
        }

        updateExpandButton()

        updateBookings(bookings)
    }

    func configure(
        doctorName: String,
        specialty: String,
        bookings: [Booking],
        expanded: Bool,
        chatButtonTitle:String,
        totalBookings: Int? = nil
    ) {
        configure(
            doctorName: doctorName,
            specialty: specialty,
            imageUrl: nil,
            bookings: bookings,
            expanded: expanded,
            chatButtonTitle:chatButtonTitle,
            totalBookings: totalBookings
        )
    }

    // MARK: - Bookings
    private var countdownTimer: Timer?
    private var targetDate: Date?

    private func updateBookings(
        _ bookings: [Booking]
    ) {

        bookingsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        bookingsStackView.isHidden =
            !isExpanded || bookings.isEmpty

        countdownTimer?.invalidate()
        countdownTimer = nil
        
        if let first = bookings.first {
            switch first.status {
            case .requested, .paymentPending, .paymentCompleted,.suggestedTimeAccepted:
                if first.status == .requested {
                    timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
                } else if first.status == .paymentPending || first.status == .suggestedTimeAccepted {
                    timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                } else if first.status == .paymentCompleted {
                    timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                }
                
                let timerInterval = BookingTimerManager.shared.getTimer(for: first.status, defaultMinutes: 10)
                let target = first.date.addingTimeInterval(timerInterval)
                
                if Date() < target {
                    self.targetDate = target
                    updateTimerLabel()
                    startCountdownTimerIfNeeded()
                } else {
                    hideTimerPill()
                }
                
            case .callStarted:
                self.targetDate = first.date
                updateTimerLabel()
                startCountdownTimerIfNeeded()
                
            case .callEnded, .consultationCompleted:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 236/255, green: 253/255, blue: 243/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 2/255, green: 122/255, blue: 72/255, alpha: 1)
                showTimerPill(text: "✅ Call ended — awaiting prescription")
                
            case .callUnanswered:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
                showTimerPill(text: "📞 Call Unanswered")
            case .closed:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = .systemGray5
                timerPillLabel.textColor = .gray
                showTimerPill(text: "🔒 Chat Closed")
                
            case .rejected:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                showTimerPill(text: "❌ Booking rejected")
                
            case .suggestedTimePending:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                showTimerPill(text: "🕐 Confirm proposed time")
                
            case .paymentExpired:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                showTimerPill(text: "⏱ Payment window expired")
                        
            case .prescriptionSent:
                let timerInterval = BookingTimerManager.shared.getTimer(for: first.status, defaultMinutes: 120)
                let target = first.date.addingTimeInterval(timerInterval)
                
                if Date() < target {
                    self.targetDate = target
                    updateTimerLabel()
                    startCountdownTimerIfNeeded()
                } else {
                    hideTimerPill()
                }
                
            default:
                hideTimerPill()
            }
        } else {
            hideTimerPill()
        }
        
        // Show Load More button only when expanded, non-empty, and count is a multiple of 10
        loadMoreButton.isHidden = !isExpanded || bookings.isEmpty || bookings.count % 10 != 0

        bottomConstraint?.isActive = false
        if !isExpanded || bookings.isEmpty {
            bottomConstraint = chatButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        } else if loadMoreButton.isHidden {
            bottomConstraint = bookingsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        } else {
            bottomConstraint = loadMoreButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        }
        bottomConstraint?.isActive = true

        guard isExpanded else {
            return
        }

        for booking in bookings {

            let bookingView =
                BookingRowView()

            bookingView.configure(
                booking: booking
            )

            bookingView.onTap = { [weak self] in
                self?.onBookingTap?(booking)
            }

            bookingView.onPrescriptionTap = { [weak self] in
                let urlString = (booking.filePdf?.isEmpty == false) ? booking.filePdf : booking.fileImg
                if let urlString = urlString {
                    self?.onPrescriptionOpen?(urlString)
                }
            }

            bookingsStackView.addArrangedSubview(
                bookingView
            )
        }
    }

    // MARK: - Actions

    @objc private func updateTimerLabel() {
        
        guard let target = targetDate, let first = bookings.first else { return }
        
        if first.status == .callStarted {
            let elapsed = Date().timeIntervalSince(target)
            if elapsed >= 0 {
                let mins = Int(elapsed) / 60
                let secs = Int(elapsed) % 60
                timerPillView.backgroundColor = UIColor(red: 236/255, green: 253/255, blue: 243/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 2/255, green: 122/255, blue: 72/255, alpha: 1)
                timerPillLabel.text = String(format: "🟢 Call in progress · %02d:%02d", mins, secs)
                showTimerPill()
            }
        } else if first.status == .prescriptionSent {
            let remaining = target.timeIntervalSince(Date())
            if remaining > 0 {
                let hours = Int(remaining) / 3600
                let mins = (Int(remaining) % 3600) / 60
                timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                timerPillLabel.text = String(format: "⏳ Follow-up · %02dh %02dm", hours, mins)
                showTimerPill()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                hideTimerPill()
            }
        } else {
            let remaining = target.timeIntervalSince(Date())
            if remaining > 0 {
                let mins = Int(remaining) / 60
                let secs = Int(remaining) % 60
                var label = ""
                if first.status == .requested {
                    label = "⏱ Waiting for Doctor"
                    timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
                } else if first.status == .paymentPending || first.status == .suggestedTimeAccepted {
                    label = "⏱ Pay within"
                    timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                } else if first.status == .paymentCompleted {
                    label = "📞 Waiting for Call"
                    timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                }
                timerPillLabel.text = String(format: "\(label) · %02d:%02d", mins, secs)
                showTimerPill()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                hideTimerPill()
            }
        }
    }
    
    private func startCountdownTimerIfNeeded() {
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(countdownTimer!, forMode: .common)
        }
    }
    
    private func showTimerPill(text: String? = nil) {
        if let t = text {
            timerPillLabel.text = t
        }
        timerPillView.isHidden = false
        timerPillTopConstraint.constant = 10
        timerPillHeightConstraint.constant = 28
        chatBtnTopConstraint.constant = 12
    }

    private func hideTimerPill() {
        timerPillView.isHidden = true
        timerPillTopConstraint.constant = 0
        timerPillHeightConstraint.constant = 0
        chatBtnTopConstraint.constant = 0
    }

    @objc private func chatTapped() {

        onChat?()
    }

    @objc private func expandTapped() {

        isExpanded.toggle()

        updateExpandButton()
        updateBookings(self.bookings)

        onToggleExpand?()
    }
    
    @objc private func loadMoreTapped() {
        loadMoreButton.configuration?.showsActivityIndicator = true
        onLoadMore?()
    }

    private func updateExpandButton() {

        let imageName =
            isExpanded
            ? "chevron.up"
            : "chevron.down"

        expandButton.configuration?.image =
            UIImage(systemName: imageName)
    }

    // MARK: - Initials

    private func makeInitials(
        from name: String
    ) -> String {

        name
            .split(separator: " ")
            .compactMap {
                $0.first
            }
            .map(String.init)
            .joined()
    }

    // MARK: - Reuse

    override func prepareForReuse() {

        super.prepareForReuse()

        countdownTimer?.invalidate()
        countdownTimer = nil

        onChat = nil
        onToggleExpand = nil
        onLoadMore = nil
        onBookingTap = nil
        avatarImageView.image = nil
        avatarImageView.sd_cancelCurrentImageLoad()
        bookings = []

        bookingsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

//MARK: -  BOOKING ROW VIEW

final class BookingRowView: UIView {

    var onTap: (() -> Void)?
    var onPrescriptionTap: (() -> Void)?

        // MARK: - UI

        private let containerView = UIView()

        private let bookingIconView = UIView()
        private let bookingIconImageView = UIImageView()

        private let dateLabel = UILabel()
        private let bookingIdLabel = UILabel()
        private let timeLabel = UILabel()
        private let feesLabel = UILabel()

        private let statusPill = StatusPillView()
        private let prescriptionBtn = UIButton(type: .system)

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupUI()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - UI

        private func setupUI() {

            // Container
            containerView.backgroundColor = UIColor( red: 239/255,green: 244/255,blue: 252/255,alpha: 1)
            containerView.layer.cornerRadius = 12
            containerView.clipsToBounds = true

            addSubview(containerView)

            // Date
            dateLabel.font = .systemFont(
                ofSize: 13,
                weight: .medium
            )

//            dateLabel.textColor = .secondaryLabel
            
//            bookingIdLabel.font = .systemFont(ofSize: 12, weight: .regular)
//            bookingIdLabel.textColor = .secondaryLabel
            
            
            dateLabel.textColor = UIColor(
                red: 85/255,
                green: 107/255,
                blue: 128/255,
                alpha: 1
            )
            dateLabel.isHidden = true // Hide dateLabel as requested
            
            bookingIdLabel.font = .boldSystemFont(ofSize: 15)
            bookingIdLabel.textColor = .label


            // Time
            timeLabel.font = .systemFont(ofSize: 13, weight: .medium)
            timeLabel.textColor = .label
            
            // Fees
            feesLabel.font = .boldSystemFont(ofSize: 15)
            feesLabel.textColor = UIColor(
                red: 85/255,
                green: 107/255,
                blue: 128/255,
                alpha: 1
            )

            // MARK: Booking Icon

            bookingIconView.backgroundColor = UIColor( red: 225/255,green: 234/255,blue: 250/255,alpha: 1)
//            UIColor(
//                red: 0.87,
//                green: 0.92,
//                blue: 0.98,
//                alpha: 1
//            )

            bookingIconView.layer.cornerRadius = 9
            bookingIconView.clipsToBounds = true

            bookingIconImageView.image = UIImage(
                systemName: "clipboard",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 16,
                    weight: .bold
                )
            )

            bookingIconImageView.tintColor = UIColor(
                red: 0.11,
                green: 0.37,
                blue: 0.79,
                alpha: 1
            )

            bookingIconImageView.contentMode = .scaleAspectFit

            // MARK: Add Subviews

            containerView.addSubview(bookingIconView)
            bookingIconView.addSubview(bookingIconImageView)

            containerView.addSubview(dateLabel)
            containerView.addSubview(bookingIdLabel)
            containerView.addSubview(timeLabel)
            containerView.addSubview(feesLabel)
            containerView.addSubview(statusPill)
            
            prescriptionBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
            prescriptionBtn.layer.cornerRadius = 10
            prescriptionBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            prescriptionBtn.backgroundColor = UIColor(red: 0.11, green: 0.37, blue: 0.79, alpha: 1)
            prescriptionBtn.setTitleColor(.white, for: .normal)
            prescriptionBtn.isHidden = true
            prescriptionBtn.addTarget(self, action: #selector(prescriptionTapped), for: .touchUpInside)
            containerView.addSubview(prescriptionBtn)

            // IMPORTANT:
            // All views are now in the same hierarchy BEFORE constraints.
        }

        // MARK: - Constraints

        private func setupConstraints() {

            containerView.translatesAutoresizingMaskIntoConstraints = false
            bookingIconView.translatesAutoresizingMaskIntoConstraints = false
            bookingIconImageView.translatesAutoresizingMaskIntoConstraints = false

            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            bookingIdLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            feesLabel.translatesAutoresizingMaskIntoConstraints = false
            statusPill.translatesAutoresizingMaskIntoConstraints = false
            prescriptionBtn.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                // MARK: Container

                containerView.topAnchor.constraint(
                    equalTo: topAnchor
                ),

                containerView.leadingAnchor.constraint(
                    equalTo: leadingAnchor
                ),

                containerView.trailingAnchor.constraint(
                    equalTo: trailingAnchor
                ),

                containerView.bottomAnchor.constraint(
                    equalTo: bottomAnchor
                ),

                containerView.heightAnchor.constraint(
//                    equalToConstant: 58
                    equalToConstant: 75
                ),

                // MARK: Booking Icon

                bookingIconView.leadingAnchor.constraint(
                    equalTo: containerView.leadingAnchor,
                    constant: 12
                ),

                bookingIconView.centerYAnchor.constraint(
                    equalTo: containerView.centerYAnchor
                ),

                bookingIconView.widthAnchor.constraint(
                    equalToConstant: 29
                ),

                bookingIconView.heightAnchor.constraint(
                    equalToConstant: 29
                ),

                // MARK: Booking Icon Image

                bookingIconImageView.centerXAnchor.constraint(
                    equalTo: bookingIconView.centerXAnchor
                ),

                bookingIconImageView.centerYAnchor.constraint(
                    equalTo: bookingIconView.centerYAnchor
                ),

                bookingIconImageView.widthAnchor.constraint(
                    equalToConstant: 16
                ),

                bookingIconImageView.heightAnchor.constraint(
                    equalToConstant: 16
                ),

                // MARK: Date

                dateLabel.leadingAnchor.constraint(
                    equalTo: bookingIconView.trailingAnchor,
                    constant: 10
                ),

                dateLabel.topAnchor.constraint(
                    equalTo: containerView.topAnchor,
                    constant: 0
                ),
                dateLabel.heightAnchor.constraint(equalToConstant: 0),
                
                // MARK: Booking ID
                bookingIdLabel.leadingAnchor.constraint(
                    equalTo: dateLabel.leadingAnchor
                ),
                bookingIdLabel.topAnchor.constraint(
                    equalTo: containerView.topAnchor,
                    constant: 16
                ),
                bookingIdLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: feesLabel.leadingAnchor,
                    constant: -8
                ),

                // MARK: Time

                timeLabel.leadingAnchor.constraint(
                    equalTo: bookingIdLabel.leadingAnchor
                ),

                timeLabel.topAnchor.constraint(
                    equalTo: bookingIdLabel.bottomAnchor,
                    constant: 4
                ),
                timeLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: statusPill.leadingAnchor,
                    constant: -8
                ),
                timeLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: prescriptionBtn.leadingAnchor,
                    constant: -8
                ),
                
                // MARK: Fees

                feesLabel.trailingAnchor.constraint(
                    equalTo: containerView.trailingAnchor,
                    constant: -12
                ),

                feesLabel.centerYAnchor.constraint(
                    equalTo: bookingIdLabel.centerYAnchor
                ),

                // MARK: Status

                statusPill.trailingAnchor.constraint(
                    equalTo: containerView.trailingAnchor,
                    constant: -12
                ),

                statusPill.centerYAnchor.constraint(
                    equalTo: timeLabel.centerYAnchor
                ),
                
                prescriptionBtn.trailingAnchor.constraint(
                    equalTo: containerView.trailingAnchor,
                    constant: -12
                ),
                prescriptionBtn.centerYAnchor.constraint(
                    equalTo: timeLabel.centerYAnchor
                )
            ])

            // MARK: Tap

            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(rowTapped)
            )

            containerView.isUserInteractionEnabled = true
            containerView.addGestureRecognizer(tap)
        }

    @objc private func prescriptionTapped() {
        onPrescriptionTap?()
    }

    @objc private func rowTapped() {
        onTap?()
    }

    func configure(
        booking: Booking
    ) {
        
        //        dateLabel.text =  Booking.formattedDateeee(booking.date)
        ////        formattedDate(booking.date)
        //
        //
        //        timeLabel.text =
        //            booking.time
        let genderStr: String
        if let g = booking.memberGender?.lowercased() {
            if g == "m" || g == "male" {
                genderStr = "Male"
            } else if g == "f" || g == "female" {
                genderStr = "Female"
            } else {
                genderStr = booking.memberGender ?? ""
            }
        } else {
            genderStr = ""
        }
        
        let ageStr: String
        if let dob = booking.memberDob, !dob.isEmpty {
            ageStr = "\(dob) yrs"
        } else {
            ageStr = ""
        }
        
        if !ageStr.isEmpty && !genderStr.isEmpty {
            dateLabel.text = "\(ageStr) . \(genderStr)"
        } else if !ageStr.isEmpty {
            dateLabel.text = ageStr
        } else if !genderStr.isEmpty {
            dateLabel.text = genderStr
        } else {
            dateLabel.text = "Patient"
        }
        
        bookingIdLabel.text = "Booking #\(booking.bookingNumber ?? booking.id)"
        
        let formattedDateStr = Booking.formattedDate11(booking.date)
        timeLabel.text = "\(formattedDateStr) · \(booking.time)"
        
        let amt = booking.amount ?? "0"
        let parsedAmt = Double(amt) ?? 0.0
        if parsedAmt.truncatingRemainder(dividingBy: 1) == 0 {
            feesLabel.text = "৳\(Int(parsedAmt))"
        } else {
            feesLabel.text = "৳\(amt)"
        }
        
        if let pId = booking.prescriptionId, !pId.isEmpty {
            statusPill.isHidden = true
            prescriptionBtn.isHidden = false
            
            let hasPdf = (booking.filePdf?.isEmpty == false)
            let hasImg = (booking.fileImg?.isEmpty == false)
            
            if hasPdf {
                prescriptionBtn.setTitle("Prescription (PDF)", for: .normal)
            } else if hasImg {
                prescriptionBtn.setTitle("Prescription (JPG)", for: .normal)
            } else {
                prescriptionBtn.setTitle("Prescription", for: .normal)
            }
        } else {
            statusPill.isHidden = false
            prescriptionBtn.isHidden = true
            statusPill.configure(
                phase: convertStatusToPhase(
                    booking.status
                )
            )
        }
    }

//    private func formattedDate(
//        _ date: Date
//    ) -> String {
//
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "MMM d, yyyy"
//
//        return formatter.string(
//            from: date
//        )
//    }

    private func convertStatusToPhase(
        _ status: BookingStatus
    ) -> BookingPhase {
        
        switch status {
            
        case .requested:
            return .requested
            
        case .noResponse:
            return .noResponse
            
        case .rejected:
            return .rejected
            
        case .cancelled:
            return .cancelled
            
        case .paymentPending:
            return .paymentPending
            
        case .paymentExpired:
            return .paymentExpired
            
        case .paymentCompleted:
            return .paymentCompleted
            
        case .waitingForCall:
            return .waitingForCall
            
        case .callStarted:
            return .callStarted
            
        case .callEnded:
            return .callEnded
            
        case .consultationCompleted:
            return .consultationCompleted
            
        case .prescriptionSent:
            return .prescriptionSent
            
        case .followUpStarted:
            return .followUpStarted
            
        case .followUpClosed:
            return .followUpClosed
            
        case .closed:
            return .closed
        case .suggestedTimePending:
            return .suggestedTimePending
            
        case .suggestedTimeAccepted:
            return .suggestedTimeAccepted
            
        case .callUnanswered:
            return .callUnanswered
            
        }
    }
}

//MARK: -  BOOKING ROW VIEW

final class StatusPillView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {

        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    private func setupUI() {

        layer.cornerRadius = 10

        clipsToBounds = true

        addSubview(label)

        label.font =
            .boldSystemFont(ofSize: 10)

        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            label.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 5
            ),

            label.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -5
            ),

            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 9
            ),

            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -9
            )
        ])
    }

    func configure(
        phase: BookingPhase
    ) {

        label.text = title(for: phase)

        let color = color(for: phase)

        label.textColor = color

        backgroundColor =
            color.withAlphaComponent(0.1)
    }

    private func title(
        for phase: BookingPhase
    ) -> String {

        switch phase {
            
        case .requested: return "REQUESTED"
        case .noResponse: return "NO RESPONSE"
        case .rejected: return "REJECTED"
        case .cancelled: return "CANCELLED"
        case .paymentPending: return "PAYMENT PENDING"
        case .paymentExpired: return "PAYMENT EXPIRED"
        case .paymentCompleted: return "PAYMENT COMPLETED"
        case .waitingForCall: return "WAITING FOR CALL"
        case .callStarted: return "CALL STARTED"
        case .callEnded: return "CALL ENDED"
        case .consultationCompleted: return "CONSULTATION COMPLETED"
        case .prescriptionSent: return "PRESCRIPTION SENT"
        case .followUpStarted: return "FOLLOW UP STARTED"
        case .followUpClosed: return "FOLLOW UP CLOSED"
        case .closed: return "CLOSED"
        case .suggestedTimePending: return "SUGGESTED TIME PENDING"
        case .suggestedTimeAccepted: return "PAYMENT PENDING"
        case .callUnanswered: return "Call Unanswered"
        }
    }

    private func color(
        for phase: BookingPhase
    ) -> UIColor {

        switch phase {

        case .rejected, .paymentExpired:
            return .systemRed

        case .callStarted, .callEnded, .followUpStarted:
            return .systemPurple

        case .closed:
            return .systemGray
         case .callUnanswered:
            return UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
        //     return UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                // timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)

        default:
            return .systemBlue
        }
    }
}
