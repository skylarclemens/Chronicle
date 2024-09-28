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
    public var type: AccessoryType?
    public var purchaseInfo: PurchaseInfo?
    public var lastCleanedDate: Date?
    public var favorite: Bool
    @Attribute(.externalStorage) public var imagesData: [Data]?
    
    @Relationship public var sessions: [Session]
    
    init(id: UUID = UUID(),
         name: String = "",
         type: AccessoryType? = nil,
         purchaseInfo: PurchaseInfo? = nil,
         lastCleanedDate: Date? = nil,
         favorite: Bool = false,
         imagesData: [Data]? = nil,
         sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.type = type
        self.purchaseInfo = purchaseInfo
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
        
        public var id: String { return self.rawValue }
    }
}
