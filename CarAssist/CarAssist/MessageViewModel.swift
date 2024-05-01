//
//  MessageVM.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import Foundation

class MessageViewModel: ObservableObject {
    
    let apiUrl = ""
    
    @Published var messages = [Message]()
    
    func sendMessage(text: String) {
        messages.append(Message(content: text, isUserMessage: true))
        messages.append(Message(content: "Sorry I cannot assist right now", isUserMessage: false))
    }
    
    func getResponse(text: String) async {
        self.addMessage(text, isUserMessage: true)
        self.addMessage("", isUserMessage: false)
        
        do {
            if let generatedText = try await makeTextGenerationRequest(text: text) {
                DispatchQueue.main.async {
                    self.messages[self.messages.count - 1].content += generatedText
                    for message in self.messages {
                        print(message)
                    }
                }
            }
        } catch {
            self.addMessage(error.localizedDescription, isUserMessage: false)
        }
    }
    
    private func makeTextGenerationRequest(text: String) async throws -> String? {
        guard let url = URL(string: apiUrl+"?input=\(text)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)
        
        return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\n", with: "\n")

    }
    
    private func addMessage(_ content: String, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty, just add a new message
            let message = Message(content: content, isUserMessage: isUserMessage)
//            print("DEBUGG: \(message)")
            self.messages.append(message)
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
}
