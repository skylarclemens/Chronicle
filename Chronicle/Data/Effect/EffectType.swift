//
//  EffectType.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import Foundation

public enum EffectType: String, Identifiable, CaseIterable, Codable {
    case mood, wellness
    
    public var id: Self { return self }
}
