//
//  SettingsView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    var body: some View {
        VStack {
            Button {
                authVM.signOut()
            } label: {
                Text("SIGN OUT")
            }
        }
    }
}
