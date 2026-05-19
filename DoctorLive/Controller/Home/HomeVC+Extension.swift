//
//  HomeVC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import UIKit

extension HomeVC: UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeVC: UITableViewDataSource {
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
}
