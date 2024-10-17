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
    public var createdAt: Date = Date()
    public var name: String = ""
    public var type: WellnessType?
    public var isCustom: Bool = false
    public var entries: [WellnessEntry]?
    
    init(id: UUID = UUID(), createdAt: Date = Date(), name: String = "", type: WellnessType? = nil, isCustom: Bool = false, entries: [WellnessEntry]? = []) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.type = type
        self.isCustom = isCustom
        self.entries = entries
    }
}

public enum WellnessType: String, Codable, CaseIterable {
    case symptom
    case condition
}

extension Wellness {
    static let predefinedData: [Wellness] = [
        Wellness(name: "Anxiety", type: .symptom),
        Wellness(name: "Pain", type: .symptom),
        Wellness(name: "Nausea", type: .symptom),
        Wellness(name: "Insomnia", type: .symptom),
        Wellness(name: "Appetite Loss", type: .symptom),
        Wellness(name: "Appetite Gain", type: .symptom),
        Wellness(name: "PTSD", type: .condition),
        Wellness(name: "Depression", type: .condition)
    ]
}
