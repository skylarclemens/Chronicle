//
//  AudioPlayer.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import Foundation
import AVFoundation

@Observable
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    
    var startedPlaying = false
    var isPaused = false
    
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    
    private var timer: Timer?
    
    func loadAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            
            duration = audioPlayer?.duration ?? 0
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        startedPlaying = false
        isPaused = false
        
        timer?.invalidate()
        timer = nil
    }
    
    func togglePlayPause() {
        if isPaused {
            audioPlayer?.pause()
            
            timer?.invalidate()
            timer = nil
        } else {
            audioPlayer?.play()
            startedPlaying = true
            
            setTimer()
        }
        isPaused.toggle()
    }
    
    private func setTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                if let self {
                    self.currentTime = self.audioPlayer?.currentTime ?? 0
                }
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
        self.currentTime = self.duration
    }
}
