//
//  NewRoomViewController.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

class NewRoomViewController: UIViewController {
  
  @IBOutlet weak var roomNameTextField: UITextField!
  
  @IBAction func createTouched(_ sender: Any) {
    let roomName = roomNameTextField.text
    
    if let roomName = roomName {
      Room.createRoom(
        name: roomName
      ) { [weak self] (error) in
        if error == nil {
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  
}
