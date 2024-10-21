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
    @Relationship(inverse: \Effect.relatedWellness)
    public var relatedEffect: Effect?
    
    init(id: UUID = UUID(), createdAt: Date = Date(), name: String = "", type: WellnessType? = nil, isCustom: Bool = false, entries: [WellnessEntry]? = [], relatedEffect: Effect? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.type = type
        self.isCustom = isCustom
        self.entries = entries
        self.relatedEffect = relatedEffect
    }
}

public enum WellnessType: String, Codable, CaseIterable {
    case symptom
    case condition
}

extension Wellness {
    static let predefinedData: [Wellness] = [
        // Symptoms
        Wellness(name: "Anxiety", type: .symptom),
        Wellness(name: "Pain", type: .symptom),
        Wellness(name: "Inflammation", type: .symptom),
        Wellness(name: "Nausea", type: .symptom),
        Wellness(name: "Insomnia", type: .symptom),
        Wellness(name: "Fatigue", type: .symptom),
        Wellness(name: "Appetite", type: .symptom),
        Wellness(name: "Stress", type: .symptom),
        Wellness(name: "Headaches", type: .symptom),
        
        // Conditions
        Wellness(name: "Chronic Pain", type: .condition),
        Wellness(name: "Chronic Insomnia", type: .condition),
        Wellness(name: "PTSD", type: .condition),
        Wellness(name: "Depression", type: .condition),
        Wellness(name: "ADHD", type: .condition)
    ]
}
