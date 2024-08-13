//
//  ExperienceFlavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class SessionFlavor {
    public var flavor: Flavor
    public var session: Session?
    public var intensity: Int?
    
    init(flavor: Flavor, session: Session? = nil) {
        self.flavor = flavor
        self.session = session
    }
}
