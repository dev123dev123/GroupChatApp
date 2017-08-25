//
//  Room.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Room {
  var id: String
  var name: String  
}

extension Room {
  
  static let ref = Database.database().reference()
  
  static func createRoom(
    name: String,
    completion: @escaping (Error?) -> Void
  ) {
    let refRooms = ref.child("rooms")
    let refRoom = refRooms.childByAutoId()
    
    var data = [String: Any]()
    data["id"] = refRoom.key
    data["name"] = name
    
    refRoom.setValue(data) { (error, ref) in
      completion(error)
    }
  }
  
  static func getAllRooms(
    completion: @escaping ([Room]) -> Void
  ) {
    let refRooms = ref.child("rooms")
    var rooms = [Room]()
    
    refRooms.observeSingleEvent(of: .value, with: { (snap) in
      if snap.exists() {
        for children in snap.children.allObjects as! [DataSnapshot] {
          if
            let json = children.value as? [String: Any],
            let name = json["name"] as? String,
            let id = json["id"] as? String
          {
            let room = Room(id: id, name: name)
            
            rooms.append(room)
          }
        }
      }
      
      completion(rooms)
    })
  }
  
}




















