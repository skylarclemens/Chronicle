//
//  Format.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import Foundation

func formatTime(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}
