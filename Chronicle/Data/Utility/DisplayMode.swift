//
//  DisplayMode.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import Foundation
import SwiftUI

enum DisplayMode: Int {
    case system, light, dark
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            .none
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
