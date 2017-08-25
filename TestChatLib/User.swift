//
//  User.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
  let id: String
  let username: String
}


extension User {
  
  static let ref = Database.database().reference()
  
  static func createUser(
    username: String,
    completion: @escaping (Error?, User?) -> Void
  ) {
    let refUsers = ref.child("users")
    let refUser = refUsers.childByAutoId()
    
    var data = [String: Any]()
    data["username"] = username
    data["id"] = refUser.key
    
    refUser.setValue(data) { (error, ref) in      
      if error != nil {
        completion(error, nil)
      } else {
        let user = User(id: refUser.key, username: username)
        completion(nil, user)
      }
    }
  }
}























