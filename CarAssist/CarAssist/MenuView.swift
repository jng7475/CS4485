//
//  MenuView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "car.side.fill")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear.circle")
                }
        }
    }
}
