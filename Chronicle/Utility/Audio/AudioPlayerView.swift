//
//  AudioPlayerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct AudioPlayerView: View {
    @State private var audioPlayer = AudioPlayer()
    var audioData: Data?
    
    var body: some View {
        if let recording = audioData {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                audioPlayer.loadAudio(data: recording)
            }
            .onDisappear {
                audioPlayer.stopAudio()
            }
        }
    }
}

#Preview {
    AudioPlayerView()
}
