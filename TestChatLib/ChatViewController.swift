//
//  ViewController.swift
//  TestChatLib
//
//  Created by Wilson Balderrama on 8/24/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
  var roomSelected: Room!
  var currentUser: User!
  var messages = [Message]()
  var listemMessagesHandleId: UInt = 0
}

extension ChatViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    listemMessagesHandleId = Message.getMessages(byRoomId: roomSelected.id) { [weak self] (messagesFound) in
      self?.messages = messagesFound
      self?.finishReceivingMessage(animated: true)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Message.stopListeningMessages(roomId: roomSelected.id, handleId: listemMessagesHandleId)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = roomSelected.name
    
    senderId = currentUser.id
    senderDisplayName = currentUser.username
  }
}

extension ChatViewController {
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    let message = Message(id: nil, senderUserId: senderId, senderUsername: senderDisplayName, roomId: roomSelected.id, text: text)
    messages.append(message)
    
    Message.createMessage(
      roomId: roomSelected.id,
      senderUserId: senderId,
      senderUsername: senderDisplayName,
      text: text) { (error, message) in
      
    }
    
    finishSendingMessage()
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
    let message = messages[indexPath.row]
    let messageUsername = message.senderUsername
    
    return NSAttributedString(string: messageUsername)
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
    return 15
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    
    let message = messages[indexPath.row]
    
    if currentUser.id == message.senderUserId {
      return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
    } else {
      return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    let message = messages[indexPath.row]
    let jsqMessage = JSQMessage(senderId: message.senderUserId, displayName: message.senderUsername, text: message.text)
    return jsqMessage
  }
}





































