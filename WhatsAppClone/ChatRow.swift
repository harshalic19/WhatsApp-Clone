//
//  ChatRow.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 14/03/25.
//

import SwiftUI
import FirebaseAuth

struct ChatRow: View {
    
    var chatModel: ChatModel
    var chatTouserModel: UserModel
    
    var body: some View {
        
        Group {
            
            if let currentUser = Auth.auth().currentUser {
                //Message from Logged User to friend and only the message between them not other users
                if chatModel.messageFrom == currentUser.uid && chatModel.messageTo == chatTouserModel.useruid {
                    HStack {
                        VStack {
                            Text(chatModel.message)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                        }.background(.cyan)
                        
                        Spacer()
                    }.background(.clear)
                } else if chatModel.messageFrom ==  chatTouserModel.useruid && chatModel.messageTo == currentUser.uid{
                    //Message from friend to Logged User and only the message between them not other users
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text(chatModel.message)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                        }.background(.green)
                    }.background(.clear)
                }
            }
        }.frame(width: UIScreen.main.bounds.width * 0.85)
    }
}

#Preview {
    ChatRow(chatModel: ChatModel(id: 0, chatuid: "dsfsdfsd", date: Date(), message: "Hello", messageFrom: "aa", messageTo: "bb", messagefromMe: true), chatTouserModel: UserModel(id: 0, useruid: "dsfsdvs", username: "Martha", useremail: "marth@123.com"))
}
