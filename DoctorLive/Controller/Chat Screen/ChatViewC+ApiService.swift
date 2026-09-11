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
        let token = UserDefaults.standard.value(forKey: Constants.accessToken) ?? EMPTY
        let selectedLanguage  = UserDefaults.standard.value(forKey: Constants.languageCode) ?? EMPTY
        let passDict =  [ "language_type" : selectedLanguage,
                          "token": token,
                          "room_id" : self.roomId ?? EMPTY]
        print(passDict)
        Indicator.shared.showProgressView(view)
        viewmodel.chatHistryApi(url: APIEndpoint.doctorchathistory, passDict: passDict)
        closureSetUp()
    }
    
    fileprivate func setUpMessageList(){
        self.chatData.removeAll()
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
//            Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date.getDate(dateStr: timmee, format: DateFormat.isoFormat) ?? Date())
//            Date.getDateStringWithDatee(DateFormat.dateMonthyear, date: Date.getDate(dateStr: messageListData.createdOn ?? EMPTY, format: DateFormat.isoFormat) ?? Date())
//            self.chatData.append(ChatData(message:  messageListData.message ?? EMPTY, time: timmee, msgType: messageListData.type ?? EMPTY, recieverType: recieverType, date: String((messageListData.createdOn ?? EMPTY).dropLast(9)), id: messageListData.id ?? EMPTY,isExpired: messageListData.isExpired ?? 0))
            self.chatData.append(ChatData(message:  messageListData.message ?? EMPTY, time: timmee, msgType: messageListData.type ?? EMPTY, recieverType: recieverType, date: String((messageListData.createdOn ?? EMPTY).dropLast(9)), id: messageListData.id ?? EMPTY,isExpired: messageListData.isExpired ?? 0, historyType: messageListData.historyType, bookingId: messageListData.bookingId, statusId: messageListData.statusId, fees:messageListData.fees, changedByType: messageListData.changedByType, changedById: messageListData.changedById, createdOn: messageListData.createdOn,rating:messageListData.rating, is_status:messageListData.is_status ?? "1"))
        })
        if self.chatData.count > INTZERO {
            self.setUpChatData()
            self.setscrollPosition()
        }
        self.statusLbl.text = "last active:  \(self.viewmodel.doctorChatData.first?.other_details?.last_active ?? "")"
        self.chatTblVw.reloadData()
    }
    
    func closureSetUp() {
        // MARK:- For success
        viewmodel.success = {[weak self] (message) in
            DispatchQueue.main.async { [self] in
                Indicator.shared.hideProgressView()
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
                print(message)
                self?.showToast(message: message)
            }
        }
        viewmodel.invalidToken = {[weak self] (message) in
            DispatchQueue.main.async {
                Indicator.shared.hideProgressView()
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
