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
        self.viewmodel.doctorChatData.first?.doctorchathistory?.forEach({ messageListData in
            var recieverType = EMPTY
            if (messageListData.senderId ?? EMPTY) == self.senderId {
                recieverType = "sender"
            }else{
                recieverType = "reciever"
            }
            let timmee = self.timeDateConversion(formateDate: messageListData.createdOn ?? EMPTY)
//            Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date.getDate(dateStr: timmee, format: DateFormat.isoFormat) ?? Date())
//            Date.getDateStringWithDatee(DateFormat.dateMonthyear, date: Date.getDate(dateStr: messageListData.createdOn ?? EMPTY, format: DateFormat.isoFormat) ?? Date())
            self.chatData.append(ChatData(message:  messageListData.message ?? EMPTY, time: timmee, msgType: messageListData.type ?? EMPTY, recieverType: recieverType, date: String((messageListData.createdOn ?? EMPTY).dropLast(9))))
        })
        if self.chatData.count > INTZERO {
            self.setUpChatData()
            self.setscrollPosition()
        }
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
}
