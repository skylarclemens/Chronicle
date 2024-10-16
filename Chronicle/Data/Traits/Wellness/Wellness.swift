//
//  Wellness.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/16/24.
//

import Foundation
import SwiftData

@Model
public class Wellness {
    public var id: UUID?
    public var name: String?
    public var type: WellnessType?
    
    init(id: UUID = UUID(), name: String? = nil, type: WellnessType? = nil) {
        self.id = id
        self.name = name
        self.type = type
    }
}

public enum WellnessType: String, Codable, CaseIterable {
    case symptom
    case condition
}
