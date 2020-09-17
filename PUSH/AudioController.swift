//
//  AudioController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioType {
    case speak
    case sound
    case none
}

class AudioController {
    
    var audioPlayer = AVAudioPlayer()
    var audioType: AudioType = .sound
    
    init() {
        setupAudio()
        
        //Allows sound to play when ringer is off
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    // MARK: - Methods
    
    func playChosenAudio(pushups: Int?) {
        if audioType == .speak{
            speakCount(pushups: pushups ?? 0)
        } else if audioType == .sound {
            playPockAudio()
        }
    }
    
    func playPockAudio() {
        audioPlayer.play()
    }
    
    func speakCount(pushups: Int) {
        let utterance = AVSpeechUtterance(string: String(pushups))
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    // MARK: - Helper Methods
    
    private func setupAudio() {
        let sound = Bundle.main.path(forResource: "ClippedPock", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print("Error setting sound")
        }
    }
}

