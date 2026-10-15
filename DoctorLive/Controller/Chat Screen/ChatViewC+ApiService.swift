//
//  ChatViewC+ApiService.swift
//  Dr.Live
//
//  Created by Kv on 24/12/24.
//

import Foundation
import UIKit

extension ChatViewC{
    func getChatHistry() {
        if isLoading || !hasMoreData { return }
        isLoading = true
        
        let token = UserDefaults.standard.value(forKey: Constants.accessToken) ?? EMPTY
        let selectedLanguage  = UserDefaults.standard.value(forKey: Constants.languageCode) ?? EMPTY
        var passDict =  [ "language_type" : selectedLanguage,
                          "token": token,
                          "room_id" : self.roomId ?? EMPTY]
        
        if self.isFromPagination {
            passDict["page"] = "\(self.currentPage)"
        }
        print(passDict)
        
        if self.currentPage == 1 {
            Indicator.shared.showProgressView(view)
        }
        
        viewmodel.chatHistryApi(url: APIEndpoint.doctorchathistory, passDict: passDict)
        closureSetUp()
    }
    
    // fileprivate func setUpMessageList(){
    //     if self.currentPage != 1 {
    //         self.chatTblVw.tableHeaderView = nil
    //     }
        
    //     var newChatData = [ChatData]()
    //     let sortedHistory = self.viewmodel.doctorChatData.first?.doctorchathistory?.sorted {
    //         ($0.createdOn ?? "") < ($1.createdOn ?? "")
    //     } ?? []
        
    //     sortedHistory.forEach({ messageListData in
    //         var recieverType = EMPTY
    //         if (messageListData.senderId ?? EMPTY) == self.senderId {
    //             recieverType = "sender"
    //         }else{
    //             recieverType = "reciever"
    //         }

    //         let timmee = self.timeDateConversion(formateDate: messageListData.createdOn ?? EMPTY)
    //         newChatData.append(ChatData(message:  messageListData.message ?? EMPTY, time: timmee, msgType: messageListData.type ?? EMPTY, recieverType: recieverType, date: String((messageListData.createdOn ?? EMPTY).dropLast(9)), id: messageListData.id ?? EMPTY,isExpired: messageListData.isExpired ?? 0, historyType: messageListData.historyType, bookingId: messageListData.bookingId, statusId: messageListData.statusId, fees:messageListData.fees, changedByType: messageListData.changedByType, changedById: messageListData.changedById, createdOn: messageListData.createdOn,rating:messageListData.rating,prescription_url:messageListData.prescription_url, is_status:messageListData.is_status ?? "1", booking_date: messageListData.booking_date, booking_time: messageListData.booking_time))
    //     })
        
    //     let fetchedCount = newChatData.count
    //     if fetchedCount == 0 {
    //         self.hasMoreData = false
    //         return
    //     }
        
    //     if self.currentPage == 1 {
    //         self.chatData = newChatData
    //         if self.chatData.count > INTZERO {
    //             self.setUpChatData()
    //             self.chatTblVw.reloadData()
    //             self.chatTblVw.layoutIfNeeded()
    //             self.setscrollPosition()
    //         } else {
    //             self.chatTblVw.reloadData()
    //         }
    //     } else {
    //         let oldTopIndex = newChatData.count
            
    //         self.chatData.insert(contentsOf: newChatData, at: 0)
    //         self.setUpChatData()
    //         self.chatTblVw.reloadData()
    //         self.chatTblVw.layoutIfNeeded()
            
    //         if let grouped = self.groupByCategoryChat {
    //             var currentIndex = 0
    //             var targetIndexPath: IndexPath?
                
    //             for (sectionIndex, key) in self.keys.enumerated() {
    //                 if let chatsInSection = grouped[key] {
    //                     if currentIndex + chatsInSection.count > oldTopIndex {
    //                         let rowIndex = oldTopIndex - currentIndex
    //                         targetIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
    //                         break
    //                     }
    //                     currentIndex += chatsInSection.count
    //                 }
    //             }
                
    //         if let indexPath = targetIndexPath {
    //                 // Temporarily disable animation to avoid any visible jump
    //                 UIView.performWithoutAnimation {
    //                     self.chatTblVw.scrollToRow(at: indexPath, at: .none, animated: true)
    //                 }
    //             }
    //         }
    //     }
        
    //     if !self.isOnline {
    //         self.statusLbl.text = "last active:  \(self.viewmodel.doctorChatData.first?.other_details?.last_active ?? "")"
    //         self.statusVw.backgroundColor = UIColor(named: "PlaceHolderTextColor")
    //     }
    // }

    fileprivate func setUpMessageList(){
        if self.currentPage != 1 {
            self.chatTblVw.tableHeaderView = nil
        }
        
        var newChatData = [ChatData]()
        let sortedHistory = self.viewmodel.doctorChatData.first?.doctorchathistory?.sorted {
            ($0.createdOn ?? "") < ($1.createdOn ?? "")
        } ?? []
        
        sortedHistory.forEach({ messageListData in
            var recieverType = EMPTY
            if (messageListData.senderId ?? EMPTY) == self.senderId {
                recieverType = "sender"
            }else{
                recieverType = "reciever"
            }

            let timmee = self.timeDateConversion(formateDate: messageListData.createdOn ?? EMPTY)
            newChatData.append(ChatData(message:  messageListData.message ?? EMPTY, time: timmee, msgType: messageListData.type ?? EMPTY, recieverType: recieverType, date: String((messageListData.createdOn ?? EMPTY).dropLast(9)), id: messageListData.id ?? EMPTY,isExpired: messageListData.isExpired ?? 0, historyType: messageListData.historyType, bookingId: messageListData.bookingId, statusId: messageListData.statusId, fees:messageListData.fees, changedByType: messageListData.changedByType, changedById: messageListData.changedById, createdOn: messageListData.createdOn,rating:messageListData.rating,prescription_url:messageListData.prescription_url, is_status:messageListData.is_status ?? "1", booking_date: messageListData.booking_date, booking_time: messageListData.booking_time, is_follow_up: messageListData.is_follow_up, booking_number: messageListData.booking_number, follow_up_time: messageListData.follow_up_time, is_videocall: self.viewmodel.doctorChatData.first?.other_details?.is_videocall ?? messageListData.is_videocall))
        })
        
        let fetchedCount = newChatData.count
        if fetchedCount == 0 {
            self.hasMoreData = false
            return
        }
        
        if self.currentPage == 1 {
            self.chatData = newChatData
            if self.chatData.count > INTZERO {
                self.setUpChatData()
                self.chatTblVw.reloadData()
                self.chatTblVw.layoutIfNeeded()
                self.setscrollPosition()
            } else {
                self.chatTblVw.reloadData()
            }
        } else {
            let oldOffset = self.chatTblVw.contentOffset
            var oldYOffsetWithinCell: CGFloat = 0
            var targetChatId: String? = nil
            
            // 1. Find the top visible cell and its exact offset and ID
            let firstVisibleIndexPath = self.chatTblVw.indexPathsForVisibleRows?.first
            if let firstVisibleIndexPath = firstVisibleIndexPath {
                let oldRect = self.chatTblVw.rectForRow(at: firstVisibleIndexPath)
                oldYOffsetWithinCell = oldOffset.y - oldRect.origin.y
                
                if firstVisibleIndexPath.section < self.keys.count {
                    let key = self.keys[firstVisibleIndexPath.section]
                    if let chatsInSection = self.groupByCategoryChat?[key], firstVisibleIndexPath.row < chatsInSection.count {
                        targetChatId = chatsInSection[firstVisibleIndexPath.row].id
                    }
                }
            }
            
            // 2. Load Data
            self.chatData.insert(contentsOf: newChatData, at: 0)
            self.setUpChatData()
            self.chatTblVw.reloadData()
            self.chatTblVw.layoutIfNeeded()
            
            // 3. Find the NEW index path of that exact same cell by ID
            var targetIndexPath: IndexPath? = nil
            if let targetChatId = targetChatId, let grouped = self.groupByCategoryChat {
                for (sectionIndex, key) in self.keys.enumerated() {
                    if let chatsInSection = grouped[key] {
                        if let rowIndex = chatsInSection.firstIndex(where: { $0.id == targetChatId }) {
                            targetIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                            break
                        }
                    }
                }
            }
            
            // 4. Restore the exact offset
            if let indexPath = targetIndexPath {
                let newRect = self.chatTblVw.rectForRow(at: indexPath)
                let newContentOffsetY = newRect.origin.y + oldYOffsetWithinCell
                self.chatTblVw.setContentOffset(CGPoint(x: 0, y: newContentOffsetY), animated: false)
            }
        }
        
        if !self.isOnline {
            self.statusLbl.text = "last active:  \(self.viewmodel.doctorChatData.first?.other_details?.last_active ?? "")"
            self.statusVw.backgroundColor = UIColor(named: "PlaceHolderTextColor")
        }
    }
    
    func closureSetUp() {
        // MARK:- For success
        viewmodel.success = {[weak self] (message) in
            DispatchQueue.main.async { [self] in
                Indicator.shared.hideProgressView()
                self?.isLoading = false
                
                if message == "Chat History" {
                    self?.setUpMessageList()
                }else{
                    self?.showToast(message: message)
                }
            }
        }
        
        // MARK:- For Error Message
        viewmodel.errorMessage = {[weak self] (message) in
            DispatchQueue.main.async {
                Indicator.shared.hideProgressView()
                self?.isLoading = false
                print(message)
                self?.showToast(message: message)
            }
        }
        viewmodel.invalidToken = {[weak self] (message) in
            DispatchQueue.main.async {
                Indicator.shared.hideProgressView()
                self?.isLoading = false
            }
        }
    }
    
    func deleteChatMessage(chatId: String, indexPath: IndexPath) {
        let token = UserDefaults.standard.value(forKey: Constants.accessToken) ?? EMPTY
//        let token = kUserDefaults.value(forKey: UserDefaultKeys.jwtToken) as? String ?? EMPTY
        let urlString = "https://doctorlivebd.com/api/doctor/doctorchatdelete"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = "token=\(token)&chat_id=\(chatId)"
        print(parameters)
        request.httpBody = parameters.data(using: .utf8)
        
        Indicator.shared.showProgressView(self.view)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                Indicator.shared.hideProgressView()
                if let error = error {
                    self.showToast(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let status = json["status"] as? String ?? ""
                        if status == "SUCCESS" {
                            // Successfully deleted from backend, remove from local data
                            self.removeChatFromLocal(at: indexPath)
                            self.showToast(message: json["message"] as? String ?? "Deleted successfully")
                        } else {
                            self.showToast(message: json["message"] as? String ?? "Failed to delete")
                        }
                    }
                } catch {
                    self.showToast(message: "Error parsing response")
                }
            }
        }
        task.resume()
    }
    
    private func removeChatFromLocal(at indexPath: IndexPath) {
        let key = self.keys[indexPath.section]
        if var chatsInSection = self.groupByCategoryChat?[key] {
            // Find the chat in the flat array to remove it as well
            let chatToRemove = chatsInSection[indexPath.row]
            if let flatIndex = self.chatData.firstIndex(where: { $0.id == chatToRemove.id }) {
                self.chatData.remove(at: flatIndex)
            }
            
            chatsInSection.remove(at: indexPath.row)
            
            if chatsInSection.isEmpty {
                self.groupByCategoryChat?.removeValue(forKey: key)
                self.keys.remove(at: indexPath.section)
                self.chatTblVw.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                self.groupByCategoryChat?[key] = chatsInSection
                self.chatTblVw.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
