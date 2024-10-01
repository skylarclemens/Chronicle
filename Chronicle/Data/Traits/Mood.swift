//
//  Mood.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
public class Mood {
    var type: MoodType
    var valence: Double
    /// Associated emotions with current mood
    var emotions: [Emotion]
    var session: Session?
    
    init(
        type: MoodType,
        valence: Double = 0.0,
        emotions: [Emotion] = [],
        session: Session? = nil
    ) {
        self.type = type
        self.valence = valence
        self.emotions = emotions
        self.session = session
    }
}

public enum MoodType: Double, Codable, CaseIterable {
    case veryNegative = -1.0
    case negative = -0.5
    case neutral = 0.0
    case positive = 0.5
    case veryPositive = 1.0
    
    var label: String {
        switch self {
        case .veryNegative:
            "Very Negative"
        case .negative:
            "Negative"
        case .neutral:
            "Neutral"
        case .positive:
            "Positive"
        case .veryPositive:
            "Very Positive"
        }
    }
    
    var color: Color {
        switch self {
        case .veryNegative:
                .red
        case .negative:
                .yellow
        case .neutral:
                .white
        case .positive:
                .blue
        case .veryPositive:
                .green
        }
    }
    
    var emoji: String {
        switch self {
        case .veryNegative:
            "😢"
        case .negative:
            "😟"
        case .neutral:
            "😐"
        case .positive:
            "🙂"
        case .veryPositive:
            "😄"
        }
    }
}

