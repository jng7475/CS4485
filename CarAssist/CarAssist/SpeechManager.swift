//
//  SpeechManager.swift
//  CarAssist
//
//  Created by Khang Nguyen on 3/28/24.
//

import Foundation
import AVFAudio

class SpeechManger {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, urgency: SpeechUrgency, language: String = "en-US") {
        var speakText = text
        
        var lang = "en-US"
        let langSetting = UserDefaults().string(forKey: "language")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
            
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
           
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: speakText)
            
            switch urgency {
            case .warning:
                utterance.rate = 0.54
            case .hazard:
                utterance.rate = 0.55
            default:
                break;
            }
            // utterance.rate = 0.57
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.2
            utterance.volume = 0.8
            
            // Retrieve the US English voice.
            let voice = AVSpeechSynthesisVoice(language: lang)
            
            // Assign the voice to the utterance.
            utterance.voice = voice
            
            // Tell the synthesizer to speak the utterance.
            synthesizer.speak(utterance)
        }
    }
    
    enum SpeechUrgency {
        case informative
        case warning
        case hazard
    }
}

