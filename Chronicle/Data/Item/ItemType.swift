//
//  ItemType.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import Foundation

public enum ItemType: String, Identifiable, CaseIterable, Codable {
    case edible, flower, preroll, tincture, concentrate, topical, pill, other
    
    public var id: Self { return self }
    
    func symbol() -> String {
        switch (self) {
        case .edible:
            "birthday.cake"
        case .flower:
            "leaf"
        case .preroll:
            "smoke"
        case .tincture:
            "drop"
        case .concentrate:
            "flame"
        case .topical:
            "hands.and.sparkles.fill"
        case .pill:
            "pills.fill"
        case .other:
            "sparkles"
        }
    }
    
    func label() -> String {
        switch (self) {
        case .edible:
            "Edible"
        case .flower:
            "Flower"
        case .preroll:
            "Pre-roll"
        case .tincture:
            "Tincture"
        case .concentrate:
            "Concentrate"
        case .topical:
            "Topical"
        case .pill:
            "Pill"
        case .other:
            "Other"
        }
    }
}
