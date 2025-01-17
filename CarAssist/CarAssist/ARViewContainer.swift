//
//  ARViewContainer.swift
//  CarAssist
//
//  Created by Khang Nguyen on 3/21/24.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var results: ScanResults
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = context.coordinator.arView
        
        let config = ARWorldTrackingConfiguration()
        
        config.userFaceTrackingEnabled = true
        arView.session.delegate = context.coordinator
        context.coordinator.setupVision()
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arView: ARView(frame: .zero), parent: self, results: results)
    }
    
    class Coordinator: NSObject, ObservableObject, ARSessionDelegate {
        var arView: ARView
        private var requests = [VNRequest]()
        var bufferSize: CGSize = .zero
        var speechController = SpeechManger()
        var timer: Timer?
        private var scannedResults: ScanResults
        var resultTime: Date = Date.now
        
        var parent: ARViewContainer
        
        var cancellables = Set<AnyCancellable>()
        
        init(arView: ARView, parent: ARViewContainer, results: ScanResults) {
            self.arView = arView
            self.parent = parent
            self.scannedResults = results
            
            super.init()
        }
        
        // Process each frame
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            let exifOrientation = exifOrientationFromDeviceOrientation()
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: exifOrientation, options: [:])
            do {
                try imageRequestHandler.perform(self.requests)
            } catch {
                print(error)
            }
        }
        
        public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
            let curDeviceOrientation = UIDevice.current.orientation
            let exifOrientation: CGImagePropertyOrientation
            
            switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .left
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .upMirrored
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .down
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .up
            default:
                exifOrientation = .up
            }
            return exifOrientation
        }
        
        @discardableResult
        func setupVision() -> NSError? {
            let error: NSError! = nil
            
            guard let modelURL = Bundle.main.url(forResource: "SignModel06 Iteration 15150", withExtension: "mlmodelc") else {
                return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
            }
            do {
                let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
                let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                    DispatchQueue.main.async(execute: {
                        if let results = request.results {
                            self.classifyResults(results)
                        }
                    })
                })
                self.requests = [objectRecognition]
            } catch let error as NSError {
                print("Model loading went wrong: \(error)")
            }
            
            return error
        }
        
        func classifyResults(_ results: [Any]) {
            if Date.now.timeIntervalSince(resultTime) > 1 {
                for observation in results where observation is VNRecognizedObjectObservation {
                    guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                        continue
                    }
                    // Select only the label with the highest confidence.
                    let topLabelObservation = objectObservation.labels[0]
                    let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
                    
                    print(topLabelObservation.identifier)
                    switch topLabelObservation.identifier {
                    case "W11-2":
                        if scannedResults.signType != .pedestrianCrossing {
                            scannedResults.signType = .pedestrianCrossing
                            scannedResults.severity = .warning
                            speechController.speak(text: "Caution, pedestrian crossing ahead", urgency: .warning)
                        }
                    case "R1-1":
                        if scannedResults.signType != .stopSign {
                            scannedResults.signType = .stopSign
                            scannedResults.severity = .warning
                            speechController.speak(text: "Stop sign ahead", urgency: .warning)
                        }
                    case "R5-1":
                        if scannedResults.signType != .doNotEnter {
                            scannedResults.signType = .doNotEnter
                            scannedResults.severity = .informative
                            speechController.speak(text: "Do not enter", urgency: .informative)
                        }
                    case "R1-2":
                        if scannedResults.signType != .yield {
                            scannedResults.signType = .yield
                            scannedResults.severity = .warning
                            speechController.speak(text: "Caution, yield to other traffic", urgency: .warning)
                        }
                    case "R2-140":
                        if scannedResults.signType != .spdlmt40 {
                            scannedResults.signType = .spdlmt40
                            scannedResults.severity = .informative
                            speechController.speak(text: "Speed limit 40 miles per hour", urgency: .informative)
                        }
                    case "R2-125":
                        if scannedResults.signType != .speedLimit25 {
                            scannedResults.signType = .speedLimit25
                            scannedResults.severity = .informative
                            speechController.speak(text: "Speed limit 25 miles per hour", urgency: .informative)
                        }
                    case "R3-4":
                        if scannedResults.signType != .noUTurn {
                            scannedResults.signType = .noUTurn
                            scannedResults.severity = .informative
                            speechController.speak(text: "No U-Turn ahead", urgency: .informative)
                        }
                    case "R6-1":
                        if scannedResults.signType != .oneWay {
                            scannedResults.signType = .oneWay
                            scannedResults.severity = .informative
                            speechController.speak(text: "One Way road", urgency: .informative)
                        }
                    case "W3-3":
                        if scannedResults.signType != .trafficLightAhead {
                            scannedResults.signType = .trafficLightAhead
                            scannedResults.severity = .informative
                            speechController.speak(text: "Traffic light ahead", urgency: .informative)
                        }
                    case "W3-1":
                        if scannedResults.signType != .stopSignAhead {
                            scannedResults.signType = .stopSignAhead
                            scannedResults.severity = .informative
                            speechController.speak(text: "Stop sign ahead", urgency: .informative)
                        }
                    default:
                        print(topLabelObservation.identifier)
                    }
                }
                resultTime = Date.now
            }
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let faceAnchor = anchor as? ARFaceAnchor else { return }
                let faceTransform = faceAnchor.transform
                let pitch = asin(-faceTransform.columns.2.y)  // Tilt down/up (x-axis rotation)
                let yaw = atan2(faceTransform.columns.0.y, faceTransform.columns.1.y)  // Turn left/right (y-axis rotation)
                let left = faceAnchor.blendShapes[.eyeBlinkLeft]
                let right = faceAnchor.blendShapes[.eyeBlinkRight]
                
                if timer == nil {
                    if ((left?.doubleValue ?? 0.0 >= 0.8) || (right?.doubleValue ?? 0.0 >= 0.8)) {
                        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {timer in
                            self.scannedResults.signType = .distracted
                            self.speechController.speak(text: "Please be sure to keep your attention on the road", urgency: .hazard)
                        })
                        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
                    }
                    // Check if the user looks down
                    if pitch > 0.5 {  // Threshold for looking down
                        // Action when the user looks down
                        self.scannedResults.signType = .distracted
                        self.speechController.speak(text: "Please be sure to keep your attention on the road", urgency: .hazard)
                    }
                    
                    // Check if the user turns head to the left or right
                    if yaw > 0.5 {  // Threshold for looking to the right
                        // Action when the user looks to the right
                        self.scannedResults.signType = .distracted
                        self.speechController.speak(text: "Please be sure to keep your attention on the road", urgency: .hazard)
                    } else if yaw < -0.5 {  // Threshold for looking to the left
                        // Action when the user looks to the left
                        self.scannedResults.signType = .distracted
                        self.speechController.speak(text: "Please be sure to keep your attention on the road", urgency: .hazard)
                    }
                } else if (timer != nil) && (left?.doubleValue ?? 1.0 <= 0.8) && (right?.doubleValue ?? 1.0 <= 0.8) {
                    timer?.invalidate()
                    timer = nil
                }
                // Head orientation detection
                
            }
        }
        
    }
}

class ScanResults: ObservableObject, Equatable {
    static func == (lhs: ScanResults, rhs: ScanResults) -> Bool {
        lhs.signType == rhs.signType
    }
    
    @Published var signType: SignType
    @Published var severity: SignSeverity
    
    init(signType: SignType) {
        self.signType = signType
        self.severity = .warning
    }
}

enum SignSeverity {
    case informative
    case warning
    case critical
}

enum SignType: String {
    case pedestrianCrossing = "Pedestrian Crossing"
    case stopSign = "Stop Sign"
    case doNotEnter = "Do Not Enter"
    case yield = "Yield"
    case spdlmt40 = "Speed Limit 40"
    case spdlmt30 = "Speed Limit 30"
    case spdlmt35 = "Speed Limit 35"
    case speedLimit25 = "Speed Limit 25"
    case noUTurn = "No U-Turn"
    case oneWay = "One Way"
    case trafficLightAhead = "Traffic light ahead"
    case stopSignAhead = "Stop sign ahead"
    case distracted = "Pay Attention!"
    case empty
}

enum SignClass {
    case warning
}

class ScannedResults: ObservableObject, Equatable {
    static func == (lhs: ScannedResults, rhs: ScannedResults) -> Bool {
        return lhs.currentSign == rhs.currentSign
    }
    
    @Published var currentSign: SignType?
    @Published var signName: String?
    @Published var signGlass : SignClass?
}
