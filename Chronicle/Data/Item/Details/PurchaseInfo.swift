//
//  PurchaseInfo.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation

public struct PurchaseInfo: Codable {
    public var price: Double?
    public var date: Date
    public var location: String
    public var brand: String?
}
