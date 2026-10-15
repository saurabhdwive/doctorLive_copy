//
//  ChatViewC+ChatVw.swift
//  Dr.Live
//
//  Created by Kv on 24/12/24.
//

import Foundation
import UIKit
import SwiftyJSON

extension ChatViewC{
    func setUpChat(){
        SocketHelper.shared.on(with: .send_new_booking_request) { (data) in
            Indicator.shared.hideProgressView()
            print("send_new_booking_request ============+>>>>>>>>>>>>>>>", data)
            do {
                let json = JSON(data)
                var firstData: DoctorchathistoryData? = nil
                for item in json.arrayValue {
                    if item.type == .dictionary {
                        firstData = DoctorchathistoryData(item)
                        break
                    }
                }
                
                if let firstData = firstData {
                    var recieverType = EMPTY
                    if (firstData.senderId ?? EMPTY) == self.senderId {
                        recieverType = "sender"
                    } else {
                        recieverType = "reciever"
                    }
                    
                    var timmee = EMPTY
                    var dateStr = EMPTY
                    let dateToUse = (firstData.createdOn?.isEmpty == false) ? firstData.createdOn! : (firstData.statusSince ?? EMPTY)
                    
                    if !dateToUse.isEmpty {
                        timmee = self.timeDateConversion(formateDate: dateToUse)
                        dateStr = String(dateToUse.prefix(10))
                    } else if let time = firstData.time, let date = firstData.date {
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "dd-MMM-yyyy"
                        if let d = inputFormatter.date(from: date) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "yyyy-MM-dd"
                            dateStr = outputFormatter.string(from: d)
                        } else {
                            dateStr = date
                        }
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss"
                        if let t = timeFormatter.date(from: time) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "hh:mm a"
                            timmee = outputFormatter.string(from: t)
                        } else {
                            timmee = time
                        }
                    }
                    print(firstData.bookingId)
                    self.bookingId = firstData.bookingId
                    self.roomId = firstData.bookingId
                    self.setUpRoom()
                    let msgType = firstData.type ?? EMPTY
//                    if msgType == "RATING_SUBMITTED"{
//                        if let index = self.chatData.lastIndex(where: { $0.msgType == "PRESCRIPTION_SENT" }) {
//                            self.chatData[index].rating = firstData.rating
//                            DispatchQueue.main.async {
//                                self.setUpChatData()
//                            }
//                        }
//                    } else {
                    self.chatData.append(ChatData(message: firstData.message ?? EMPTY, time: timmee, msgType: msgType, recieverType: recieverType, date: dateStr, id: firstData.id ?? EMPTY, isExpired: firstData.isExpired ?? 0, historyType: firstData.historyType, bookingId: firstData.bookingId, statusId: firstData.statusId, fees:firstData.fees, changedByType: firstData.changedByType, changedById: firstData.changedById, createdOn: dateToUse,is_status: firstData.is_status, booking_date: firstData.booking_date, booking_time: firstData.booking_time, is_follow_up: firstData.is_follow_up, follow_up_time: firstData.follow_up_time, is_videocall: firstData.is_videocall))
//                    }
                    
                    self.setscrollPosition()
                    self.messageTxt.text = EMPTY
                    self.setUpChatData()
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshScreen"), object: nil)
                }
            } catch {
                print("huihuhiuhi")
            }
        }
        SocketHelper.shared.on(with: .booking_status_updated) { (data) in
            Indicator.shared.hideProgressView()
            print("booking_status_updated ============+>>>>>>>>>>>>>>>", data)
            do {
                let json = JSON(data)
                var firstData: DoctorchathistoryData? = nil
                for item in json.arrayValue {
                    if item.type == .dictionary {
                        firstData = DoctorchathistoryData(item)
                        break
                    }
                }
                
                if let firstData = firstData {
                    var recieverType = EMPTY
                    if (firstData.senderId ?? EMPTY) == self.senderId {
                        recieverType = "sender"
                    } else {
                        recieverType = "reciever"
                    }
                    
                    var timmee = EMPTY
                    var dateStr = EMPTY
                    let dateToUse = (firstData.createdOn?.isEmpty == false) ? firstData.createdOn! : (firstData.statusSince ?? EMPTY)
                    
                    if !dateToUse.isEmpty {
                        timmee = self.timeDateConversion(formateDate: dateToUse)
                        dateStr = String(dateToUse.prefix(10))
                    } else if let time = firstData.time, let date = firstData.date {
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "dd-MMM-yyyy"
                        if let d = inputFormatter.date(from: date) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "yyyy-MM-dd"
                            dateStr = outputFormatter.string(from: d)
                        } else {
                            dateStr = date
                        }
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss"
                        if let t = timeFormatter.date(from: time) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "hh:mm a"
                            timmee = outputFormatter.string(from: t)
                        } else {
                            timmee = time
                        }
                    }
                    
                    let msgType = firstData.type ?? EMPTY
                    
                    print("======== SOCKET PAYLOAD DATA ========")
                    print("MsgType: \(msgType)")
                    print("BookingID: \(String(describing: firstData.bookingId))")
                    print("Rating: \(String(describing: firstData.rating))")
                    print("Full data: \(json.arrayValue.first?.dictionaryValue ?? [:])")
                    print("=====================================")
                    
//                    var is_status = "1"
                    if msgType ==  "REJECTED" || msgType == "CANCELLED" || msgType == "PAYMENT_PENDING" || msgType == "SUGGESTED_TIME_PENDING"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "REQUESTED" && $0.bookingId == firstData.bookingId }) {
                            self.chatData.remove(at: index)
                        }
                    }
                    if msgType == "CONSULTATION_COMPLETED"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "CALL_ENDED" && $0.bookingId == firstData.bookingId }) {
                            self.chatData[index].is_status = "0"
//                            DispatchQueue.main.async {
//                                self.setUpChatData()
//                            }
                        }
                    }else if msgType == "PRESCRIPTION_SENT"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "CONSULTATION_COMPLETED" && $0.bookingId == firstData.bookingId }) {
                            self.chatData[index].is_status = "0"
//                            DispatchQueue.main.async {
//                                self.setUpChatData()
//                            }
                        }
                    }else if msgType == "CALL_STARTED"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "PAYMENT_COMPLETED" && $0.bookingId == firstData.bookingId }) {
                            self.chatData[index].is_status = "0"
//                            DispatchQueue.main.async {
//                                self.setUpChatData()
//                            }
                        }
                    }
                    else if msgType == "CALL_ENDED"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "CALL_ENDED" && $0.bookingId == firstData.bookingId }) {
                            self.chatData[index].is_status = "0"
//                            DispatchQueue.main.async {
//                                self.setUpChatData()
//                            }
                        }
                    }
                    if msgType == "RATING_SUBMITTED"{
                        if let index = self.chatData.lastIndex(where: { $0.msgType == "PRESCRIPTION_SENT" && $0.bookingId == firstData.bookingId }) {
                            self.chatData[index].rating = firstData.rating
                            DispatchQueue.main.async {
                                self.setUpChatData()
                            }
                        }
                    }else{
//                        self.chatData.append(ChatData(message: firstData.message ?? EMPTY, time: timmee, msgType: msgType, recieverType: recieverType, date: dateStr, id: firstData.id ?? EMPTY, isExpired: firstData.isExpired ?? 0, historyType: firstData.historyType, bookingId: firstData.bookingId, statusId: firstData.statusId, fees:firstData.fees, changedByType: firstData.changedByType, changedById: firstData.changedById, createdOn: dateToUse, rating: firstData.rating,prescription_url:firstData.prescription_url,is_status: firstData.is_status))
                        self.chatData.append(ChatData(message: firstData.message ?? EMPTY, time: timmee, msgType: msgType, recieverType: recieverType, date: dateStr, id: firstData.id ?? EMPTY, isExpired: firstData.isExpired ?? 0, historyType: firstData.historyType, bookingId: firstData.bookingId, statusId: firstData.statusId, fees:firstData.fees, changedByType: firstData.changedByType, changedById: firstData.changedById, createdOn: dateToUse, rating: firstData.rating,prescription_url:firstData.prescription_url,is_status: firstData.is_status ?? "1", booking_date: firstData.booking_date, booking_time: firstData.booking_time, is_follow_up: firstData.is_follow_up, follow_up_time: firstData.follow_up_time, is_videocall: firstData.is_videocall))
                    }
                        self.setscrollPosition()
                    self.messageTxt.text = EMPTY
                    self.setUpChatData()
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshScreen"), object: nil)
                }
            } catch {
                print("huihuhiuhi")
            }
        }
        
        SocketHelper.shared.on(with: .message) { (data) in
            print("call Back ============+>>>>>>>>>>>>>>>", data)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let chatModel = try JSONDecoder().decode([chat_Model].self, from: jsonData)
                if String(chatModel.first?.sender_id ?? EMPTY) == (self.senderId ?? EMPTY) {
                   print("HUIHUI")
                }else{
                    self.chatData.append(ChatData(message: chatModel.first?.message ?? EMPTY, time: Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date()), msgType: chatModel.first?.type ?? EMPTY, recieverType: "receiver", date: String((chatModel.first?.created_on ?? EMPTY).prefix(10))))
                }
                self.setscrollPosition()
                self.messageTxt.text = EMPTY
                self.setUpChatData()
            }catch{
                print("huihuhiuhi")
            }
        }
        
        SocketHelper.shared.on(with: .isOnline) { (data) in
            print(data, "IS ONLINE")
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let onlineData = try JSONDecoder().decode([Online_Model].self, from: jsonData)
                print(onlineData, "Onlince data")
                if onlineData.first?.senderId ?? EMPTY == self.senderId ?? EMPTY {
                    print("Online Data")
                }else{
                    self.isOnline = Bool(onlineData.first?.isOnline ?? "true") ?? true
                    if self.isOnline {
                        self.statusLbl.text = "online"
                        self.statusVw.backgroundColor = .systemGreen
                    }else{
//                        self.statusLbl.text = "offline"
                        self.statusLbl.text = "last active:  \(self.viewmodel.doctorChatData.first?.other_details?.last_active ?? "")"
                        self.statusVw.backgroundColor = UIColor(named: "PlaceHolderTextColor")
                    }
                    self.statusLbl.isHidden = false
                    self.statusVw.isHidden = false
                    self.dotLbl.isHidden = true
                }
            }catch{
                print("huihuhiuhi")
            }
        }
        
        SocketHelper.shared.on(with: .startTyping) { (data) in
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let startTypingData = try JSONDecoder().decode([Typing_Model].self, from: jsonData)
                print(startTypingData, "Start Typing data")
                if startTypingData.first?.senderId ?? EMPTY == self.senderId ?? EMPTY {
                    print(data, "Opposite is Typing")
                }else{
                    print(data, "IS TYPING")
                    self.statusLbl.text = "typing"
                    self.statusVw.backgroundColor = .systemGreen
                    self.statusLbl.isHidden = false
                    self.statusVw.isHidden = false
                    self.dotLbl.isHidden = false
                }
            }catch{
                print("huihuhiuhi")
            }
        }
        
        SocketHelper.shared.on(with: .endTyping) { (data) in
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let endTypingData = try JSONDecoder().decode([Typing_Model].self, from: jsonData)
                print(endTypingData, "End Typing Data")
                if endTypingData.first?.senderId ?? EMPTY == self.senderId ?? EMPTY {
                    print(data, "Opposite is End Typing")
                }else {
                    print(data, "IS END TYPING")
                    if self.isOnline {
                        self.statusLbl.text = "online"
                        self.statusVw.backgroundColor = .systemGreen
                    }else{
//                        self.statusLbl.text = "offline"
                        self.statusLbl.text = "last active:  \(self.viewmodel.doctorChatData.first?.other_details?.last_active ?? "")"
                        self.statusVw.backgroundColor = UIColor(named: "PlaceHolderTextColor")
                    }
                    self.statusLbl.isHidden = false
                    self.statusVw.isHidden = false
                    self.dotLbl.isHidden = true
                }
            }catch{
                print("huihuhiuhi")
            }
        }
        
        SocketHelper.shared.on(with: .didConnect) { data in
            print(data, "DID CONNECT")
            self.setUpRoom()
        }
        
        SocketHelper.shared.on(with: .roomJoin) { data in
            print(data, "ROOM JOIN CONNECTION ESTABLISHED")
            self.setUpOnline(isOnline: true)
        }
    }
    
    func timeDateConversion(formateDate:String) -> String {
        let dateFormatter = DateFormatter()
        let data = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local as TimeZone?
        var date = dateFormatter.date(from: formateDate)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            date = dateFormatter.date(from: formateDate)
        }
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date ?? data)
        return timeStamp
    }
    
    func setUpChatData(){
        self.groupByCategoryChat?.removeAll()
        self.keys.removeAll()
        self.groupByCategoryChat = Dictionary(grouping: self.chatData) { (device) -> String in
            return device.date ?? EMPTY
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        

        // Sorting the array
        let sortedDates = groupByCategoryChat?.keys.sorted { first, second in
            guard let firstDate = dateFormatter.date(from: first),
                  let secondDate = dateFormatter.date(from: second) else {
                return false
            }
            return firstDate < secondDate
        }
        if let keyy = sortedDates{
            for key in keyy {
                self.keys.append("\(key)")
            }
        }
        self.updateStickyStatusBar()
        self.chatTblVw.reloadData()
    }
    
    func setUpRoom(){
        var paramDict = [String: String]()
        paramDict["room_id"] = self.roomId ?? EMPTY
        paramDict["sender_id"] = self.senderId ?? EMPTY
        paramDict["reciver_id"] = self.recieverId ?? EMPTY
        SocketHelper.shared.emit(with: .roomJoin, paramDict){ data in
            print("room joined", data)
        }
    }
    
    func setUpOnline(isOnline: Bool){
        var passDic = [String: String]()
        passDic["room_id"] = self.roomId ?? EMPTY
        passDic["isOnline"] = "\(isOnline)"
        passDic["senderId"] = self.senderId ?? EMPTY
        passDic["recieverId"] = self.recieverId ?? EMPTY
        SocketHelper.shared.emit(with: EventListnerKeys.isOnline, passDic){_ in
            print("Is Online done")
        }
    }
    
    func startTyping(){
        var passDic = [String: String]()
        passDic["room_id"] = self.roomId ?? EMPTY
        passDic["senderId"] = self.senderId ?? EMPTY
        passDic["recieverId"] = self.recieverId ?? EMPTY
        SocketHelper.shared.emit(with: EventListnerKeys.startTyping, passDic){_ in
            print("Is Online done")
        }
    }
    
    func endTyping(){
        var passDic = [String: String]()
        passDic["room_id"] = self.roomId ?? EMPTY
        passDic["senderId"] = self.senderId ?? EMPTY
        passDic["recieverId"] = self.recieverId ?? EMPTY
        SocketHelper.shared.emit(with: EventListnerKeys.endTyping, passDic){_ in
            print("Is Online done")
        }
        self.setUpOnline(isOnline: true)
    }
    
    func setscrollPosition(){
        DispatchQueue.main.async {
            if self.isFromPagination{
                if self.groupByCategoryChat?.count ?? INTZERO > INTZERO {
                    self.chatTblVw.scrollToRow(at: IndexPath(row: (self.groupByCategoryChat?[self.keys[(self.groupByCategoryChat?.count ?? INTZERO) - 1]]?.count ?? INTZERO) - 1, section: (self.groupByCategoryChat?.count ?? INTZERO) - 1), at: .bottom, animated: true)
                }
            }else{
                //            let numberOfSections = self.chatTblVw.numberOfSections
                //            let numberOfRows = self.chatTblVw.numberOfRows(inSection: numberOfSections-1)
                //            let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections-1)
                //            self.chatTblVw.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
                
                
                guard let groupedChat = self.groupByCategoryChat, !groupedChat.isEmpty else { return }
                
                var targetIndexPath: IndexPath?
                if self.isFirstLoadScroll, let targetBookingId = self.bookingId, !targetBookingId.isEmpty {
                    for (sectionIndex, key) in self.keys.enumerated() {
                        if let chatsInSection = groupedChat[key] {
                            if let rowIndex = chatsInSection.firstIndex(where: { $0.bookingId == targetBookingId }) {
                                targetIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                                self.isFirstLoadScroll = false
                                break
                            }
                        }
                    }
                }
                
                if let indexPath = targetIndexPath {
                    self.chatTblVw.scrollToRow(at: indexPath, at: .top, animated: true)
                } else {
                    let lastSection = groupedChat.count - 1
                    let lastRow = (groupedChat[self.keys[lastSection]]?.count ?? 1) - 1
                    if lastSection >= 0 && lastRow >= 0 {
                        self.chatTblVw.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    func emitBookingStatusData(statusKey:EventListnerKeys = EventListnerKeys.booking_status_update,bookingStatus:String){
        var passDic = [String: String]()
        passDic["bookingId"] = self.bookingId ?? EMPTY
        passDic["doctorId"] = self.senderId ?? EMPTY
        passDic["patientId"] = self.recieverId ?? EMPTY
        passDic["status"] = bookingStatus
        SocketHelper.shared.emit(with: statusKey, passDic){_ in
            print("Sent Booking Status")
        }
    }
}
extension ChatViewC{
    func typeOn(string: String) {
        var characterArray = [Character]()
        string.forEach { Char in
            characterArray.append(Char)
        }
        var text = [Character]()
        var characterIndex = 0
        var charrr = ""
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
            while characterArray[characterIndex] == " " {
                text.append(" ")
                charrr += String(text.last!)
                self.dotLbl.text = charrr
                characterIndex += 1
                if characterIndex == characterArray.count {
                    timer.invalidate()
                    self.typeOn(string: ". . .")
                    return
                }
            }
            text.append(characterArray[characterIndex])
            charrr += String(text.last!)
            self.dotLbl.text = charrr
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
                self.typeOn(string: ". . .")
            }
        }
    }
}

struct Online_Model:Decodable {
    
    let isOnline: String?
    let roomId: Int?
    let senderId: String?
    let recieverId: String?
    
}

struct Typing_Model: Decodable {
    
    let roomId: Int?
    let senderId: String?
    let recieverId: String?
    
}

struct chat_Model: Decodable {
    
    let senderType: String?
    let created_on: String?
    let reciver_id: String?
    let sender_id: String?
    let message: String?
    let type: String?
    
}

struct ChatBookingStatus_Model: Decodable {
    
    let senderType: String?
    let created_on: String?
    let reciver_id: String?
    let sender_id: String?
    let message: String?
    let type: String?
    
}
