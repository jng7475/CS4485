//
//  Message.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id = UUID()
    var content: String
    let isUserMessage: Bool

//    static func ==(lhs: Message, rhs: Message) -> Bool {
//        return lhs.id == rhs.id && lhs.content == rhs.content && lhs.isUserMessage == rhs.isUserMessage
//    }
}
    
