//
//  ChatViewC+Extension.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import Foundation
import AVKit
import UIKit
import SafariServices
import PromiseKit
import PhotosUI
import SDWebImage

extension ChatViewC: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.isFromPagination else { return }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 && scrollView.isDragging {
            if !self.isLoading && self.hasMoreData && self.chatData.count > 0 {
                self.currentPage += 1
                self.chatTblVw.tableHeaderView = self.paginationSpinner
                self.paginationSpinner.startAnimating()
                self.getChatHistry()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupByCategoryChat?[self.keys[section]]?.count ?? INTZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
         if chat?.msgType == "WAITING_FOR_CALL"{
             return 0
         }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
//        guard chat?.recieverType == "sender" else {
//            return nil
//        }
         if let historyType = chat?.historyType, (historyType == "booking_status" || historyType == "new_booking_request") {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
            guard let chatId = chat?.id, !chatId.isEmpty else {
                self.showToast(message: "Cannot delete this message")
                completionHandler(false)
                return
            }
            
            let popup = DeleteConfirmationPopupVC()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            popup.deleteAction = {
                self.deleteChatMessage(chatId: chatId, indexPath: indexPath)
            }
            self.present(popup, animated: true)
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension ChatViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.chatTblVw.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderCell.className)as! ChatHeaderCell
        let apiFormat = DateFormatter()
        apiFormat.dateFormat = "yyyy-MM-dd"
        if let d = apiFormat.date(from: self.keys[section]) {
            let displayFormat = DateFormatter()
            displayFormat.dateFormat = "dd-MMM-yyyy"
            header.DateLbl.text = displayFormat.string(from: d)
        } else {
            header.DateLbl.text = self.keys[section]
        }
        GlobalMethods.shared.provideCornerRadius(view: header.DateLbl, cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        return header
    }
    func AcceptRejectBooking(status:String){
        if self.isBookingActionInProgress { return }
        self.isBookingActionInProgress = true
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": bookingId ?? EMPTY,
                     "status": status,
                     "reason": ""]
        firstly {
            service!.bookingStatus(parameters: parameter, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.confirmBoking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                self.isBookingActionInProgress = false
                Indicator.shared.hideProgressView()
            }
        }
    }
    func confirmBoking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
            AppToast.showMessage(message: model.message ?? "")
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }

    func SuggestTimeBooking(date: String){
        if self.isBookingActionInProgress { return }
        self.isBookingActionInProgress = true
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        parameter = ["token": token,
                     "booking_id": bookingId ?? EMPTY,
                     "suggested_time": date]
        firstly {
            service!.suggestedTime(parameters: parameter, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.isBookingActionInProgress = false
            Indicator.shared.hideProgressView()
            self.confirmBoking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                self.isBookingActionInProgress = false
                Indicator.shared.hideProgressView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
        if let historyType = chat?.historyType, (historyType == "booking_status" || historyType == "new_booking_request") {
            switch chat?.msgType {
            case "REQUESTED":
                
                    let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                    containerCell.stackView.spacing = 8
                    
                    let dividerCell = ChatBookingDividerCell(style: .default, reuseIdentifier: nil)
                    let actualPatient = chat?.patientName ?? self.patientName ?? ""
                    let forText = (actualPatient == self.patientName || actualPatient.isEmpty) ? actualPatient : actualPatient
                    let title = "Booking #\(chat?.booking_number ?? chat?.bookingId ?? "") (for \(forText)) · \(chat?.booking_date ?? ""), \(chat?.booking_time ?? "")"
                    dividerCell.configure(title: title, icon: UIImage(systemName: "video"), isRedDot: true)
                    dividerCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        dividerCell.contentView.topAnchor.constraint(equalTo: dividerCell.topAnchor),
                        dividerCell.contentView.bottomAnchor.constraint(equalTo: dividerCell.bottomAnchor),
                        dividerCell.contentView.leadingAnchor.constraint(equalTo: dividerCell.leadingAnchor),
                        dividerCell.contentView.trailingAnchor.constraint(equalTo: dividerCell.trailingAnchor)
                    ])
                    containerCell.stackView.addArrangedSubview(dividerCell)

                    if chat?.is_status == "1" {
                    
                    let chipCell = ChatNewBookingRequestCell(style: .default, reuseIdentifier: nil)
                    chipCell.configure(patientName: actualPatient, fee: "৳\(chat?.fees ?? "0")")
                    chipCell.availableNowTapped = { [weak self] in
                        AppDelegate.shared.pushNotification?.stopCustomRingtone()
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        self?.AcceptRejectBooking(status: "1")
                    }
                    chipCell.rejectTapped = { [weak self] in
                        AppDelegate.shared.pushNotification?.stopCustomRingtone()
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        self?.AcceptRejectBooking(status: "2")
                    }
                    chipCell.suggestTimeTapped = { [weak self] dateStr in
                        AppDelegate.shared.pushNotification?.stopCustomRingtone()
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        self?.SuggestTimeBooking(date: dateStr)
                    }
                    
                    chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                        chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                        chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                        chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                    ])
                    containerCell.stackView.addArrangedSubview(chipCell) // Append it
                }
                return containerCell
            case "NO_RESPONSE", "PAYMENT_EXPIRED":
                // 1. Dequeue the generic dynamic stack cell
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                // 2. Instantiate and configure the first cell
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = chat?.msgType == "NO_RESPONSE" ? "⏱ Doctor Did Not Respond" : "⏱ Payment Window Expired"
                chipCell.configure(type: chat?.msgType ?? "")
                 // Fix for UIStackView overlap: Constrain contentView to the cell itself
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                // 3. Instantiate and configure the second cell
                let cardCell = ChatStageChipCell2(style: .default, reuseIdentifier: nil)
                cardCell.titleLabel.text =  chat?.msgType == "NO_RESPONSE" ? "Unfortunately, the doctor was unable to respond to your request." : "Patient did not complete payment in time — booking closed automatically."
                cardCell.configure(type: chat?.msgType ?? "")
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(cardCell) // Append it
                return containerCell
            case "REJECTED" ,"CANCELLED":
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell") as! ChatStageChipCell
                cell.titleLabel.text =  chat?.msgType == "REJECTED" ?  "X Booking Rejected" : "X Booking Cancelled"
                cell.configure(type: chat?.msgType ?? "")
                return cell
            case "REMINDER":
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell2") as! ChatStageChipCell2
                cell.titleLabel.text = chat?.message ?? ""
                cell.configure(type: chat?.msgType ?? "")
                return cell
            case "SUGGESTED_TIME_PENDING":
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell2") as! ChatStageChipCell2
                cell.titleLabel.text = "You suggested a new time to the patient."
                cell.configure(type: chat?.msgType ?? "")
                return cell
            case "SUGGESTED_TIME_ACCEPTED":
                // 1. Dequeue the generic dynamic stack cell
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                // 2. Instantiate and configure the first cell
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = "🕐 Time Accepted"
                chipCell.configure(type: chat?.msgType ?? "")
                
                // Fix for UIStackView overlap: Constrain contentView to the cell itself
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                // 3. Instantiate and configure the second cell
                let cardCell = ChatStageChipCell2(style: .default, reuseIdentifier: nil)
                cardCell.titleLabel.text =  "💬 Patient has been asked to complete payment. You can send a reminder from chat."
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(cardCell) // Append it
                return containerCell
            case "PAYMENT_PENDING":
                // 1. Dequeue the generic dynamic stack cell
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                // 2. Instantiate and configure the first cell
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                var feesText = ""
                if let feesStr = chat?.fees, let feesValue = Double(feesStr) {
                    feesText = feesValue.truncatingRemainder(dividingBy: 1) == 0 ? " (৳\(Int(feesValue)))" : " (৳\(feesStr))"
                }
                chipCell.titleLabel.text = "✅ Doctor Accepted\(feesText)"
                chipCell.configure(type: chat?.msgType ?? "")
                
                // Fix for UIStackView overlap: Constrain contentView to the cell itself
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                // 3. Instantiate and configure the second cell
                let cardCell = ChatStageChipCell2(style: .default, reuseIdentifier: nil)
                cardCell.titleLabel.text =  "💬 Patient has been asked to complete payment. You can send a reminder from chat."
                cardCell.configure(type: chat?.msgType ?? "")
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(cardCell) // Append it
                return containerCell
                
                //            case "payment_reminder":
                //                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell2") as! ChatStageChipCell2
                //                cell.titleLabel.text = "® Patient has been asked to complete payment.You can send a reminder from chat."
                //                cell.configure(type: chat?.msgType ?? "")
                //                return cell
            case "PAYMENT_COMPLETED":
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = "💴Payment Done"
                chipCell.configure(type: chat?.msgType ?? "")
                
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                let cardCell = ChatStageChipCell2(style: .default, reuseIdentifier: nil)
                cardCell.titleLabel.text = "💰 Payment received. Patient is ready for consultation."
                cardCell.configure(type: chat?.msgType ?? "")
                
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                
                if chat?.is_status == "1"{
                    containerCell.stackView.addArrangedSubview(cardCell) // Append it
                    let consultationCell = ChatActionCardCell(style: .default, reuseIdentifier: nil)
                    consultationCell.titleLabel.text = "Ready to start the consultation?"
                    
                    if let bDate = chat?.booking_date, let bTime = chat?.booking_time, !bDate.isEmpty, !bTime.isEmpty {
                        consultationCell.subLabel.text = "Patient has paid and is waiting.\nBooking Date: \(bDate) Time: \(bTime)"
                    } else {
                        consultationCell.subLabel.text = "Patient has paid and is waiting."
                    }
                    consultationCell.actionBtn.setTitle("📞 Call Now", for: .normal)
                    consultationCell.actionBtnTapped = { [weak self] in
                        self?.emitBookingStatusData(bookingStatus: "CALL_STARTED")
                        if let _ = self?.findVideoCallController() {
                            AppToast.showMessage(message: "Video call is already in progress")
                        }else{
                            self?.getToken()
                        }
                    }
                    consultationCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        consultationCell.contentView.topAnchor.constraint(equalTo: consultationCell.topAnchor),
                        consultationCell.contentView.bottomAnchor.constraint(equalTo: consultationCell.bottomAnchor),
                        consultationCell.contentView.leadingAnchor.constraint(equalTo: consultationCell.leadingAnchor),
                        consultationCell.contentView.trailingAnchor.constraint(equalTo: consultationCell.trailingAnchor)
                    ])
                    containerCell.stackView.addArrangedSubview(consultationCell) // Append it
                }
                return containerCell
                
            case "CALL_STARTED":
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = "Video Call Started"
                chipCell.configure(type: chat?.msgType ?? "")
                
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                // let cardCell = ChatVideoCallBadgeCell(style: .default, reuseIdentifier: nil)
                // if chat?.is_status == "1" {
                //     // let callStartDate = Booking.parseDate(dateStr: nil, createdOn: chat?.createdOn)
                //     // cardCell.startTimer(with: callStartDate)
                //     //  cardCell.stopTimer()
                //     // cardCell.timeLabel.text = "Call in progress"
                //     let callStartDate = Booking.parseDate(dateStr: nil, createdOn: chat?.createdOn)
                //     cardCell.startTimer(with: callStartDate)
                // } else {
                //     var durationText = "00:00"
                //     if let startStr = chat?.createdOn,
                //        let endMsg = self.chatData.first(where: { $0.msgType == "CALL_ENDED" && ($0.createdOn ?? "") >= startStr }),
                //        let endStr = endMsg.createdOn {
                //         let startDate = Booking.parseDate(dateStr: nil, createdOn: startStr)
                //         let endDate = Booking.parseDate(dateStr: nil, createdOn: endStr)
                //         let duration = Int(endDate.timeIntervalSince(startDate))
                //         if duration >= 0 {
                //             let mins = duration / 60
                //             let secs = duration % 60
                //             durationText = String(format: "%02d:%02d", mins, secs)
                //         }
                //     }
                //     cardCell.stopTimer(with: durationText)
                // }
                
                // cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                // NSLayoutConstraint.activate([
                //     cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                //     cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                //     cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                //     cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                // ])
                // containerCell.stackView.addArrangedSubview(cardCell) // Append it
                return containerCell
                
            case "CALL_UNANSWERED":
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = "📹 Video Call Unanswered"
                chipCell.configure(type: chat?.msgType ?? "")
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                return containerCell
                
            case "CALL_ENDED":
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                
                var callDurationText = "0 min 0 sec"
                if let endStr = chat?.createdOn,
                   let startMsg = self.chatData.last(where: { $0.msgType == "CALL_STARTED" && ($0.createdOn ?? "") <= endStr }),
                   let startStr = startMsg.createdOn {
                    let endDate = Booking.parseDate(dateStr: nil, createdOn: endStr)
                    let startDate = Booking.parseDate(dateStr: nil, createdOn: startStr)
                    let duration = Int(endDate.timeIntervalSince(startDate))
                    if duration >= 0 {
                        let mins = duration / 60
                        let secs = duration % 60
                        callDurationText = "\(mins) min \(secs) sec"
                    }
                }
                chipCell.titleLabel.text = "📹 Video Call Ended - \(callDurationText)"
                chipCell.configure(type: chat?.msgType ?? "")
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                if chat?.is_status == "1"{
                    
                    let ConsultationCell = ChatActionCardCell(style: .default, reuseIdentifier: nil)
                    ConsultationCell.titleLabel.text = "Consultation finished?"
                    ConsultationCell.subLabel.text = "Confirm to start the follow-up window and enable the prescription."
                    ConsultationCell.actionBtn.setTitle("✅ Complete Consultation", for: .normal)
                    ConsultationCell.actionBtnTapped = {[weak self] in
                        Indicator.shared.showProgressView(self?.view ?? UIView())
//                        self?.emitBookingStatusData(bookingStatus: "CONSULTATION_COMPLETED")
                        self?.performEndCall(bookingId: self?.bookingId ?? "", reason: EMPTY,status:"4")
                    }
                    ConsultationCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        ConsultationCell.contentView.topAnchor.constraint(equalTo: ConsultationCell.topAnchor),
                        ConsultationCell.contentView.bottomAnchor.constraint(equalTo: ConsultationCell.bottomAnchor),
                        ConsultationCell.contentView.leadingAnchor.constraint(equalTo: ConsultationCell.leadingAnchor),
                        ConsultationCell.contentView.trailingAnchor.constraint(equalTo: ConsultationCell.trailingAnchor)
                    ])
                    containerCell.stackView.addArrangedSubview(ConsultationCell)
                }
                return containerCell
                
            case "CONSULTATION_COMPLETED":
                 let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = "✅ Consultation Done"
                chipCell.configure(type: chat?.msgType ?? "")
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                if chat?.is_status == "1"{
                     let ConsultationCell = ChatActionCardCell(style: .default, reuseIdentifier: nil)
                    ConsultationCell.titleLabel.text = "Consultation completed"
                    ConsultationCell.subLabel.text = "Write and send the prescription to finish this consultation."
                    ConsultationCell.actionBtn.setTitle("📝 Prescribe Now", for: .normal)
                    ConsultationCell.actionBtnTapped = {[weak self] in
                        //                    Indicator.shared.showProgressView(self?.view ?? UIView())
                        //                    self?.emitBookingStatusData(bookingStatus: "PRESCRIPTION_SENT")
                        let viewC = PrescriptionViewController()
                        viewC.isComingFromChat = true
                        viewC.bookingId = self?.roomId ?? ""
                        self?.navigationController?.pushViewController(viewC, animated: true)
                    }
                    ConsultationCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        ConsultationCell.contentView.topAnchor.constraint(equalTo: ConsultationCell.topAnchor),
                        ConsultationCell.contentView.bottomAnchor.constraint(equalTo: ConsultationCell.bottomAnchor),
                        ConsultationCell.contentView.leadingAnchor.constraint(equalTo: ConsultationCell.leadingAnchor),
                        ConsultationCell.contentView.trailingAnchor.constraint(equalTo: ConsultationCell.trailingAnchor)
                    ])
                    containerCell.stackView.addArrangedSubview(ConsultationCell)
                }
                return containerCell
             case "PRESCRIPTION_SENT":
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                
                let chipCell = ChatBookingSummaryCardCell(style: .default, reuseIdentifier: nil)
                chipCell.iconLabel.text = "📄"
//                chipCell.iconView.image = UIImage(systemName: "document")
                chipCell.titleLabel.text = "Prescription sent"
                chipCell.subLabel.text = "Your prescription is ready to view."
                chipCell.expandLabel.text = "View"
//                chipCell.expandLabel2.isHidden = true
                chipCell.expandLabel2.text = "Save"
                chipCell.expandTapped = { [weak self] in
                    if let urlStr = chat?.prescription_url, !urlStr.isEmpty {
                        //                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PrescriptionVC") as! PrescriptionViewVC
                        //                        vc.fileImag = urlStr
                        //                        vc.filepdf = urlStr
                        //                        vc.titleText = "Prescription"
                        //                        self?.navigationController?.pushViewController(vc, animated: true)
                        let vc = PrescriptionViewVC()
                        vc.comeFromChat = true
                        vc.urlString = urlStr
                        //                        vc.titleString = "Prescription"
                        self?.navigationController?.pushViewController(vc, animated: true)
                        //                    }
                    }
                }
                chipCell.expand2Tapped = { [weak self] in
                    if let urlStr = chat?.prescription_url, let url = URL(string: urlStr) {
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            DispatchQueue.main.async {
                                Indicator.shared.hideProgressView()
                                guard let data = data, error == nil else {
                                    self?.showToast(message: "Download failed")
                                    return
                                }
                                
                                if let image = UIImage(data: data) {
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                    self?.showToast(message: "Image saved to Photos")
                                } else {
                                    let fileName = response?.suggestedFilename ?? url.lastPathComponent
                                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName.isEmpty ? "Prescription.pdf" : fileName)
                                    do {
                                        try data.write(to: tempURL)
                                        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                                        self?.present(activityVC, animated: true)
                                    } catch {
                                        self?.showToast(message: "Failed to save file")
                                    }
                                }
                            }
                        }.resume()
                    }
                }
                
                chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                    chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                    chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                    chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
//                let cardCell = ChatBookingSummaryCardCell(style: .default, reuseIdentifier: nil)
//                cardCell.titleLabel.text = "Patient rating"
//                cardCell.subLabel.text = "Awaiting rating from Rina Akter..."
//                cardCell.expandLabel.text = ""
                let cardCell = ChatRatingCardCell(style: .default, reuseIdentifier: nil)
                if chat?.rating ?? "" != "" {
                    cardCell.titleLabel.text = "Patient rating"
                    cardCell.subLabel.text = "\(patientName ?? "") rated this consultation"
                     cardCell.starsStackView.isHidden = false
                     if let ratingStr = chat?.rating, let ratingValue = Int(ratingStr) {
                         for (index, view) in cardCell.starsStackView.arrangedSubviews.enumerated() {
                            if let btn = view as? UIButton {
                                let imageName = (index < ratingValue) ? "star.fill" : "star"
                                let color = (index < ratingValue) ? UIColor.systemYellow : UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
                                btn.setImage(UIImage(systemName: imageName), for: .normal)
                                btn.tintColor = color
                            }
                        }
                    }
                } else {
                    cardCell.titleLabel.text = "Patient rating"
                    cardCell.subLabel.text = "Awaiting rating from \(patientName ?? "")"
                    cardCell.starsStackView.isHidden = false
                }
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(cardCell) // Append it
                
                let followUpChatCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                followUpChatCell.titleLabel.text = "💬 Followup Chat"
                followUpChatCell.configure(type: chat?.msgType ?? "")
                
                followUpChatCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    followUpChatCell.contentView.topAnchor.constraint(equalTo: followUpChatCell.topAnchor),
                    followUpChatCell.contentView.bottomAnchor.constraint(equalTo: followUpChatCell.bottomAnchor),
                    followUpChatCell.contentView.leadingAnchor.constraint(equalTo: followUpChatCell.leadingAnchor),
                    followUpChatCell.contentView.trailingAnchor.constraint(equalTo: followUpChatCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(followUpChatCell) // Append it
                
                return containerCell
                
            case "CLOSED":
//                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell") as! ChatStageChipCell
//                cell.titleLabel.text = "🔒 Chat Closed"
//                cell.configure(type: chat?.msgType ?? "")
//                return cell
                
            let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
               containerCell.stackView.spacing = 8
               
               let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
               chipCell.titleLabel.text = "🔒 Chat Closed"
               chipCell.configure(type: chat?.msgType ?? "")
               chipCell.contentView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   chipCell.contentView.topAnchor.constraint(equalTo: chipCell.topAnchor),
                   chipCell.contentView.bottomAnchor.constraint(equalTo: chipCell.bottomAnchor),
                   chipCell.contentView.leadingAnchor.constraint(equalTo: chipCell.leadingAnchor),
                   chipCell.contentView.trailingAnchor.constraint(equalTo: chipCell.trailingAnchor)
               ])
               containerCell.stackView.addArrangedSubview(chipCell) // Append it
                
                let cardCell = ChatStageChipCell2(style: .default, reuseIdentifier: nil)
                cardCell.titleLabel.text = "Patient chat is closed. You can still send a message — it will be visible as read-only until they book again."
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                   NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                   ])
                   containerCell.stackView.addArrangedSubview(cardCell)
                
                let chipCell2 = ChatStageChipCell3(style: .default, reuseIdentifier: nil)
                chipCell2.titleLabel.text = "🔒 Chat is closed for patient responses — Book Again will start a new booking."
                chipCell2.configure(type: chat?.msgType ?? "")
                chipCell2.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chipCell2.contentView.topAnchor.constraint(equalTo: chipCell2.topAnchor),
                    chipCell2.contentView.bottomAnchor.constraint(equalTo: chipCell2.bottomAnchor),
                    chipCell2.contentView.leadingAnchor.constraint(equalTo: chipCell2.leadingAnchor),
                    chipCell2.contentView.trailingAnchor.constraint(equalTo: chipCell2.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(chipCell2) // Append it
                
                return containerCell
            default:
                return UITableViewCell()
            }
        }else{
            if chat?.recieverType == "sender"{
                if chat?.msgType == "text"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightTextCell.className)as! ChatRightTextCell
                    cell.chatTxt.text = chat?.message ?? EMPTY
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.chatBtn.tag = indexPath.row
                    
                    let labelText = chat?.message ?? EMPTY
                    // Detect and add links for phone numbers
                    let attributedText = NSMutableAttributedString(string: chat?.message ?? EMPTY)
                    let phoneNumberDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                    
                    if let phoneMatches = phoneNumberDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                        for match in phoneMatches {
                            if let range = Range(match.range, in: labelText) {
                                let phoneNumber = String(labelText[range])
                                attributedText.addAttribute(.link, value: "tel:\(phoneNumber)", range: match.range)
                            }
                        }
                    }
                    
                    // Detect and add links for web URLs
                    let urlDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    
                    if let urlMatches = urlDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                        for match in urlMatches {
                            if let range = Range(match.range, in: labelText),
                               let url = match.url {
                                attributedText.addAttribute(.link, value: url, range: match.range)
                            }
                        }
                    }
                    
                    cell.chatTxt.attributedText = attributedText
                    cell.chatTxt.isUserInteractionEnabled = true
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
                    longPress.minimumPressDuration = 0.5
                    cell.chatBtn.addGestureRecognizer(longPress)
                    return cell
                }else if chat?.msgType == "image"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightImageCell.className)as! ChatRightImageCell
                    let mystring1 = chat?.message ?? EMPTY
                    let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                    cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: ""),options: [.progressiveLoad, .continueInBackground])
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.chatVw.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    cell.imageBtnTapped = {
                        self.openMultiImageViewer(urls: [mystring1], initialIndex: 0)
                    }
                    cell.imageBtn.setImage(UIImage(systemName: ""), for: .normal)
                    return cell
                }else if chat?.msgType == "multiple"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatRightMultipleImageCell", for: indexPath) as! ChatRightMultipleImageCell
                    cell.configure(chat: chat) { [weak self] index, urls in
                        self?.openMultiImageViewer(urls: urls, initialIndex: index)
                    }
                    return cell
                }else if chat?.msgType == "audio"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightAudioCell.className)as! ChatRightAudioCell
                    cell.configureAlignment(isSender: true)
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    
                    if let urlString = chat?.message, let audioURL = URL(string: urlString) {
                        cell.configureAudio(url: audioURL)
                    }
                    cell.playerContainer.setExpiredOverlay(isExpired: chat?.isExpired ?? 0,isAudioCell: true)
                    return cell
                }else if chat?.msgType == "pdf"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatRightPdfCell") as! ChatRightPdfCell
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    if let urlString = chat?.message, let url = URL(string: urlString) {
                        cell.fileNameLbl.text = url.lastPathComponent
                    }
                    cell.pdfBtnTapped = {
                        if let urlString = chat?.message, let url = URL(string: urlString) {
                            //     let vc = PrescriptionViewVC()
                            //     vc.comeFromChat = true
                            //     vc.urlString = urlString
                            //     vc.titleString = "PDF Document"
                            //     self.navigationController?.pushViewController(vc, animated: true)
                            // }
                            let vc = ProgrammaticPDFViewController()
                            vc.urlString = url.absoluteString
                            vc.isOthersPdf = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    cell.bubbleView.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    return cell
                }else{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightImageCell.className)as! ChatRightImageCell
                    let mystring1 = chat?.message ?? EMPTY
                    let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                    //blurVideoIcon
                    cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "blurVideoIcon"))
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.imageBtnTapped = {
                        let videoURL = URL(string: chat?.message ?? EMPTY)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        playerViewController.allowsPictureInPicturePlayback = false
                        
                        if #available(iOS 14.2, *) {
                            playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
                        }
                        self.navigationController?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    cell.imageBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                    cell.chatVw.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    return cell
                }
            }else{
                if chat?.msgType == "text"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftTextCell.className)as! ChatLeftTextCell
                    cell.chatTxt.text = chat?.message ?? EMPTY
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.chatBtn.tag = indexPath.row
                    
                    let labelText = chat?.message ?? EMPTY
                    
                    // Detect and add links for phone numbers
                    let attributedText = NSMutableAttributedString(string: chat?.message ?? EMPTY)
                    let phoneNumberDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                    
                    if let phoneMatches = phoneNumberDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                        for match in phoneMatches {
                            if let range = Range(match.range, in: labelText) {
                                let phoneNumber = String(labelText[range])
                                attributedText.addAttribute(.link, value: "tel:\(phoneNumber)", range: match.range)
                            }
                        }
                    }
                    
                    // Detect and add links for web URLs
                    let urlDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    
                    if let urlMatches = urlDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                        for match in urlMatches {
                            if let range = Range(match.range, in: labelText),
                               let url = match.url {
                                attributedText.addAttribute(.link, value: url, range: match.range)
                            }
                        }
                    }
                    cell.chatTxt.attributedText = attributedText
                    cell.chatTxt.isUserInteractionEnabled = true
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
                    longPress.minimumPressDuration = 0.5
                    cell.chatBtn.addGestureRecognizer(longPress)
                    return cell
                }else if chat?.msgType == "image"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftImageCell.className)as! ChatLeftImageCell
                    let mystring1 = chat?.message ?? EMPTY
                    let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                    cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: ""),options: [.progressiveLoad, .continueInBackground])
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.chatVw.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    cell.imageBtnTapped = {
                        self.openMultiImageViewer(urls: [mystring1], initialIndex: 0)
                    }
                    cell.imageBtn.setImage(UIImage(systemName: ""), for: .normal)
                    return cell
                }else if chat?.msgType == "multiple"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatLeftMultipleImageCell", for: indexPath) as! ChatLeftMultipleImageCell
                    cell.configure(chat: chat) { [weak self] index, urls in
                        self?.openMultiImageViewer(urls: urls, initialIndex: index)
                    }
                    return cell
                }else if chat?.msgType == "audio"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightAudioCell.className)as! ChatRightAudioCell
                    cell.configureAlignment(isSender: false)
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    
                    if let urlString = chat?.message, let audioURL = URL(string: urlString) {
                        cell.configureAudio(url: audioURL)
                    }
                    cell.playerContainer.setExpiredOverlay(isExpired: chat?.isExpired ?? 0,isAudioCell: true)
                    return cell
                }else if chat?.msgType == "pdf"{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatLeftPdfCell") as! ChatLeftPdfCell
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    if let urlString = chat?.message, let url = URL(string: urlString) {
                        cell.fileNameLbl.text = url.lastPathComponent
                    }
                    cell.pdfBtnTapped = {
                        if let urlString = chat?.message, let url = URL(string: urlString) {
                            //                        let vc = PrescriptionViewVC()
                            //                        vc.comeFromChat = true
                            //                        vc.urlString = urlString
                            //                        vc.titleString = "PDF Document"
                            //                        self.navigationController?.pushViewController(vc, animated: true)
                            //                    }
                            let vc = ProgrammaticPDFViewController()
                            vc.urlString = url.absoluteString
                            vc.isOthersPdf = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    cell.bubbleView.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    return cell
                }else{
                    let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftImageCell.className)as! ChatLeftImageCell
                    let mystring1 = chat?.message ?? EMPTY
                    let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                    //blurVideoIcon
                    cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "blurVideoIcon"))
                    cell.timeLbl.text = chat?.time ?? EMPTY
                    cell.imageBtnTapped = {
                        let videoURL = URL(string: chat?.message ?? EMPTY)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        playerViewController.allowsPictureInPicturePlayback = false
                        
                        if #available(iOS 14.2, *) {
                            playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
                        }
                        self.navigationController?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    cell.imageBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                    cell.chatVw.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
                    return cell
                }
            }
        }
        return  UITableViewCell()
    }
}



import UIKit
import WebKit

class ProgrammaticPDFViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - UI Components
    var webView: WKWebView!
    var backButton: UIButton!
    var downloadBtn: UIButton!
    var isOthersPdf = false
    
    // MARK: - Properties
    var urlString: String?
    var titleString: String = "PDF Document"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupViews()
        loadPDF()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if isOthersPdf{
            downloadBtn.isHidden = false
        }else{
            downloadBtn.isHidden = true
        }
    }
    
    // MARK: - Programmatic UI Setup
    private func setupViews() {
        // 1. Setup WebView
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.mediaTypesRequiringUserActionForPlayback = .all
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.backgroundColor =  .systemBackground
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // 2. Setup Back Button
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back1"), for: .normal) // Ensure "back1" exists in your Assets
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        // 3. Setup Download Button
        downloadBtn = UIButton(type: .system)
        downloadBtn.translatesAutoresizingMaskIntoConstraints = false
        downloadBtn.setTitle("Download", for: .normal)
        downloadBtn.setTitleColor(.white, for: .normal)
        downloadBtn.backgroundColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
        downloadBtn.layer.cornerRadius = 8
        downloadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        downloadBtn.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        self.view.addSubview(downloadBtn)
        
        // 4. AutoLayout Constraints
        NSLayoutConstraint.activate([
            // Back Button Constraints (Top Left)
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 14),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            
            // Download Button Constraints (Top Right)
            downloadBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            downloadBtn.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            downloadBtn.heightAnchor.constraint(equalToConstant: 35),
            downloadBtn.widthAnchor.constraint(equalToConstant: 80),
            
            // WebView Constraints (Fills remaining space below buttons)
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions & Logic
    private func loadPDF() {
        guard let urlStr = urlString, let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func btnBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func downloadTapped() {
        guard let urlStr = urlString, let url = URL(string: urlStr) else { return }
        
        // Show Activity Indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        downloadBtn.setTitle("", for: .normal)
        downloadBtn.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: downloadBtn.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: downloadBtn.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        downloadBtn.isUserInteractionEnabled = false
        
        // Download the file
        URLSession.shared.downloadTask(with: url) { [weak self] localURL, response, error in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                self?.downloadBtn.setTitle("Download", for: .normal)
                self?.downloadBtn.isUserInteractionEnabled = true
                
                guard let localURL = localURL else {
                    print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let fileManager = FileManager.default
                let tempDir = fileManager.temporaryDirectory
                let suggestedName = response?.suggestedFilename ?? "document.pdf"
                let destinationURL = tempDir.appendingPathComponent(suggestedName)
                
                do {
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        try fileManager.removeItem(at: destinationURL)
                    }
                    try fileManager.moveItem(at: localURL, to: destinationURL)
                    
                    // Present Share Sheet
                    let activityVC = UIActivityViewController(activityItems: [destinationURL], applicationActivities: nil)
                    
                    // Configure for iPad Popover
                    if let popover = activityVC.popoverPresentationController {
                        popover.sourceView = self?.downloadBtn
                        popover.sourceRect = self?.downloadBtn?.bounds ?? CGRect.zero
                    }
                    
                    self?.present(activityVC, animated: true, completion: nil)
                    
                } catch {
                    print("Error moving file: \(error)")
                }
            }
        }.resume()
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load PDF")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish to load PDF")
    }
}

extension ChatViewC {
    func openMultiImageViewer(urls: [String], initialIndex: Int) {
        guard !urls.isEmpty, initialIndex < urls.count else { return }
        let viewerVC = MediaPreviewVC()
        viewerVC.imageUrls = urls
        viewerVC.currentIndex = initialIndex
        viewerVC.isViewerMode = true
        viewerVC.modalPresentationStyle = .fullScreen
        self.present(viewerVC, animated: true, completion: nil)
    }
}

// MARK: - WhatsApp Style Multi-Image Preview & Viewer
class MediaPreviewFullCell: UICollectionViewCell {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func loadImage(urlString: String) {
        let clean = urlString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: clean) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            imageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .continueInBackground])
        }
    }
}

class MediaPreviewThumbCell: UICollectionViewCell {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func loadImage(urlString: String) {
        let clean = urlString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: clean) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "blurVideoIcon"), options: [.progressiveLoad, .continueInBackground])
        }
    }
    
    func setSelectedThumb(_ isSelected: Bool) {
        if isSelected {
            imageView.layer.borderWidth = 2.5
            let borderCol = UIColor(named: "ThemeColor") ?? UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0)
            imageView.layer.borderColor = borderCol.cgColor
        } else {
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = nil
        }
    }
}

class MediaPreviewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate {
    var images: [UIImage] = []
    var imageUrls: [String] = []
    var isViewerMode: Bool = false
    var image: UIImage? {
        didSet {
            if let img = image, images.isEmpty {
                images = [img]
            }
        }
    }
    var fileURL: URL?
    var onConfirmImages: (([UIImage]) -> Void)?
    var onConfirm: (() -> Void)?
    var onSend: (() -> Void)? {
        get { return onConfirm }
        set { onConfirm = newValue }
    }
    var onCancel: (() -> Void)?
    
    var currentIndex: Int = 0
    private var mainCollectionView: UICollectionView?
    private var thumbCollectionView: UICollectionView?
    private let topBar = UIView()
    private let titleCounterLabel = UILabel()
    private let deleteBtn = UIButton(type: .system)
    private let closeBtn = UIButton(type: .system)
    private let addMoreBtn = UIButton(type: .system)
    private let sendBtn = UIButton(type: .custom)
    private let badgeLabel = UILabel()
    private let bottomContainer = UIView()
    private let maxPhotosLimit = 5
    
    // Legacy elements for single video/document preview
    private let webView = WKWebView()
    private var playerViewController: AVPlayerViewController?
    
    var totalCount: Int {
        if !images.isEmpty {
            return images.count
        } else if !imageUrls.isEmpty {
            return imageUrls.count
        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if images.isEmpty, let img = image, img.size.height > 0 {
            images = [img]
        }
        if images.count > maxPhotosLimit {
            images = Array(images.prefix(maxPhotosLimit))
        }
        
        if totalCount > 0 {
            setupWhatsAppMultiPreviewUI()
        } else {
            setupLegacyPreviewUI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flow = mainCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let size = mainCollectionView?.bounds.size ?? .zero
            if size.width > 0 && size.height > 0 && flow.itemSize != size {
                flow.itemSize = size
                flow.invalidateLayout()
            }
        }
    }
    
    private func setupWhatsAppMultiPreviewUI() {
        // 1. Top Bar
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(topBar)
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
        closeBtn.tintColor = .white
        closeBtn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        closeBtn.layer.cornerRadius = 18
        closeBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        topBar.addSubview(closeBtn)
        
        titleCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        titleCounterLabel.textColor = .white
        titleCounterLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleCounterLabel.textAlignment = .center
        topBar.addSubview(titleCounterLabel)
        
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.setImage(UIImage(systemName: "trash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)), for: .normal)
        deleteBtn.tintColor = .white
        deleteBtn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        deleteBtn.layer.cornerRadius = 18
        deleteBtn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        topBar.addSubview(deleteBtn)
        deleteBtn.isHidden = isViewerMode
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50),
            
            closeBtn.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            closeBtn.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: 36),
            closeBtn.heightAnchor.constraint(equalToConstant: 36),
            
            titleCounterLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleCounterLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            
            deleteBtn.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            deleteBtn.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 36),
            deleteBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // 2. Bottom Container
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubview(bottomContainer)
        
        addMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        addMoreBtn.setImage(UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
        addMoreBtn.tintColor = .white
        addMoreBtn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        addMoreBtn.layer.cornerRadius = 22
        addMoreBtn.addTarget(self, action: #selector(addMoreTapped), for: .touchUpInside)
        bottomContainer.addSubview(addMoreBtn)
        addMoreBtn.isHidden = isViewerMode || images.count >= maxPhotosLimit
        
        let thumbLayout = UICollectionViewFlowLayout()
        thumbLayout.scrollDirection = .horizontal
        thumbLayout.itemSize = CGSize(width: 50, height: 50)
        thumbLayout.minimumLineSpacing = 6
        thumbLayout.minimumInteritemSpacing = 6
        
        let thumbCV = UICollectionView(frame: .zero, collectionViewLayout: thumbLayout)
        thumbCV.translatesAutoresizingMaskIntoConstraints = false
        thumbCV.backgroundColor = .clear
        thumbCV.showsHorizontalScrollIndicator = false
        thumbCV.dataSource = self
        thumbCV.delegate = self
        thumbCV.register(MediaPreviewThumbCell.self, forCellWithReuseIdentifier: "ThumbCell")
        bottomContainer.addSubview(thumbCV)
        self.thumbCollectionView = thumbCV
        
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.backgroundColor = UIColor(named: "ThemeColor") ?? UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0)
        sendBtn.layer.cornerRadius = 26
        sendBtn.setImage(UIImage(systemName: "paperplane.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        sendBtn.tintColor = .white
        sendBtn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        bottomContainer.addSubview(sendBtn)
        sendBtn.isHidden = isViewerMode
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.backgroundColor = .white
        badgeLabel.textColor = UIColor(named: "ThemeColor") ?? UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0)
        badgeLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        bottomContainer.addSubview(badgeLabel)
        badgeLabel.isHidden = isViewerMode
        
        if isViewerMode {
            NSLayoutConstraint.activate([
                bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
                
                thumbCV.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
                thumbCV.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
                thumbCV.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 12),
                thumbCV.heightAnchor.constraint(equalToConstant: 52)
            ])
            if totalCount <= 1 {
                bottomContainer.isHidden = true
            }
        } else {
            NSLayoutConstraint.activate([
                bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -95),
                
                addMoreBtn.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 12),
                addMoreBtn.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 14),
                addMoreBtn.widthAnchor.constraint(equalToConstant: 44),
                addMoreBtn.heightAnchor.constraint(equalToConstant: 44),
                
                sendBtn.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -14),
                sendBtn.centerYAnchor.constraint(equalTo: addMoreBtn.centerYAnchor),
                sendBtn.widthAnchor.constraint(equalToConstant: 52),
                sendBtn.heightAnchor.constraint(equalToConstant: 52),
                
                badgeLabel.topAnchor.constraint(equalTo: sendBtn.topAnchor, constant: -4),
                badgeLabel.trailingAnchor.constraint(equalTo: sendBtn.trailingAnchor, constant: 4),
                badgeLabel.widthAnchor.constraint(equalToConstant: 20),
                badgeLabel.heightAnchor.constraint(equalToConstant: 20),
                
                thumbCV.leadingAnchor.constraint(equalTo: addMoreBtn.trailingAnchor, constant: 8),
                thumbCV.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -10),
                thumbCV.centerYAnchor.constraint(equalTo: addMoreBtn.centerYAnchor),
                thumbCV.heightAnchor.constraint(equalToConstant: 52)
            ])
        }
        
        // 3. Main Center Pager
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.scrollDirection = .horizontal
        mainLayout.minimumLineSpacing = 0
        mainLayout.minimumInteritemSpacing = 0
        
        let mainCV = UICollectionView(frame: .zero, collectionViewLayout: mainLayout)
        mainCV.translatesAutoresizingMaskIntoConstraints = false
        mainCV.backgroundColor = .clear
        mainCV.isPagingEnabled = true
        mainCV.showsHorizontalScrollIndicator = false
        mainCV.dataSource = self
        mainCV.delegate = self
        mainCV.register(MediaPreviewFullCell.self, forCellWithReuseIdentifier: "FullCell")
        view.addSubview(mainCV)
        self.mainCollectionView = mainCV
        
        let bottomAnchorToUse = (isViewerMode && totalCount <= 1) ? view.safeAreaLayoutGuide.bottomAnchor : bottomContainer.topAnchor
        NSLayoutConstraint.activate([
            mainCV.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            mainCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCV.bottomAnchor.constraint(equalTo: bottomAnchorToUse)
        ])
        
        updateUIForCurrentIndex()
        
        if currentIndex > 0 && currentIndex < totalCount {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.mainCollectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
                self.thumbCollectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private func updateUIForCurrentIndex() {
        let count = totalCount
        titleCounterLabel.text = "\(currentIndex + 1) of \(count)"
        badgeLabel.text = "\(count)"
    }
    
    // MARK: - Legacy Preview Setup (PDF, Audio & Video)
    private func setupLegacyPreviewUI() {
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.backgroundColor = .systemRed
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.backgroundColor = UIColor(named: "ThemeColor") ?? .systemBlue
        sendBtn.layer.cornerRadius = 8
        sendBtn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [cancelBtn, sendBtn])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
        
        if let url = fileURL {
            let ext = url.pathExtension.lowercased()
            if ext == "pdf" {
                containerView.addSubview(webView)
                webView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                ])
                webView.loadFileURL(url, allowingReadAccessTo: url)
            } else if ["mp4", "mov", "m4v"].contains(ext) {
                let player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = player
                addChild(vc)
                containerView.addSubview(vc.view)
                vc.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                ])
                vc.didMove(toParent: self)
                self.playerViewController = vc
            } else if ["mp3", "wav", "m4a", "aac"].contains(ext) {
                let player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = player
                addChild(vc)
                containerView.addSubview(vc.view)
                vc.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                ])
                vc.didMove(toParent: self)
                self.playerViewController = vc
                player.play()
            } else {
                let label = UILabel()
                label.text = "File: \(url.lastPathComponent)"
                label.textColor = .white
                label.textAlignment = .center
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
                ])
            }
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        onCancel?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteTapped() {
        guard !images.isEmpty, currentIndex < images.count else { return }
        images.remove(at: currentIndex)
        if images.isEmpty {
            onCancel?()
            dismiss(animated: true, completion: nil)
            return
        }
        if currentIndex >= images.count {
            currentIndex = images.count - 1
        }
        addMoreBtn.isHidden = isViewerMode || images.count >= maxPhotosLimit
        updateUIForCurrentIndex()
        mainCollectionView?.reloadData()
        thumbCollectionView?.reloadData()
        mainCollectionView?.layoutIfNeeded()
        if currentIndex < images.count {
            mainCollectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            thumbCollectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc private func addMoreTapped() {
        let remaining = maxPhotosLimit - images.count
        if remaining <= 0 {
            showToast(message: "You can upload up to 5 photos at a time")
            return
        }
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = remaining
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        
        let remaining = max(0, maxPhotosLimit - images.count)
        guard remaining > 0 else { return }
        
        let resultsToLoad = Array(results.prefix(remaining))
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.drlive.addmoreimages")
        var orderedImages = [Int: UIImage]()
        
        for (index, result) in resultsToLoad.enumerated() {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        serialQueue.sync {
                            orderedImages[index] = image
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let currentRemaining = max(0, self.maxPhotosLimit - self.images.count)
            var addedCount = 0
            for i in 0..<resultsToLoad.count {
                if addedCount >= currentRemaining { break }
                if let img = orderedImages[i] {
                    self.images.append(img)
                    addedCount += 1
                }
            }
            self.addMoreBtn.isHidden = self.isViewerMode || self.images.count >= self.maxPhotosLimit
            self.currentIndex = self.images.count - 1
            self.updateUIForCurrentIndex()
            self.mainCollectionView?.reloadData()
            self.thumbCollectionView?.reloadData()
            self.mainCollectionView?.layoutIfNeeded()
            self.mainCollectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.thumbCollectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func sendTapped() {
        if !images.isEmpty {
            let finalImages = images.count > maxPhotosLimit ? Array(images.prefix(maxPhotosLimit)) : images
            onConfirmImages?(finalImages)
            onConfirm?()
        } else {
            onConfirm?()
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullCell", for: indexPath) as! MediaPreviewFullCell
            if !images.isEmpty && indexPath.item < images.count {
                cell.setImage(images[indexPath.item])
            } else if !imageUrls.isEmpty && indexPath.item < imageUrls.count {
                cell.loadImage(urlString: imageUrls[indexPath.item])
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbCell", for: indexPath) as! MediaPreviewThumbCell
            if !images.isEmpty && indexPath.item < images.count {
                cell.setImage(images[indexPath.item])
            } else if !imageUrls.isEmpty && indexPath.item < imageUrls.count {
                cell.loadImage(urlString: imageUrls[indexPath.item])
            }
            cell.setSelectedThumb(indexPath.item == currentIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == thumbCollectionView {
            currentIndex = indexPath.item
            updateUIForCurrentIndex()
            thumbCollectionView?.reloadData()
            mainCollectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainCollectionView {
            let width = max(1, scrollView.bounds.width)
            let page = Int(round(scrollView.contentOffset.x / width))
            if page >= 0 && page < totalCount && page != currentIndex {
                currentIndex = page
                updateUIForCurrentIndex()
                thumbCollectionView?.reloadData()
                thumbCollectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}

typealias ChatMediaPreviewViewController = MediaPreviewVC

