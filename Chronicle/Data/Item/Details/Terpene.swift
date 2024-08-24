//
//  Terpene.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import Foundation
import SwiftData

@Model
public class Terpene {
    public var name: String
    public var color: ColorData
    
    init(name: String, color: ColorData = ColorData(color: .green)) {
        self.name = name
        self.color = color
    }
    
    public static let predefinedTerpenes: [Terpene] = [
        Terpene(name: "Myrcene", color: ColorData(color: .brown)),
        Terpene(name: "Limonene", color: ColorData(color: .yellow)),
        Terpene(name: "Pinene", color: ColorData(color: .green)),
        Terpene(name: "Linalool", color: ColorData(color: .purple)),
        Terpene(name: "Caryophyllene", color: ColorData(color: .red)),
        Terpene(name: "Humulene", color: ColorData(color: .brown)),
        Terpene(name: "Terpinolene", color: ColorData(color: .green)),
        Terpene(name: "Ocimene", color: ColorData(color: .orange)),
        Terpene(name: "Bisabolol", color: ColorData(color: .pink)),
        Terpene(name: "Camphene", color: ColorData(color: .green)),
        Terpene(name: "Geraniol", color: ColorData(color: .red)),
        Terpene(name: "Eucalyptol (Cineole)", color: ColorData(color: .blue)),
        Terpene(name: "Nerolidol", color: ColorData(color: .orange)),
        Terpene(name: "Valencene", color: ColorData(color: .orange)),
        Terpene(name: "Terpineol", color: ColorData(color: .purple))
    ]
}
