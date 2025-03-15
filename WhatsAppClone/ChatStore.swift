//
//  ChatStore.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 14/03/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

class Chatstore: ObservableObject {
    
    let db = Firestore.firestore()
    var chatsArray: [ChatModel] = []
    
    var objectWillChange = PassthroughSubject<Array<Any>, Never>()
    
    init() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        //checking if chat is from logged user (messagefromMe = true) and getting sent chat
        self.db.collection("Chats").whereField("chatFromUser", isEqualTo: Auth.auth().currentUser!.uid).order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                self.chatsArray.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    
                    let chatuid = document.documentID
                    if let message = document.get("message") as? String {
                        if let messageFrom = document.get("chatFromUser") as? String {
                            if let messageTo = document.get("chatWithUser") as? String {
                                if let dateString = document.get("date") as? String {
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                    let date = formatter.date(from: dateString)
                                    
                                    let chatIndex = self.chatsArray.last?.id
                                    
                                    let sentChatModel = ChatModel(id: (chatIndex ?? -1 ) + 1, chatuid: chatuid, date: date!, message: message, messageFrom: messageFrom, messageTo: messageTo, messagefromMe: true)
                                    
                                    self.chatsArray.append(sentChatModel)
                                }
                            }
                        }
                    }
                }
                
                //checking if chat is to logged user (messagefromMe = false) and getting received chat
                self.db.collection("Chats").whereField("chatWithUser", isEqualTo: Auth.auth().currentUser!.uid).order(by: "date", descending: true).addSnapshotListener { snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        for document in snapshot!.documents {
                            
                            let chatuid = document.documentID
                            if let message = document.get("message") as? String {
                                if let messageFrom = document.get("chatFromUser") as? String {
                                    if let messageTo = document.get("chatWithUser") as? String {
                                        if let dateString = document.get("date") as? String {
                                            
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                            let date = formatter.date(from: dateString)
                                            
                                            let chatIndex = self.chatsArray.last?.id
                                            
                                            let receivedChatModel = ChatModel(id: (chatIndex ?? -1 ) + 1, chatuid: chatuid, date: date!, message: message, messageFrom: messageFrom, messageTo: messageTo, messagefromMe: false)
                                            
                                            self.chatsArray.append(receivedChatModel)
                                        }
                                    }
                                }
                            }
                        }
                        
                        self.objectWillChange.send(self.chatsArray)
                    }
                }
            }
        }
    }
}
