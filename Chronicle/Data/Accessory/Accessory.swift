//
//  Accessory.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import Foundation
import SwiftData

@Model
public class Accessory {
    public var id: UUID
    public var name: String
    public var createdAt: Date
    public var type: AccessoryType
    public var purchase: Purchase?
    public var brand: String?
    public var lastCleanedDate: Date?
    public var favorite: Bool
    @Attribute(.externalStorage) public var imagesData: [Data]?
    
    @Relationship public var sessions: [Session]
    
    init(id: UUID = UUID(),
         name: String = "",
         createdAt: Date = Date(),
         type: AccessoryType = .other,
         purchase: Purchase? = nil,
         brand: String? = nil,
         lastCleanedDate: Date? = nil,
         favorite: Bool = false,
         imagesData: [Data]? = nil,
         sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.type = type
        self.purchase = purchase
        self.brand = brand
        self.lastCleanedDate = lastCleanedDate
        self.favorite = favorite
        self.imagesData = imagesData
        self.sessions = sessions
    }
    
    public enum AccessoryType: String, Codable, CaseIterable, Identifiable {
        case bong, pipe, vaporizer, dabRig, grinder, rollingTray, papers, other
        
        public func symbol() -> String {
            switch self {
            case .bong:
                "flask"
            case .pipe:
                "thermometer.low"
            case .vaporizer:
                "smoke"
            case .dabRig:
                "flame"
            case .grinder:
                "hockey.puck"
            case .rollingTray:
                "tray"
            case .papers:
                "scroll"
            case .other:
                "wrench.and.screwdriver"
            }
        }
        
        public func label() -> String {
            switch self {
            case .bong:
                "bong"
            case .pipe:
                "pipe"
            case .vaporizer:
                "vaporizer"
            case .dabRig:
                "dab rig"
            case .grinder:
                "grinder"
            case .rollingTray:
                "rolling tray"
            case .papers:
                "papers"
            case .other:
                "other"
            }
        }
        
        public func sectionLabel() -> String {
            switch self {
            case .bong:
                "Bongs"
            case .pipe:
                "Pipes"
            case .vaporizer:
                "Vaporizers"
            case .dabRig:
                "Dab Rigs"
            case .grinder:
                "Grinders"
            case .rollingTray:
                "Rolling Trays"
            case .papers:
                "papers"
            case .other:
                "other"
            }
        }
        
        public var id: String { return self.rawValue }
    }
    
    static func predicate(
        filter: InventoryFilter = .all,
        searchText: String
    ) -> Predicate<Accessory> {
        if filter == .favorites {
            return #Predicate<Accessory> { accessory in
                (searchText.isEmpty || accessory.name.localizedStandardContains(searchText))
                &&
                accessory.favorite
            }
        }
        return #Predicate<Accessory> { accessory in
            searchText.isEmpty || accessory.name.localizedStandardContains(searchText)
        }
    }
}
