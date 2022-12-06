//
//  SocketIOManager.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import Foundation
import SocketIO

class SocketIOManager {
    
    static let shared = SocketIOManager()
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private init() {
        
        manager = SocketManager(socketURL: URL(string: "http://api.sesac.co.kr:1210")!, config: [
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        
        // 연결
        // (채팅 수신을 위해) 소켓이 연결(connect)된 직후 “changesocketid” 이벤트를 사용자(본인)의 uid와 함께 방출(emit)해야함
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", "7tAqBYumg6UPyIfy4fMqfXQRoar1")
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        //이벤트 수신
        socket.on("chat") { (dataArray, ack) in
            print("CHAT RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            print("CHECK >>>", chat, from, createdAt)
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["id": id, "chat": chat, "createdAt": createdAt, "from": from, "to": to])
        }
    }

    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
