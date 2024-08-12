//
//  ItemType.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import Foundation

public enum ItemType: String, Identifiable, CaseIterable {
    case edible = "Edible"
    case flower = "Flower"
    case tincture = "Tincture"
    case concentrate = "Concentrate"
    case topical = "Topical"
    case pill = "Pill"
    case other = "Other"
    
    var id: String { self.rawValue }
}
