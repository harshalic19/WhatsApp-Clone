//
//  ChatModel.swift
//  WhatsAppClone
//
//  Created by Harshali Chaudhari on 14/03/25.
//

import SwiftUI

struct ChatModel: Identifiable {
    
    var id: Int
    var chatuid: String
    var date: Date
    var message: String
    var messageFrom: String
    var messageTo: String
    var messagefromMe: Bool
}
