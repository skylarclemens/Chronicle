//
//  StrainType.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import Foundation

public enum StrainType: String, Identifiable, CaseIterable, Codable {
    case sativa, indica, hybrid
    
    public var id: Self { return self }
}

public enum StrainSubType: String, Identifiable, CaseIterable, Codable {
    case balanced, sativa, indica
    
    public var id: Self { return self }
}
