////
////  SocketIOManager.swift
////  DeliveryBoy
////
////  Created by SinhaAirBook on 14/07/20.
////  Copyright © 2020 macbook. All rights reserved.
////
//
//import Foundation
//import SocketIO
//import RealmSwift
//import SwiftyJSON
//
//class SocketIOManager {
//     //let apiHandle = ApiHandler()
//     var socket : SocketIOClient!
//    let manager: SocketManager = SocketManager(socketURL: URL(string: "http://streettak.com:3008")!, config: [.log(true)])
//     var reloadList = {() -> () in }
//     var errorMessage = {(message : String) -> () in }
//
//    //MARK:- Notification Api Service Calling
//     var chatDataModel = [ChatDataModel]()
//    
//     func connectSocket(){
//        let realm = try! Realm()
//        let scope = realm.objects(UserDataModel.self).first
//        
//        self.manager.config = SocketIOClientConfiguration(
//            arrayLiteral: .connectParams(["Authorization": UserDefaults.standard.string(forKey: Constants.accessToken)]))
//        socket.connect()
//     }
//    
//      func disconnectSocket(){
//        socket.disconnect()
//      }
//    
//     func socketHandling(id:String){
//        socket = manager.defaultSocket
//        let socketConnectionStatus = socket.status
//        switch socketConnectionStatus {
//        case SocketIOStatus.connected:
//            print("socket connected")
//        case SocketIOStatus.connecting:
//            print("socket connecting")
//        case SocketIOStatus.disconnected:
//            socket.connect()
//            print("socket disconnected")
//        case SocketIOStatus.notConnected:
//            socket.connect()
//            print("socket not connected")
//        }
//        socket.on(clientEvent: .connect) { (data, ack) in
//            
//            print("socket connected")
//            
//            print("RoomId: \(id)")
//            
//            self.socket.emit("room join", ["roomId":id])
//        }
//        
//        socket.on("room join") { (data, ack) in
//            
//            print("Room Joined")
//            
//        }
//        socket.onAny { (event) in
//            print("The event is: \(event.event)")
//        }
//        
//        socket.on("message") { (data, ack) in
//            //self.getChatHistoryService(roomId: id)
//        }
//    }
//    
////    func getChatHistoryService(roomId: String) {
////        let realm = try! Realm()
////        let scope = realm.objects(UserDefaults.standard.string(forKey: Constants.accessToken))
////        let header = ["Authorization":scope?.Token] as! [String:String]
////        apiHandle.fetchApiService(method: .post, url: Domain.chatHistoryUrl() + APIEndpoint.getChatHistory, passDict: ["roomId" : roomId], header: header) { (result) in
////
////            switch result{
////
////            case .success(let data):
////
////                print(data)
////
////                if data["status"].intValue == 200 {
////
////                    if self.chatDataModel.count > 0 {
////                        self.chatDataModel.removeAll()
////                    }
////                    self.chatDataModel.append(ChatHistoryModel(data))
////                    self.reloadList()
////                }else{
////                    self.errorMessage(data["message"].stringValue)
////                }
////                break
////            case .failure(let error):
////                self.errorMessage(error.localizedDescription)
////            }
////
////        }
////    }
//}
