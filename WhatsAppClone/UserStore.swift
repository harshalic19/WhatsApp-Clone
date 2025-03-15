//
//  UserStore.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 14/03/25.
//

import SwiftUI
import FirebaseFirestore
import Combine

class UserStore: ObservableObject {
    
    let db = Firestore.firestore()
    var users: [UserModel] = []
    
    var objectWillChange = PassthroughSubject<Array<Any>, Never>()
    
    init() {
        
        db.collection("Users").addSnapshotListener { [self] snapshot, error in
            if let error = error {
                
            } else {
                self.users.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    if let useruid = document.get("useruid") as? String {
                        if let username = document.get("username") as? String {
                            if let useremail = document.get("useremail") as? String {
                                let currentIndex = self.users.last?.id
                                
                                let createdUser = UserModel(id: (currentIndex ?? -1) + 1, useruid: useruid, username: username, useremail: useremail)
                                
                                self.users.append(createdUser)
                            }
                        }
                    }
                }
                self.objectWillChange.send(self.users)
            }
        }
     
    }
}
