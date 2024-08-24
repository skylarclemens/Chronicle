//
//  ColorData.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import Foundation
import SwiftUI

public struct ColorData: Codable {
    var red: Float = 1
    var green: Float = 1
    var blue: Float = 1
    var opacity: Float = 1
    
    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }
    
    init(red: Float, green: Float, blue: Float, opacity: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    
    init(color: Color) {
        let resolved = color.resolve(in: EnvironmentValues())
        self.red = resolved.red
        self.green = resolved.green
        self.blue = resolved.blue
        self.opacity = resolved.opacity
    }
}
