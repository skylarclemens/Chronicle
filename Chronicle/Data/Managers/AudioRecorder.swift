//
//  AudioRecorder.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import Foundation
import AVFoundation

@Observable
class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    var isRecording = false
    var currentTime: TimeInterval = 0
    
    private var timer: Timer?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Cannot set up recording: \(error)")
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = documentsPath.appendingPathComponent("\(dateFormatter.string(from: date)).mp4", conformingTo: .audio)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            setTimer()
            isRecording = true
        } catch {
            print("Failed to set up and start recording: \(error)")
        }
    }
    
    func stopRecording() -> Data? {
        audioRecorder?.stop()
        isRecording = false
        
        timer?.invalidate()
        timer = nil
        currentTime = 0
        
        if let audioFileName = audioRecorder?.url {
            return try? Data(contentsOf: audioFileName)
        }
        return nil
    }
    
    private func setTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                if let self {
                    self.currentTime = self.currentTime + 1
                }
            }
        }
    }
}
