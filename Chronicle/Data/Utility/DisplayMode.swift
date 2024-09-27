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
    
    func displayOverride() {
        var uiStyle: UIUserInterfaceStyle
        
        switch self {
        case .system: uiStyle = .unspecified
        case .light: uiStyle = .light
        case .dark: uiStyle = .dark
        }
        
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.keyWindow?.overrideUserInterfaceStyle = uiStyle
    }
}
