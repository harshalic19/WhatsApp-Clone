//
//  ContentView.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 13/03/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AuthView: View {
    
    let db = Firestore.firestore()
    @ObservedObject var userstore = UserStore()
    
    @State var useremail: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var showAuthView: Bool = true
    
    var body: some View {
        NavigationView {
            
            if showAuthView {
                List {
                    Text("WhatsApp Clone").font(.largeTitle).bold()
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "User Email")
                        TextField("", text: $useremail)
                    }
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "Password")
                        TextField("", text: $password)
                    }
                    
                    VStack(alignment: .leading) {
                        SectionView(title: "Username")
                        TextField("", text: $username)
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                //Sign In Action //Navigation to user Screen
                                Auth.auth().signIn(withEmail: self.useremail, password: self.password) { result, error in
                                    if let error = error {
                                        print("Error adding document: \(error)")
                                    } else {
                                        //Navigation to user Screen
                                        self.showAuthView = false
                                    }
                                }
                            } label: {
                                Text("Sign In")
                            }
                            Spacer()
                        }
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                //Sign Up Action
                                Auth.auth().createUser(withEmail: self.useremail, password: self.password) { result, error in
                                    if let error = error {
                                        print("Error adding document: \(error)")
                                    } else {
                                        // User Created in Firebase database
                                        var ref: DocumentReference? = nil
                                        
                                        let userData = ["useremail": self.useremail, "username": self.username, "useruid": result!.user.uid]
                                        
                                        ref = self.db.collection("Users").addDocument(data: userData, completion: { error in
                                            if let error = error {
                                                print("Error adding document: \(error)")
                                            }
                                        })
                                        
                                        //Navigation to user Screen
                                        self.showAuthView = false
                                        
                                    }
                                }
                            } label: {
                                Text("Sign Up")
                            }
                            Spacer()
                        }
                    }
                }
            } else {
                //User Screen
                NavigationView {
                    List(userstore.users) { user in
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
                            Text("Sign Up")
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView(showAuthView: false)
}


struct SectionView: View {
    
    var title: String
    
    var body: some View {
        Section {
            Text(self.title)
        }
    }
}
