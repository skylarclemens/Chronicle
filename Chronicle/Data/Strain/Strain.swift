//
//  Strain.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import Foundation
import SwiftData

@Model public class Strain {
    public var name: String
    public var type: StrainType
    public var subtype: StrainSubType?
    public var createdAt: Date
    public var desc: String
    
    init(name: String, type: StrainType, createdAt: Date = Date(), desc: String = "") {
        self.name = name
        self.type = type
        self.createdAt = createdAt
        self.desc = desc
    }
}
