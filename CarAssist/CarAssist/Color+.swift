//
//  Color+.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/21/24.
//

import Foundation
import SwiftUI

extension Color {
//    static var backgroundColor: Color {
//        Color("backgroundColor")
//    }
    
//    static var lightGreenColor: Color {
//        Color("lightGreen")
//    }
    static var backgroundGradient: LinearGradient {
        LinearGradient(
                    gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0.03252160834, green: 0.02643362032, blue: 0.0463338862, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 0, y:-0.0),
                    endPoint: UnitPoint(x: 0.5, y:1.0))
    }
    
}
