//
//  ExperienceFlavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class SessionFlavor {
    @Attribute(.unique) public var id: UUID
    public var flavor: Flavor
    public var session: Session?
    public var intensity: Int?
    
    init(id: UUID = UUID(), flavor: Flavor, session: Session? = nil) {
        self.id = id
        self.flavor = flavor
        self.session = session
    }
}
