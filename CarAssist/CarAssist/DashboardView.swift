//
//  DashboardView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/21/24.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var carInfo = CarInfo.shared
    @State var showReportField = false
    var body: some View {
        NavigationView {
            
            VStack {
                ZStack {
                    LinearGradient(colors: [.darkPurple, .lightPink, .lightPurple], startPoint: UnitPoint(x: 0.1, y: 0.1), endPoint: UnitPoint(x: 0.9, y: 0.9))
                        .background(.ultraThickMaterial)
                        .clipShape(Circle())
                        .padding()
                        .blur(radius: 90)
                    Image(carInfo.imageName)
                        .resizable()
                        .scaledToFit()
                }
                
                HStack {
                    Text(carInfo.carName)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 36)
                .padding(.top, -12)
                
                
                HStack {
                    Text(carInfo.license)
                        .foregroundColor(.gray.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 36)
                .padding(.top, -6)
                
                
                Divider()
                    .padding()
                    .padding(.horizontal, 16)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .background {
                //HUD Content
                //            LinearGradient(colors: [
                //                .background,
                //                .darkPurple
                //            ],
                //                           startPoint: UnitPoint(x: 0, y: 0.5),
                //                           endPoint: UnitPoint(x: 1, y: 1))
                backgroundGradient
                    .ignoresSafeArea()
            }
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
}

#Preview {
    DashboardView()
}
