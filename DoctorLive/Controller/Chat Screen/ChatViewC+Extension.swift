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

extension ChatViewC: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupByCategoryChat?[self.keys[section]]?.count ?? INTZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
        if chat?.msgType == "REQUESTED" && chat?.is_status != "1" {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
//        guard chat?.recieverType == "sender" else {
//            return nil
//        }
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
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        parameter = ["token": token,
                     "booking_id": bookingId ?? EMPTY,
                     "suggested_time": date]
        firstly {
            service!.suggestedTime(parameters: parameter, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.confirmBoking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
        }.finally {
            DispatchQueue.main.async {
                Indicator.shared.hideProgressView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
        if let historyType = chat?.historyType, (historyType == "booking_status" || historyType == "new_booking_request") {
            switch chat?.msgType {
            case "REQUESTED":
                if chat?.is_status == "1" {
                    let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                    containerCell.stackView.spacing = 8
                    
                    let chipCell = ChatNewBookingRequestCell(style: .default, reuseIdentifier: nil)
                    chipCell.configure(patientName: self.patientName ?? "", fee: "৳\(chat?.fees ?? "0")")
                    chipCell.availableNowTapped = { [weak self] in
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        self?.AcceptRejectBooking(status: "1")
                    }
                    chipCell.rejectTapped = { [weak self] in
                        Indicator.shared.showProgressView(self?.view ?? UIView())
                        self?.AcceptRejectBooking(status: "2")
                    }
                    chipCell.suggestTimeTapped = { [weak self] dateStr in
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
                    return containerCell
                } else {
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    cell.contentView.isHidden = true
                    return cell
                }
            case "No_RESPONSE", "PAYMENT_EXPIRED":
                // 1. Dequeue the generic dynamic stack cell
                let containerCell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatDynamicStackCell") as! ChatDynamicStackCell
                containerCell.stackView.spacing = 8
                // 2. Instantiate and configure the first cell
                let chipCell = ChatStageChipCell(style: .default, reuseIdentifier: nil)
                chipCell.titleLabel.text = chat?.msgType == "No_RESPONSE" ? "⏱ Doctor Did Not Respond" : "⏱ Payment Window Expired"
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
                cardCell.titleLabel.text =  chat?.msgType == "No_RESPONSE" ? "Unfortunately, the doctor was unable to respond to your request." : "Patient did not complete payment in time — booking closed automatically."
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
                chipCell.titleLabel.text = "✅ Doctor Accepted"
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
                    consultationCell.subLabel.text = "Patient has paid and is waiting."
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
                
                let cardCell = ChatVideoCallBadgeCell(style: .default, reuseIdentifier: nil)
                if chat?.is_status == "1" {
                    // let callStartDate = Booking.parseDate(dateStr: nil, createdOn: chat?.createdOn)
                    // cardCell.startTimer(with: callStartDate)
                    //  cardCell.stopTimer()
                    cardCell.timeLabel.text = "Call in progress"
                } else {
                    var durationText = "00:00"
                    if let startStr = chat?.createdOn,
                       let endMsg = self.chatData.first(where: { $0.msgType == "CALL_ENDED" && ($0.createdOn ?? "") >= startStr }),
                       let endStr = endMsg.createdOn {
                        let startDate = Booking.parseDate(dateStr: nil, createdOn: startStr)
                        let endDate = Booking.parseDate(dateStr: nil, createdOn: endStr)
                        let duration = Int(endDate.timeIntervalSince(startDate))
                        if duration >= 0 {
                            let mins = duration / 60
                            let secs = duration % 60
                            durationText = String(format: "%02d:%02d", mins, secs)
                        }
                    }
                    cardCell.stopTimer(with: durationText)
                }
                
                cardCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cardCell.contentView.topAnchor.constraint(equalTo: cardCell.topAnchor),
                    cardCell.contentView.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor),
                    cardCell.contentView.leadingAnchor.constraint(equalTo: cardCell.leadingAnchor),
                    cardCell.contentView.trailingAnchor.constraint(equalTo: cardCell.trailingAnchor)
                ])
                containerCell.stackView.addArrangedSubview(cardCell) // Append it
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
                chipCell.titleLabel.text = "📹 Video Call - \(callDurationText)"
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
                        self?.emitBookingStatusData(bookingStatus: "CONSULTATION_COMPLETED")
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
                chipCell.iconView.image = UIImage(systemName: "document")
                chipCell.titleLabel.text = "Prescription sent"
                chipCell.subLabel.text = "Diagnosis: Viral fever with mild rash"
                chipCell.expandLabel.text = "View"
                chipCell.expandLabel2.isHidden = true
                chipCell.expandLabel2.text = ""
                
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
                    cardCell.subLabel.text = "\(patientName ?? "") rated this consultation"
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
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatStageChipCell") as! ChatStageChipCell
                cell.titleLabel.text = "🔒 Chat Closed"
                cell.configure(type: chat?.msgType ?? "")
                return cell
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
                        let viewC = DIConfigurator.sharedInst().getImagePopPrieViewC()
                        viewC.imageUrl = chat?.message ?? EMPTY
                        self.navigationController?.pushViewController(viewC, animated: true)
                    }
                    cell.imageBtn.setImage(UIImage(systemName: ""), for: .normal)
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
                        let viewC = DIConfigurator.sharedInst().getImagePopPrieViewC()
                        viewC.imageUrl = chat?.message ?? EMPTY
                        self.navigationController?.pushViewController(viewC, animated: true)
                    }
                    cell.imageBtn.setImage(UIImage(systemName: ""), for: .normal)
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
