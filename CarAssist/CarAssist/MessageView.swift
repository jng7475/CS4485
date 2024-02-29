//
//  MessageView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: message.isUserMessage ? .center : .top) {
                    Image(systemName: message.isUserMessage ? "figure.stand" : "desktopcomputer")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                    Text(message.content)
                        .foregroundColor(.white)
                        .textSelection(.enabled)
                }
                .padding([.top, .bottom])
                .padding(.leading, 10)
            }
            Spacer()
        }
        .background(message.isUserMessage ? Color(red: 53/255, green: 54/255, blue: 65/255) : Color(red: 68/255, green: 70/255, blue: 83/255))
        .shadow(radius: message.isUserMessage ? 0 : 0.5)
        
    }
}
