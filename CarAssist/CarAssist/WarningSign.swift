//
//  WarningSign.swift
//  CarAssist
//
//  Created by Khang Nguyen on 3/21/24.
//

import SwiftUI

struct WarningSign: View {
    var severity: SignSeverity = .warning
    var text: String = "Warning"
    
    var body: some View {
        Rectangle()
            .foregroundColor(colorFrom(severity: severity))
            .frame(width: 200, height: 250)
            .cornerRadius(20)
            .overlay {
                ZStack {
                    Text(text)
                        .foregroundColor(severity == .informative ? .black : .white)
                        .fontWeight(.bold)
                        .font(.system(size: 33))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 175, height: 225)
                }
            }
            .opacity(0.8)
    }
    
    func colorFrom(severity: SignSeverity)-> Color {
        switch severity {
        case .informative:
            return .white
        case .critical:
            return .red
        default:
            return .orange
        }
    }
}
