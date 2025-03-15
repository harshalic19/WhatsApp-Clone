//
//  ChatView.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 14/03/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

struct ChatView: View {
    
    let db = Firestore.firestore()
    var chatWithUser: UserModel
    @State var message:  String = ""
    @ObservedObject var chatStore = Chatstore()
    
    var body: some View {
        VStack{
            ScrollView {
                ForEach(chatStore.chatsArray) { chats in
                    ChatRow(chatModel: chats, chatTouserModel: self.chatWithUser)
                }
            }
            
            HStack {
                TextField("Type here...", text: $message).frame(minHeight: 30).padding()
                Button("Send") {
                    //code for Sending a message
                    sendMessage()
                }.frame(minHeight: 50).padding()
            }.border(.gray, width: 1).padding()
        }
    }
    
    func sendMessage() {
        var ref: DocumentReference? = nil
        
        let chatDictionary: [String: Any] = ["chatFromUser": Auth.auth().currentUser!.uid,"chatWithUser": chatWithUser.useruid,"date": generateDate(), "message": self.message]
        
        ref = self.db.collection("Chats").addDocument(data: chatDictionary, completion: { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.message = ""
            }
        })
    }
    
    func generateDate() -> String {
        let formatter =  DateFormatter()
        
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
}

#Preview {
    ChatView(chatWithUser: UserModel(id: 0, useruid: "123456", username: "abcd", useremail: "abcd@gmail.com"))
}
