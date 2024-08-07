//
//  Strain.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import Foundation
import SwiftData

@Model public class Strain {
    @Attribute(.unique) public var name: String
    public var createdAt: Date
    public var desc: String
    
    init(name: String, createdAt: Date = Date(), desc: String) {
        self.name = name
        self.createdAt = createdAt
        self.desc = desc
    }
}
