//
//  VoiceRecordingView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import SwiftUI
import AVFAudio

struct VoiceRecordingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    @Binding var openRecorder: Bool
    @State private var audioRecorder = AudioRecorder()
    @State private var audioPlayer = AudioPlayer()

    @State private var audioRecording: Data?
    
    @State private var openPermissionsAlert: Bool = false
    
    var body: some View {
        HStack {
            if audioRecording != nil {
                Button("Clear recording", systemImage: "xmark.circle.fill") {
                    withAnimation {
                        audioRecording = nil
                        openRecorder = false
                    }
                }
                .labelStyle(.iconOnly)
                .tint(.secondary)
                .font(.largeTitle)
                .padding(.trailing, 4)
            }
            VStack(alignment: .leading) {
                if !audioRecorder.isRecording {
                    if let recording = audioRecording {
                        HStack {
                            Button(audioPlayer.isPaused ? "Pause recording" : "Play recording", systemImage: audioPlayer.isPaused ? "pause.circle.fill" : "play.circle.fill") {
                                withAnimation {
                                    audioPlayer.togglePlayPause()
                                }
                            }
                            .labelStyle(.iconOnly)
                            .tint(.secondary)
                            .font(.largeTitle)
                            if audioPlayer.duration > 0 {
                                Text(audioPlayer.startedPlaying ? formatTime(audioPlayer.currentTime) : formatTime(audioPlayer.duration))
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: 45, alignment: .leading)
                                ProgressView(value: audioPlayer.currentTime, total: audioPlayer.duration)
                            }
                            Button("Save", systemImage: "checkmark.circle.fill") {
                                withAnimation {
                                    sessionViewModel.audioData = recording
                                    openRecorder = false
                                }
                            }
                            .labelStyle(.iconOnly)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                            .tint(.blue)
                            .padding(.leading, 8)
                        }
                        .onAppear {
                            audioPlayer.loadAudio(data: recording)
                        }
                        .onDisappear {
                            audioPlayer.stopAudio()
                        }
                    }
                } else {
                    HStack {
                        Button("Stop recording", systemImage: "stop.circle") {
                            withAnimation {
                                if let recordedAudio = audioRecorder.stopRecording() {
                                    audioRecording = recordedAudio
                                }
                            }
                        }
                        .labelStyle(.iconOnly)
                        .tint(.red)
                        .font(.largeTitle)
                        Text("Recording...")
                        Spacer()
                        Text(formatTime(audioRecorder.currentTime))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .frame(width: 45, alignment: .leading)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial,
                        in: Capsule())
            .background(audioRecorder.isRecording ? .red : .clear,
                        in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(.ultraThinMaterial)
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.25), radius: 10)
        }
        .padding(.horizontal, 8)
        .onAppear {
            Task {
                if await AVAudioApplication.requestRecordPermission() {
                    withAnimation {
                        audioRecorder.startRecording()
                    }
                } else {
                    openPermissionsAlert = true
                }
            }
        }
        .alert("Microphone Permission Denied", isPresented: $openPermissionsAlert) {
            Button("OK") {
                openRecorder = false
            }
        } message: {
            Text("Please allow Chronicle permission to use your microphone in Settings.")
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    @Previewable @State var sessionViewModel = SessionEditorViewModel()
    @Previewable @State var openRecorder = true
    VoiceRecordingView(sessionViewModel: $sessionViewModel, openRecorder: $openRecorder)
}
