//
//  ChatViewC+ChatVw.swift
//  Dr.Live
//
//  Created by Kv on 24/12/24.
//

import Foundation
import UIKit

extension ChatViewC{
    func setUpChat(){
        SocketHelper.shared.on(with: .message) { (data) in
            print("call Back ============+>>>>>>>>>>>>>>>", data)
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let chatModel = try JSONDecoder().decode([chat_Model].self, from: jsonData)
                if String(chatModel.first?.sender_id ?? EMPTY) == (self.senderId ?? EMPTY) {
                   print("HUIHUI")
                }else{
                    self.chatData.append(ChatData(message: chatModel.first?.message ?? EMPTY, time: Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date()), msgType: chatModel.first?.type ?? EMPTY, recieverType: "receiver", date: String((chatModel.first?.created_on ?? EMPTY).dropLast(9))))
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
                        self.statusLbl.text = "offline"
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
                        self.statusLbl.text = "offline"
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
        let date = dateFormatter.date(from: formateDate)
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
        dateFormatter.dateFormat = "dd-MMM-yyyy"

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
            if self.groupByCategoryChat?.count ?? INTZERO > INTZERO {
                self.chatTblVw.scrollToRow(at: IndexPath(row: (self.groupByCategoryChat?[self.keys[(self.groupByCategoryChat?.count ?? INTZERO) - 1]]?.count ?? INTZERO) - 1, section: (self.groupByCategoryChat?.count ?? INTZERO) - 1), at: .bottom, animated: true)
            }
            //            let numberOfSections = self.chatTblVw.numberOfSections
            //            let numberOfRows = self.chatTblVw.numberOfRows(inSection: numberOfSections-1)
            //            let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections-1)
            //            self.chatTblVw.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
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
