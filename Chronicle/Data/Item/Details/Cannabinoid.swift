//
//  Cannabinoid.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import Foundation
import SwiftData

@Model
public class Cannabinoid {
    public var name: String
    public var value: Double
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
