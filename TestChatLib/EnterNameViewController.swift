//
//  EnterNameViewController.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

class EnterNameViewController: UIViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowRooms" {
      let navigationController = segue.destination as? UINavigationController
      let roomsViewController = navigationController?.viewControllers.first as? ChatRoomsViewController
      roomsViewController?.currentUser = sender as? User
    }
  }
  
  @IBAction func enterTouched() {
    if let username = usernameTextField.text {
      User.createUser(
        username: username
      ) { [weak self] (error, user) in
        if error == nil {
          self?.performSegue(withIdentifier: "ShowRooms", sender: user)
        }
      }
    }
  }
}
