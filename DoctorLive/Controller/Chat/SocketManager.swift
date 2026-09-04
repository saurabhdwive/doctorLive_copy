//
//  SocketManager.swift
//  LiveTracking
//
//  Created by Gaurav Gupta on 03/05/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

enum EventListnerKeys : String {
    case didConnect = "connect"
    case didDisConnect = "disconnect"
    case handshakeWithServer = "handshakeWithServer"
    case eventAck = "eventAck"
    case syncStatus = "Sync.status"
    case shareLocation = "Sync.shareLocation"
    case updateCurrentLocation = "Sync.updateCurrentLocation"
    case authentication = "authentication"
    case authenticated = "authenticated"
    case unauthorized = "unauthorized"
    case connectionEstablished = "connection-established"
    case roomJoin = "room_join"
    case message = "message"
    case roomLeave = "room_leave"
    case messageRead = "message_read"
    case chatHistory = "chat_history"
    case isOnline    = "is_online"
    case startTyping = "start_typing"
    case endTyping = "end_typing"
    case update_doctor_status = "update_doctor_status"
}


class SocketHelper: NSObject {
    typealias JSONDictionary = [String : Any]
    private var socket: SocketIOClient?
    private var manager: SocketManager?
    var didConnectSocket : Bool = false
    enum SocketCodes : Int
    {
        case SocketSuccess = 200
    }
    
    private var socketRetryCounter = 0
    static let shared = SocketHelper()
    
    fileprivate var socketHandlerArr = [((()->Void))]()
    typealias ObjBlock = @convention(block) () -> ()
    
    private override init() {
        super.init()
        self.initializeSocket()
    }
    
    private func initializeSocket(){
        
        let params: JSONDictionary = ["authorization": UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""]
        
        self.manager = SocketManager(socketURL: URL(string: "http://18.224.216.53:4000")!, config: [.log(true), .forcePolling(true), .forceNew(true), .connectParams(params)])
        self.socket = manager?.defaultSocket
    }
    
    func connectSocket(handler:(()->Void)? = nil){
        if let status = self.socket?.status {
            if status == .connected {
                handler?()
                return
            }
            else {
                if let handlr = handler {
                    if !self.socketHandlerArr.contains(where: { (handle) -> Bool in
                        let obj1 = unsafeBitCast(handle as ObjBlock, to: AnyObject.self)
                        let obj2 = unsafeBitCast(handlr as ObjBlock, to: AnyObject.self)
                        return obj1 === obj2
                    }) {
                        self.socketHandlerArr.append(handlr)
                    }
                }
                if self.socket?.status != .connecting {
                    
                    self.socket?.on(EventListnerKeys.didConnect.rawValue) {[weak self] data, ack in
                        
                        let params: JSONDictionary = ["token": UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""]
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            if !(self?.didConnectSocket ?? false) {
                                self?.didConnectSocket = true
                                self?.emit(with: EventListnerKeys.authentication, params)
                                self?.emit(with: EventListnerKeys.connectionEstablished, params)
                            }
                        }
                    }
                self.socket?.on(EventListnerKeys.authenticated.rawValue) {[weak self] data, ack in
                        guard let self = self else {return}
                        debugPrint("********Gaurav**********")
                        
                    }
                    
                    self.socket?.on(EventListnerKeys.didDisConnect.rawValue) { data, ack in
                        self.initializeSocket()
                    }
                    self.socket?.connect()
                }
            }
        }
    }
    
    func closeConnection() {
        socket?.disconnect()
    }
    
    //MARK:- Emit
    func emit(with event: EventListnerKeys , _ params : JSONDictionary?, response: ((JSON) -> Void)? = nil){
        
        self.connectSocket(handler: {
            self.emitWithACK(withTimeoutAfter: 500000, event: event, params: params, array: nil)
        })
        socket?.onAny { (event) in
            print("The event is: \(event.event)")
        }
        
    }
    
    
    //    func emitWithString(with event: EventListnerKeys , _ params : String?, response: ((JSON) -> Void)? = nil){
    //
    //        self.connectSocket(handler: {
    //            self.emitWithACK(withTimeoutAfter: 20, event: event, params: params, array: nil)
    //        })
    //    }
    
    func emitArray(with event: EventListnerKeys , _ array : [String]){
        
        self.connectSocket(handler: {
            self.emitWithACK(withTimeoutAfter: 20, event: event, params: nil, array: nil)
        })
    }
    
    func on(with event: EventListnerKeys, completion: @escaping (([Any]) -> ())) {
        
        SocketHelper.shared.socket?.on(event.rawValue, callback: { (data, emitter) in
            completion(data)
        })
    }
    
    func off(with event: EventListnerKeys) {
        SocketHelper.shared.socket?.off(event.rawValue)
    }
    
    
    private func emitWithACK(withTimeoutAfter seconds: Double, event: EventListnerKeys, params : JSONDictionary?, array:[Any]?){
        var ack : OnAckCallback? = nil
        if let tempParams = params{
            ack = self.socket?.emitWithAck(event.rawValue, tempParams)
        }else if let tempArray = array{
            ack = self.socket?.emitWithAck(event.rawValue, tempArray)
        }else{
            ack = self.socket?.emitWithAck(event.rawValue)
        }
        
        if event == .authentication {
            socketRetryCounter += 1
        }
        
        //        if socketRetryCounter == 6 {
        //            socketRetryCounter = 0
        //            connectSocket()
        //        }
        
        if socketRetryCounter == 2 {
            socketRetryCounter = 0
            // closeConnection()
            // DispatchQueue.delay(1) {
            //    self.connectSocket()
            //}
        }
        ack?.timingOut(after: seconds, callback: { (data) in
        })
    }
}



