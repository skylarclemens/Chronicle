//
//  MoodButton.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import Foundation
import SwiftUI

struct MoodButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    let gradient: LinearGradient = LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(getPadding())
            .font(getFont())
            .background(
                controlSize == .small ?
                    AnyView(Capsule().fill(gradient.opacity(0.25))) :
                    AnyView(RoundedRectangle(cornerRadius: 12).fill(gradient.opacity(0.25)))
            )
            .overlay(
                controlSize == .small ?
                AnyView(Capsule().strokeBorder(gradient.opacity(0.75))) :
                AnyView(RoundedRectangle(cornerRadius: 12).strokeBorder(gradient.opacity(0.75)))
            )
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

extension ButtonStyle where Self == MoodButtonStyle {
    static var mood: MoodButtonStyle {
        MoodButtonStyle()
    }
}