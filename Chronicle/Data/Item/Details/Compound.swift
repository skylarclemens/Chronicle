//
//  Compound.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation

public struct Compound: Codable, Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var value: Double
    public var unit: CannabinoidMeasurement?
    public var type: CompoundType
    public var color: ColorData
    
    init(id: UUID = UUID(), name: String, value: Double = 0, unit: CannabinoidMeasurement? = nil, type: CompoundType, color: ColorData = ColorData(color: .accent)) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.type = type
        self.color = color
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Compound, rhs: Compound) -> Bool {
        lhs.id == rhs.id
    }
    
    public static let predefinedTerpenes: [Compound] = [
        Compound(name: "Myrcene", type: .terpene, color: ColorData(color: .brown)),
        Compound(name: "Limonene", type: .terpene, color: ColorData(color: .yellow)),
        Compound(name: "Pinene", type: .terpene, color: ColorData(color: .green)),
        Compound(name: "Linalool", type: .terpene, color: ColorData(color: .purple)),
        Compound(name: "Caryophyllene", type: .terpene, color: ColorData(color: .red)),
        Compound(name: "Humulene", type: .terpene, color: ColorData(color: .brown)),
        Compound(name: "Terpinolene", type: .terpene, color: ColorData(color: .green)),
        Compound(name: "Ocimene", type: .terpene, color: ColorData(color: .orange)),
        Compound(name: "Bisabolol", type: .terpene, color: ColorData(color: .pink)),
        Compound(name: "Camphene", type: .terpene, color: ColorData(color: .green)),
        Compound(name: "Geraniol", type: .terpene, color: ColorData(color: .red)),
        Compound(name: "Eucalyptol (Cineole)", type: .terpene, color: ColorData(color: .blue)),
        Compound(name: "Nerolidol", type: .terpene, color: ColorData(color: .orange)),
        Compound(name: "Valencene", type: .terpene, color: ColorData(color: .orange)),
        Compound(name: "Terpineol", type: .terpene, color: ColorData(color: .purple))
    ]
}

public enum CompoundType: String, Codable {
    case cannabinoid, terpene
}

public enum CannabinoidMeasurement: String, Codable, CaseIterable, Identifiable {
    case percentage = "%"
    case milligrams = "mg"
    case milligramsPerMl = "mg/mL"
    
    public var id: String { return self.rawValue }
    
    static func defaultFor(itemType: ItemType) -> CannabinoidMeasurement {
        switch itemType {
        case .edible, .pill, .topical:
            .milligrams
        case .flower, .preroll, .concentrate:
            .percentage
        case .tincture:
            .milligramsPerMl
        case .other:
            .milligrams
        }
    }
}
