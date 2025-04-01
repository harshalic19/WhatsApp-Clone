//
//  ChatsListScreen.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 16/03/25.
//

import SwiftUI
import FirebaseAuth

struct ChatsListScreen: View {
    
    @State var users: [UserModel]
    
    var body: some View {
        //User Screen
        NavigationView {
            List(users) { user in
                NavigationLink {
                    //Navigate to ChatView
                    ChatView(chatWithUser: user)
                } label: {
                    Text(user.username)
                }
            }
        }.navigationTitle(Text("Chat with Users!"))
            .toolbar{
                Button {
                    //log out code
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        
                    }
                } label: {
                    Text("Log out")
                }
            }

    }
}

#Preview {
    ChatsListScreen(users: [])
}
