//
//  ChatView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import SwiftUI

struct ChatView: View {

    @ObservedObject var messageVM = MessageVM()
    @State var typingMessage: String = ""
    @Namespace var bottomID
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        NavigationView() {
            VStack(alignment: .leading) {
                if !messageVM.messages.isEmpty {
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(messageVM.messages) { message in
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        .onChange(of: messageVM.messages.last?.content as? String) {
                            DispatchQueue.main.async {
                                withAnimation {
                                    reader.scrollTo(bottomID)
                                }
                            }
                        }
                        .onChange(of: messageVM.messages.count) {
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("I'm here if you need my help")
                            .font(.subheadline)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                HStack(alignment: .center) {
                    TextField("Start typing...", text: $typingMessage, axis: .vertical)
                        .focused($fieldIsFocused)
                        .padding()
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
                .cornerRadius(12)
                .padding([.leading, .trailing, .bottom], 10)
                .shadow(color: .black, radius: 0.5)
            }
            .background(backgroundGradient.ignoresSafeArea())
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
            .navigationTitle("ToyotAssistant")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
                    gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0.03252160834, green: 0.02643362032, blue: 0.0463338862, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 0, y:-0.0),
                    endPoint: UnitPoint(x: 0.5, y:1.0))
    }
    

    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        hideKeyboard()
        messageVM.sendMessage(text: tempMessage)
        
//        Task {
//            await messageVM.getResponse(text: tempMessage)
//        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
