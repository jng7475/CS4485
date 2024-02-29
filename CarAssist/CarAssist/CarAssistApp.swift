//
//  CarAssistApp.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/21/24.
//

import SwiftUI
import SwiftUI
import Firebase
//import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CarAssistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            VStack {
                AuthenticatedView {
                    Image(systemName: "car.fill")
                        .resizable()
                        .frame(width: 100 , height: 100)
                        .foregroundColor(Color(.systemPink))
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .clipped()
                        .padding(4)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    Text("Welcome to CarAssist!")
                        .font(.title)
                    Text("You need to be logged in to use this app.")
                } content: {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background {
                Color.backgroundGradient
            }
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
        }
    }
}
