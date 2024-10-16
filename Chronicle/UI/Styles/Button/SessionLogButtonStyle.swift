//
//  SessionLogButtonStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import Foundation
import SwiftUI

struct SessionLogButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    var color: Color?
    var gradient: LinearGradient?
    
    var setColor: Color? {
        if let color,
           #available(iOS 18.0, *) {
            return color.opacity(0.75).mix(with: .primary, by: 0.25)
        }
        return color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(getPadding())
            .font(getFont())
            .background {
                if let gradient {
                    if controlSize == .small {
                        Capsule().fill(gradient.opacity(0.25))
                    } else {
                        RoundedRectangle(cornerRadius: 12).fill(gradient.opacity(0.25))
                    }
                } else if let color {
                    if controlSize == .small {
                        Capsule().fill(color.opacity(0.25))
                    } else {
                        RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.25))
                    }
                }
            }
            .overlay {
                if let gradient {
                    if controlSize == .small {
                        Capsule().strokeBorder(gradient.opacity(0.75))
                    } else {
                        RoundedRectangle(cornerRadius: 12).strokeBorder(gradient.opacity(0.75))
                    }
                } else if let setColor {
                    if controlSize == .small {
                        Capsule().strokeBorder(setColor.opacity(0.75))
                    } else {
                        RoundedRectangle(cornerRadius: 12).strokeBorder(setColor.opacity(0.75))
                    }
                }
            }
    }
    
    func getPadding() -> EdgeInsets {
        let unit: CGFloat = 4
        switch controlSize {
        case .mini:
            return EdgeInsets(top: unit / 2, leading: unit, bottom: unit / 2, trailing: unit)
        case .small:
            return EdgeInsets(top: unit, leading: unit * 2, bottom: unit, trailing: unit * 2)
        case .regular:
            return EdgeInsets(top: unit * 2, leading: unit * 2, bottom: unit * 2, trailing: unit * 2)
        case .large:
            return EdgeInsets(top: unit * 3, leading: unit * 3, bottom: unit * 3, trailing: unit * 3)
        case .extraLarge:
            return EdgeInsets(top: unit * 4, leading: unit * 4, bottom: unit * 4, trailing: unit * 4)
        @unknown default:
            fatalError()
        }
    }
    
    func getFont() -> Font {
        switch controlSize {
        case .mini:
            return .caption2
        case .small:
            return .footnote
        case .regular:
            return .body
        case .large:
            return .headline.weight(.regular)
        case .extraLarge:
            return .title3
        @unknown default:
            fatalError()
        }
    }
}

extension ButtonStyle where Self == SessionLogButtonStyle {
    static func sessionLog(color: Color? = nil, gradient: LinearGradient? = nil) -> Self {
        SessionLogButtonStyle(color: color, gradient: gradient)
    }
    
    static var mood: SessionLogButtonStyle {
        SessionLogButtonStyle(gradient: LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing))
    }
}
