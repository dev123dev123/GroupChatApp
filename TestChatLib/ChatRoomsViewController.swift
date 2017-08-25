//
//  ChatRoomsViewController.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit



class ChatRoomsViewController: UITableViewController {
  var currentUser: User?
  var rooms = [Room]()
  let cellRoomId = "RoomId"
  
  @IBAction func newRoomTouched(_ sender: Any) {
    performSegue(withIdentifier: "ShowCreateRoom", sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    Room.getAllRooms { [weak self] (roomsFound) in
      self?.rooms = roomsFound
      
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChat" {
      let destination = segue.destination as? ChatViewController
      destination?.roomSelected = sender as? Room
      destination?.currentUser = currentUser
    }
  }
}

extension ChatRoomsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let room = rooms[indexPath.row]
    
    performSegue(withIdentifier: "ShowChat", sender: room)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rooms.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellRoomId)!
    
    let room = rooms[indexPath.row]
    cell.textLabel?.text = room.name
    
    return cell
  }
}
































