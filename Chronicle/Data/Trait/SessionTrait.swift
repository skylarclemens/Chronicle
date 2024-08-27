//
//  SessionTrait.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation
import SwiftData

@Model
public class SessionTrait {
    @Attribute(.unique) public var id: UUID
    public var itemTrait: ItemTrait?
    public var session: Session?
    public var intensity: Int?
    
    init(id: UUID = UUID(), itemTrait: ItemTrait? = nil, session: Session? = nil, intensity: Int? = nil) {
        self.id = id
        self.itemTrait = itemTrait
        self.session = session
        self.intensity = intensity
    }
}
