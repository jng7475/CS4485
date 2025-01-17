//
//  AuthenticationView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/22/24.
//

import SwiftUI

import SwiftUI
import Combine

struct AuthenticationView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel

  var body: some View {
    VStack {
      switch viewModel.flow {
      case .login:
        LoginView()
          .environmentObject(viewModel)
      case .signUp:
        SignupView()
          .environmentObject(viewModel)
      }
    }
    .background {
        Color.backgroundGradient
    }
    .preferredColorScheme(.dark)
  }
}

#Preview {
    AuthenticationView()
}
