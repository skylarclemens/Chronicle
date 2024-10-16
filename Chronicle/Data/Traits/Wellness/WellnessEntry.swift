//
//  WellnessEntry.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/16/24.
//

import Foundation
import SwiftData

@Model
public class WellnessEntry {
    public var id: UUID?
    public var wellness: Wellness?
    public var intensity: Int?
    public var session: Session?
    
    init(id: UUID = UUID(), wellness: Wellness? = nil, intensity: Int? = nil, session: Session? = nil) {
        self.id = id
        self.wellness = wellness
        self.intensity = intensity
        self.session = session
    }
}
