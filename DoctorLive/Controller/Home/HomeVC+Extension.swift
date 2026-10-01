 

import Foundation
import UIKit

extension HomeVC: UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
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
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.yourDoctors.count
        } else {
            return self.moreDoctors.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isOverallLastRow: Bool
        if self.moreDoctors.isEmpty {
            isOverallLastRow = (indexPath.section == 0 && indexPath.row == self.yourDoctors.count - 1)
        } else {
            isOverallLastRow = (indexPath.section == 1 && indexPath.row == self.moreDoctors.count - 1)
        }
        
        if isOverallLastRow && !self.isLoadingList && !self.isLastPage {
            // Outer pagination: only trigger if we have a full page (multiple of pageLimit)
            if self.allBookingData.count % self.pageLimit == 0 {
                self.currentPage += 1
                self.performAllBooking(isRefresh: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if self.yourDoctors.isEmpty {
                return nil
            }
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookingTitleCell.className) as! BookingTitleCell
            header.pendingLbl.text = "Your Doctors"
            header.pendingLbl.textColor = UIColor(red: 150/255, green: 161/255, blue: 182/255, alpha: 1)
            return header
        } else {
            if self.moreDoctors.isEmpty || self.yourDoctors.isEmpty {
                return nil
            }
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookingTitleCell.className) as! BookingTitleCell
            header.pendingLbl.text = "More Doctors"
            header.pendingLbl.textColor = UIColor(red: 150/255, green: 161/255, blue: 182/255, alpha: 1)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.yourDoctors.isEmpty ? 0 : 44
        } else {
            return (self.moreDoctors.isEmpty || self.yourDoctors.isEmpty) ? 0 : 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return CGFloat.leastNormalMagnitude
       }
       
       func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           return UIView()
       }
    
}

extension HomeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = indexPath.section == 0 ? self.yourDoctors[indexPath.row] : self.moreDoctors[indexPath.row]
        let patientId = group.patientId ?? ""
        let patientName = group.patientName ?? ""
        let calls = group.call ?? []
        let bookings: [Booking] = calls.map { $0.toBooking() }
        let isExpanded = self.expandedPatientIds.contains(patientId)
        
        let chatCount = group.chatCount
        let baseChatTitle = indexPath.section == 0 ? "Open Chat" : "Chat"
        let finalChatTitle = chatCount ?? 0 > 0 ? "\(baseChatTitle) (\(chatCount ?? 0))" : baseChatTitle
        
        let cell = self.bookingTblVw.dequeueReusableCell(
            withIdentifier: DoctorCardTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! DoctorCardTableViewCell
        
        cell.configure(
            doctorName: patientName,
            specialty: group.gender.flatMap { $0 == "m" ? "Male" : $0 == "f" ? "Female" : "" } ?? "",
            bookings: bookings,
            expanded: isExpanded,
//            chatButtonTitle: indexPath.section == 0 ? "Open Chat" : "Chat",
            chatButtonTitle: finalChatTitle,
            totalBookings: group.totalBookings
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
            vc.isFromPagination = true
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

