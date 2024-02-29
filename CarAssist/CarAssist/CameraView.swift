//
//  CameraView.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/29/24.
//

import SwiftUI
import ARKit
import RealityKit

struct CameraView: View {
    var body: some View {
        ARViewContainer()
            .ignoresSafeArea()
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
