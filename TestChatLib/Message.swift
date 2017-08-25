//
//  Message.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Message {
  var id: String!
  var senderUserId: String
  var senderUsername: String
  var roomId: String
  var text: String  
}

extension Message {
  
  static let ref = Database.database().reference()
  
  static func createMessage(
    roomId: String,
    senderUserId: String,
    senderUsername: String,
    text: String,
    completion: @escaping (Error?, Message?) -> Void
  ) {
    let refMessages = ref.child("messages")
    let refRoom = refMessages.child(roomId)
    let refMessage = refRoom.childByAutoId()
    
    var data = [String: Any]()
    data["id"] = refMessage.key
    data["senderUserId"] = senderUserId
    data["roomId"] = roomId
    data["senderUsername"] = senderUsername
    data["text"] = text
    
    refMessage.setValue(data) { (error, ref) in
      if let error = error {
        completion(error, nil)
      } else {
        let message = Message(
          id: refMessage.key,
          senderUserId: senderUserId,
          senderUsername: senderUsername,
          roomId: roomId,
          text: text
        )
        
        completion(nil, message)
      }
    }
  }
  
  static func stopListeningMessages(
    roomId: String,
    handleId: UInt
  ) {
    let refMessages = ref.child("messages")
    let refRoom = refMessages.child(roomId)
    
    refRoom.removeObserver(withHandle: handleId)
  }
  
  static func getMessages(
    byRoomId roomId: String,
    completion: @escaping ([Message]) -> Void
  ) -> UInt {
    let refMessages = ref.child("messages")
    let refRoom = refMessages.child(roomId)
    
    
    return refRoom.observe(.value, with: { (snap) in
      var messages = [Message]()
      
      if let objects = snap.children.allObjects as? [DataSnapshot]
      {
        for children in objects {
          if
            let json = children.value as? [String: Any],
            let id = json["id"] as? String,
            let senderUserId = json["senderUserId"] as? String,
            let roomId = json["roomId"] as? String,
            let senderUsername = json["senderUsername"] as? String,
            let text = json["text"] as? String
          {
            let message = Message(
              id: id,
              senderUserId: senderUserId,
              senderUsername: senderUsername,
              roomId: roomId,
              text: text
            )
            
            messages.append(message)
          }
        }
      }
      print(messages.count)
      completion(messages)
    })
  }
  
}





























