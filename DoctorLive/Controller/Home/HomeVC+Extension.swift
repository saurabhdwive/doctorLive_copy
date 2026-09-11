//
//  HomeVC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import UIKit

extension HomeVC: UITableViewDelegate{
/*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.bookingStatus {
        case .PENDING:
            if self.pendingAcceptedStatus == .PENDING {
                return self.pendingBookingData.Pending?.count ?? 0
            }else{
                return self.pendingBookingData.Accepted?.count ?? 0
            }
        case .UPCOMING:
            return self.upcomingBookingData.count
        case .PREVIOUS:
            if self.followUpPreviousStatus == .FOLLOW_UP{
                return self.previousBookingData.FollowUp?.count ?? 0
            }else{
                return self.previousBookingData.Previous?.count ?? 0
            }
        }
    }
*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allBookingData.count == 0 {
            if self.isDataFetched {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "No data available".localized()
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
            } else {
                tableView.backgroundView = nil
            }
            return 0
        } else {
            tableView.backgroundView = nil
            return self.allBookingData.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.allBookingData.count - 1
        if indexPath.row == lastElement && !self.isLoadingList && !self.isLastPage {
            // Outer pagination: only trigger if we have a full page (multiple of pageLimit)
            if self.allBookingData.count % self.pageLimit == 0 {
                self.currentPage += 1
                self.performAllBooking(isRefresh: false)
            }
        }
    }
    
}

extension HomeVC: UITableViewDataSource {
/*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.bookingStatus{
        case .PENDING:
            let cell = self.bookingTblVw.dequeueReusableCell(withIdentifier: PendingHomeCell.className)as! PendingHomeCell
            if self.pendingAcceptedStatus == .PENDING {
                cell.patientNameLbl.text = self.pendingBookingData.Pending?[indexPath.row].patientName ?? EMPTY
                cell.dateLbl.text = self.pendingBookingData.Pending?[indexPath.row].Date ?? EMPTY
                cell.yearGenderLbl.text = "\(self.pendingBookingData.Pending?[indexPath.row].age ?? EMPTY) yrs, \(self.setUpGender(gender: self.pendingBookingData.Pending?[indexPath.row].gender ?? EMPTY))"
                cell.acceptBtn.isHidden = false
                cell.swapBtn.isHidden = false
            }else{
                cell.patientNameLbl.text = self.pendingBookingData.Accepted?[indexPath.row].patientName ?? EMPTY
                cell.dateLbl.text = self.pendingBookingData.Accepted?[indexPath.row].Date ?? EMPTY
                cell.yearGenderLbl.text = "\(self.pendingBookingData.Accepted?[indexPath.row].age ?? EMPTY) yrs, \(self.setUpGender(gender: self.pendingBookingData.Accepted?[indexPath.row].gender ?? EMPTY))"
                cell.acceptBtn.isHidden = true
                cell.swapBtn.isHidden = true
            }
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTap), for: .touchUpInside)
            cell.swapBtn.tag = indexPath.row
            cell.swapBtn.addTarget(self, action: #selector(swapBtnTap), for: .touchUpInside)
            cell.reasonForCallBtn.tag = indexPath.row
            cell.reasonForCallBtn.addTarget(self, action: #selector(reasonForCallBtnTap), for: .touchUpInside)
            return cell
        case .UPCOMING:
            let cell = self.bookingTblVw.dequeueReusableCell(withIdentifier: UpcomingHomeCell.className)as! UpcomingHomeCell
            cell.patientNameLbl.text = self.upcomingBookingData[indexPath.row].patientName ?? EMPTY
            cell.dateLbl.text = self.upcomingBookingData[indexPath.row].date ?? EMPTY
            cell.yearGenderLbl.text = "\(self.upcomingBookingData[indexPath.row].age ?? EMPTY) yrs, \(self.setUpGender(gender: self.upcomingBookingData[indexPath.row].gender ?? EMPTY))"
            if self.upcomingBookingData[indexPath.row].chatCount ?? "0" == "0"{
                cell.chatBtn.setTitle("Chat", for: .normal)
            }else{
                cell.chatBtn.setTitle("Chat(\(self.upcomingBookingData[indexPath.row].chatCount ?? "0"))", for: .normal)
            }
            cell.videoCallBtn.tag = indexPath.row
            cell.videoCallBtn.addTarget(self, action: #selector(videoCallBtnTap), for: .touchUpInside)
            cell.chatBtn.tag = indexPath.row
            cell.chatBtn.addTarget(self, action: #selector(chatBtnTap), for: .touchUpInside)
            cell.reasonForCallBtn.tag = indexPath.row
            cell.reasonForCallBtn.addTarget(self, action: #selector(reasonForCallBtnTap), for: .touchUpInside)
            return cell
        case .PREVIOUS:
            let cell = self.bookingTblVw.dequeueReusableCell(withIdentifier: PreviousHomeCell.className)as! PreviousHomeCell
            if self.followUpPreviousStatus == .FOLLOW_UP{
                cell.patientNameLbl.text = self.previousBookingData.FollowUp?[indexPath.row].patientName ?? EMPTY
                cell.dateLbl.text = self.previousBookingData.FollowUp?[indexPath.row].date ?? EMPTY
                cell.yearGenderLbl.text = "\(self.previousBookingData.FollowUp?[indexPath.row].age ?? EMPTY) yrs, \(self.setUpGender(gender: self.previousBookingData.FollowUp?[indexPath.row].gender ?? EMPTY))"
                cell.followUpLbl.text = self.previousBookingData.FollowUp?[indexPath.row].followUpDate ?? EMPTY
                cell.priceLbl.text = "৳\(self.previousBookingData.FollowUp?[indexPath.row].price ?? EMPTY)"
                cell.FollowUpTxt.isHidden = false
                cell.followUpLbl.isHidden = false
                cell.statusLbl.isHidden = true
               if self.previousBookingData.FollowUp?[indexPath.row].bookingStatus ?? EMPTY == "Past Booking"{
                    cell.chatBtn.isHidden = false
                    cell.prescriptionBtn.isHidden = false
                }else{
                    cell.chatBtn.isHidden = true
                    cell.prescriptionBtn.isHidden = true
                }
                //Reject, Bypass, Cancel, bypass_link
                if self.previousBookingData.FollowUp?[indexPath.row].prescription ?? EMPTY == EMPTY {
                    cell.prescriptionBtn.backgroundColor = UIColor.lightGray
                }else{
                    cell.prescriptionBtn.backgroundColor = UIColor(named: "ButtonBlueColor")
                }
                if self.previousBookingData.FollowUp?[indexPath.row].chatCount ?? EMPTY == "0" {
                    cell.chatBtn.setTitle("Chat", for: .normal)
                }else{
                    cell.chatBtn.setTitle("Chat(\(self.previousBookingData.FollowUp?[indexPath.row].chatCount ?? EMPTY))", for: .normal)
                }
            }else{
                cell.patientNameLbl.text = self.previousBookingData.Previous?[indexPath.row].patientName ?? EMPTY
                cell.dateLbl.text = self.previousBookingData.Previous?[indexPath.row].date ?? EMPTY
                cell.yearGenderLbl.text = "\(self.previousBookingData.Previous?[indexPath.row].age ?? EMPTY) yrs, \(self.setUpGender(gender: self.previousBookingData.Previous?[indexPath.row].gender ?? EMPTY))"
                cell.priceLbl.text = "৳\(self.previousBookingData.Previous?[indexPath.row].price ?? EMPTY)"
                cell.FollowUpTxt.isHidden = true
                cell.followUpLbl.isHidden = true
                cell.statusLbl.isHidden = false
                if self.previousBookingData.Previous?[indexPath.row].bookingStatus ?? EMPTY == "Cancel"{
                    cell.statusLbl.text = "Cancelled"
                    cell.statusLbl.textColor = .red
                    cell.chatBtn.isHidden = true
                    cell.prescriptionBtn.isHidden = true
                }else if self.previousBookingData.Previous?[indexPath.row].bookingStatus ?? EMPTY == "Reject"{
                    cell.statusLbl.text = "Rejected"
                    cell.statusLbl.textColor = .red
                    cell.chatBtn.isHidden = true
                    cell.prescriptionBtn.isHidden = true
                }else if self.previousBookingData.Previous?[indexPath.row].bookingStatus ?? EMPTY == "Past Booking"{
                    cell.statusLbl.text = "Completed"
                    cell.statusLbl.textColor = .systemGreen
                    cell.chatBtn.isHidden = false
                    cell.prescriptionBtn.isHidden = false
                }else{
                    cell.statusLbl.isHidden = false
                    cell.chatBtn.isHidden = true
                    cell.prescriptionBtn.isHidden = true
                    cell.statusLbl.text = "ByPass"
                    cell.statusLbl.textColor = .systemGreen
                }
                //Reject, Bypass, Cancel, bypass_link
                if self.previousBookingData.Previous?[indexPath.row].prescription ?? EMPTY == EMPTY {
                    cell.prescriptionBtn.backgroundColor = UIColor.lightGray
                }else{
                    cell.prescriptionBtn.backgroundColor = UIColor(named: "ButtonBlueColor")
                }
                
                if self.previousBookingData.Previous?[indexPath.row].chatCount ?? EMPTY == "0" {
                    cell.chatBtn.setTitle("Chat", for: .normal)
                }else{
                    cell.chatBtn.setTitle("Chat(\(self.previousBookingData.Previous?[indexPath.row].chatCount ?? EMPTY))", for: .normal)
                }
            }
            cell.chatBtn.tag = indexPath.row
            cell.chatBtn.addTarget(self, action: #selector(chatBtnPreviousTap), for: .touchUpInside)
            cell.prescriptionBtn.tag = indexPath.row
            cell.prescriptionBtn.addTarget(self, action: #selector(prescriptionBtnTap), for: .touchUpInside)
            cell.reasonForCallBtn.tag = indexPath.row
            cell.reasonForCallBtn.addTarget(self, action: #selector(reasonForCallBtnTap), for: .touchUpInside)
            return cell
        }
    }
*/

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = self.allBookingData[indexPath.row]
        let patientId = group.patientId ?? ""
        let patientName = group.patientName ?? ""
        let calls = group.call ?? []
        let bookings: [Booking] = calls.map { $0.toBooking() }
        let isExpanded = self.expandedPatientIds.contains(patientId)
        
        let cell = self.bookingTblVw.dequeueReusableCell(
            withIdentifier: DoctorCardTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! DoctorCardTableViewCell
        
        cell.configure(
            doctorName: patientName,
            specialty: group.gender.flatMap { $0 == "m" ? "Male" : $0 == "f" ? "Female" : "" } ?? "",
            bookings: bookings,
            expanded: isExpanded
        )
        
        // Chat button (header): open chat using the most recent booking
        cell.onChat = { [weak self] in
            guard let self = self else { return }
            guard let firstCall = calls.first else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatViewC.className) as! ChatViewC
            vc.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
            vc.recieverId = firstCall.userId ?? ""
            vc.roomId = firstCall.id ?? ""
            vc.profilePic = ""
            vc.patientName = firstCall.memberName ?? patientName
            vc.sinchToken = firstCall.devicetoken ?? ""
            vc.userId = firstCall.userId ?? ""
            vc.bookingId = firstCall.id ?? ""
            vc.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // Booking row tap: open ChatViewC for that specific booking
        cell.onBookingTap = { [weak self] booking in
            guard let self = self else { return }
            // Find the matching PastCall by bookingId to get full data
            let matchedCall = calls.first { $0.id == booking.id }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatViewC.className) as! ChatViewC
            vc.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
            vc.recieverId = matchedCall?.userId ?? ""
            vc.roomId = booking.id
            vc.profilePic = ""
            vc.patientName = matchedCall?.memberName ?? patientName
            vc.sinchToken = matchedCall?.devicetoken ?? ""
            vc.userId = matchedCall?.userId ?? ""
            vc.bookingId = booking.id
            vc.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // Expand/collapse: ask tableView to recalculate heights
        cell.onToggleExpand = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            if cell.isExpanded {
                self.expandedPatientIds.insert(patientId)
            } else {
                self.expandedPatientIds.remove(patientId)
            }
            self.bookingTblVw.beginUpdates()
            self.bookingTblVw.endUpdates()
        }
        
        // Inner Load More: fetch next booking_page for this patient
        cell.onLoadMore = { [weak self] in
            guard let self = self else { return }
            self.performInnerBooking(patientId: patientId)
        }
        
        return cell
    }
}

//


final class DoctorCardTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DoctorCardTableViewCell"

    // MARK: - Callbacks

    var onChat: (() -> Void)?
    var onToggleExpand: (() -> Void)?
    var onLoadMore: (() -> Void)?
    var onBookingTap: ((Booking) -> Void)?

    // MARK: - State

    private(set) var isExpanded = false
    private var bookings: [Booking] = []

    // MARK: - UI

    private let cardView = UIView()

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
        setupAvatar()
        setupLabels()
        setupButtons()
        setupBookingsStack()
        setupLoadMoreButton()
        setupConstraints()
    }

    // MARK: - Card

    private func setupCard() {

        cardView.backgroundColor = .white

        cardView.layer.cornerRadius = 18

        cardView.layer.shadowColor =
            UIColor.black.cgColor

        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(
            width: 0,
            height: 3
        )

        contentView.addSubview(cardView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Avatar

    private func setupAvatar() {

        avatarView.layer.cornerRadius = 25
        avatarView.clipsToBounds = true

        // Approximation of SwiftUI:
        // LinearGradient(.blue -> .indigo)
        avatarView.backgroundColor = .systemBlue

        cardView.addSubview(avatarView)

        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        initialsLabel.textColor = .white
        initialsLabel.font = .boldSystemFont(ofSize: 16)
        initialsLabel.textAlignment = .center

        avatarView.addSubview(initialsLabel)

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Labels

    private func setupLabels() {

        specialtyLabel.font = .boldSystemFont(ofSize: 11)
        specialtyLabel.textColor = .systemGreen

        doctorNameLabel.font = .boldSystemFont(ofSize: 17)
        doctorNameLabel.textColor = .label

        bookingCountLabel.font =
            .systemFont(
                ofSize: 12,
                weight: .medium
            )

        bookingCountLabel.textColor = UIColor(red: 92/255, green: 107/255, blue: 130/255, alpha: 1)

        cardView.addSubview(specialtyLabel)
        cardView.addSubview(doctorNameLabel)
        cardView.addSubview(bookingCountLabel)

        specialtyLabel.translatesAutoresizingMaskIntoConstraints = false
        doctorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bookingCountLabel.translatesAutoresizingMaskIntoConstraints = false

        timerPillView.backgroundColor = UIColor(red: 254/255, green: 246/255, blue: 231/255, alpha: 1)
        timerPillView.layer.cornerRadius = 14
        
        timerPillLabel.font = .boldSystemFont(ofSize: 12)
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
        chatConfig.baseBackgroundColor =  UIColor(named: "ButtonBlueColor") ?? .systemBlue

        chatConfig.title = "Chat"
        chatConfig.image = UIImage(
            systemName: "message.fill"
        )

        chatConfig.imagePadding = 6
        chatConfig.cornerStyle = .medium

        chatButton.configuration = chatConfig

        chatButton.addTarget(
            self,
            action: #selector(chatTapped),
            for: .touchUpInside
        )

        var expandConfig =
            UIButton.Configuration.bordered()
        expandConfig.baseForegroundColor =  UIColor(named: "ButtonBlueColor") ?? .systemBlue

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
                equalTo: cardView.trailingAnchor,
                constant: -16
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
                equalTo: cardView.leadingAnchor,
                constant: 16
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
        expanded: Bool
    ) {

        self.isExpanded = expanded
        self.bookings = bookings

        doctorNameLabel.text = doctorName

        specialtyLabel.text =
            specialty.uppercased()

        if bookings.isEmpty {

            bookingCountLabel.isHidden = true

        } else {

            bookingCountLabel.isHidden = false

            let count = bookings.count

            bookingCountLabel.text =
                "\(count) booking\(count == 1 ? "" : "s")"
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
        expanded: Bool
    ) {
        configure(
            doctorName: doctorName,
            specialty: specialty,
            imageUrl: nil,
            bookings: bookings,
            expanded: expanded
        )
    }

    // MARK: - Bookings
    private var countdownTimer: Timer?
    private var targetDate: Date?

//    private func updateBookings(
//        _ bookings: [Booking]
//    ) {
//
//        bookingsStackView.arrangedSubviews.forEach {
//            $0.removeFromSuperview()
//        }
//
//        bookingsStackView.isHidden =
//            !isExpanded || bookings.isEmpty
//
//        countdownTimer?.invalidate()
//        countdownTimer = nil
//
//        // Timer pill visibility
//        if let first = bookings.first, (first.status == .requested || first.status == .paymentPending || first.status == .paymentCompleted) {
//            if first.status == .requested {
//                timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
//                timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
//             } else if first.status == .paymentPending {
//                 timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
//                 timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
//             }else if first.status == .paymentCompleted {
//                 timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
//                 timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
//                
//            }
//            let tenMins: TimeInterval = 10 * 60
//            let target = first.date.addingTimeInterval(tenMins)
//            
//            if Date() < target {
//                timerPillView.isHidden = false
//                timerPillTopConstraint.constant = 10
//                timerPillHeightConstraint.constant = 28
//                chatBtnTopConstraint.constant = 12
//                self.targetDate = target
////                updateTimerLabel()
//                    updateTimerLabel()
//                countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
//                RunLoop.current.add(countdownTimer!, forMode: .common)
//            } else {
//                hideTimerPill()
//            }
//        } else {
//            hideTimerPill()
//        }
//
//        bottomConstraint?.isActive = false
//        if !isExpanded || bookings.isEmpty {
//            bottomConstraint = chatButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
//        } else if loadMoreButton.isHidden {
//            bottomConstraint = bookingsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
//        } else {
//            bottomConstraint = loadMoreButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
//        }
//        bottomConstraint?.isActive = true
//
//        // Show Load More button only when expanded, non-empty, and count is a multiple of 10
//        loadMoreButton.isHidden = !isExpanded || bookings.isEmpty || bookings.count % 10 != 0
//
//        guard isExpanded else {
//            return
//        }
//
//        for booking in bookings {
//
//            let bookingView =
//                BookingRowView()
//
//            bookingView.configure(
//                booking: booking
//            )
//
//            bookingView.onTap = { [weak self] in
//                self?.onBookingTap?(booking)
//            }
//
//            bookingsStackView.addArrangedSubview(
//                bookingView
//            )
//        }
//    }
    
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

        // Timer pill visibility
/*
        if let first = bookings.first, (first.status == .requested || first.status == .paymentPending || first.status == .paymentCompleted) {
            if first.status == .requested {
                timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
             } else if first.status == .paymentPending {
                 timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                 timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
             }else if first.status == .paymentCompleted {
                 timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                 timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                
            }
            let tenMins: TimeInterval = 10 * 60
            let target = first.date.addingTimeInterval(tenMins)
            
            if Date() < target {
                timerPillView.isHidden = false
                timerPillTopConstraint.constant = 10
                timerPillHeightConstraint.constant = 28
                chatBtnTopConstraint.constant = 12
                self.targetDate = target
//                updateTimerLabel()
                    updateTimerLabel()
                countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
                RunLoop.current.add(countdownTimer!, forMode: .common)
            } else {
                hideTimerPill()
            }
        } else {
            hideTimerPill()
        }
*/
        
        if let first = bookings.first {
            switch first.status {
            case .requested, .paymentPending, .paymentCompleted:
                if first.status == .requested {
                    timerPillView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
                } else if first.status == .paymentPending {
                    timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                } else if first.status == .paymentCompleted {
                    timerPillView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                    timerPillLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                }
                
                let tenMins: TimeInterval = 10 * 60
                let target = first.date.addingTimeInterval(tenMins)
                
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
                showTimerPill(text: "✅ Call ended — awaiting summary")
                
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
                
            case .paymentExpired:
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerPillView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                timerPillLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                showTimerPill(text: "⏱ Payment window expired")
                        
            case .prescriptionSent:
                let oneDay: TimeInterval = 2 * 60 * 60
                let target = first.date.addingTimeInterval(oneDay)
                
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

            bookingsStackView.addArrangedSubview(
                bookingView
            )
        }
    }

    // MARK: - Actions

    @objc private func updateTimerLabel() {
//        guard let target = targetDate else { return }
//        let remaining = target.timeIntervalSince(Date())
//        if remaining > 0 {
//            let mins = Int(remaining) / 60
//            let secs = Int(remaining) % 60
//            var label = ""
//            if bookings.first?.status == .requested {
//                label = "⏱ Waiting for Doctor"
//             } else if bookings.first?.status == .paymentPending {
//                label = "⏱ Pay within"
//             }else if bookings.first?.status == .paymentCompleted {
//                label = "📞 Waiting for Call"
//             }
//            timerPillLabel.text = String(format: "\(label) · %02d:%02d", mins, secs)
//        } else {
//            countdownTimer?.invalidate()
//            countdownTimer = nil
//            hideTimerPill()
//        }
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
                   timerPillView.backgroundColor = UIColor(red: 239/255, green: 248/255, blue: 255/255, alpha: 1)
                   timerPillLabel.textColor = UIColor(red: 23/255, green: 92/255, blue: 211/255, alpha: 1)
                   timerPillLabel.text = String(format: "⏳ Follow-up valid for · %02dh %02dm", hours, mins)
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
                   } else if first.status == .paymentPending {
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

final class BookingRowView: UIView {

    // Called when the user taps this booking row
    var onTap: (() -> Void)?

    private let containerView = UIView()

    private let dateLabel = UILabel()
    private let timeLabel = UILabel()

    private let statusPill = StatusPillView()

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

        containerView.backgroundColor =
            .systemGroupedBackground

        containerView.layer.cornerRadius = 12

        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

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
                equalToConstant: 58
            )
        ])

        dateLabel.font =
            .systemFont(
                ofSize: 13,
                weight: .medium
            )

        dateLabel.textColor =
            .secondaryLabel

        timeLabel.font =
            .boldSystemFont(ofSize: 15)

        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(statusPill)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusPill.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            dateLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 12
            ),

            dateLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 7
            ),

            timeLabel.leadingAnchor.constraint(
                equalTo: dateLabel.leadingAnchor
            ),

            timeLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 2
            ),

            statusPill.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -12
            ),

            statusPill.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            )
        ])

        // Tap to open chat
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(rowTapped)
        )
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
    }

    @objc private func rowTapped() {
        onTap?()
    }

    func configure(
        booking: Booking
    ) {

        dateLabel.text =
        formattedDate(booking.date)

        timeLabel.text =
            booking.time

        statusPill.configure(
            phase: convertStatusToPhase(
                booking.status
            )
        )
    }

    private func formattedDate(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy"

        return formatter.string(
            from: date
        )
    }

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
            
        }
    }
}

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
    case .noResponse: return "NO_RESPONSE"
    case .rejected: return "REJECTED"
    case .cancelled: return "CANCELLED"
    case .paymentPending: return "PAYMENT_PENDING"
    case .paymentExpired: return "PAYMENT_EXPIRED"
    case .paymentCompleted: return "PAYMENT_COMPLETED"
    case .waitingForCall: return "WAITING_FOR_CALL"
    case .callStarted: return "CALL_STARTED"
    case .callEnded: return "CALL_ENDED"
    case .consultationCompleted: return "CONSULTATION_COMPLETED"
    case .prescriptionSent: return "PRESCRIPTION_SENT"
    case .followUpStarted: return "FOLLOW_UP_STARTED"
    case .followUpClosed: return "FOLLOW_UP_CLOSED"
    case .closed: return "CLOSED"
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

        default:
            return .systemBlue
        }
    }
}

