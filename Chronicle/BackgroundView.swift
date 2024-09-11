//
//  BackgroundView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .fill(.purple)
                        .position(x: 100, y: 100)
                    Circle()
                        .fill(.green)
                        .position(x: 300, y: 50)
                }
                .clipped()
                Spacer()
                ZStack {
                    Circle()
                        .fill(.purple)
                        .position(x: 400, y: 300)
                    Circle()
                        .fill(.green)
                        .position(x: 100, y: 350)
                }
            }
        }
        .blur(radius: 75)
        .overlay(
            Rectangle()
                .fill(.background)
                .opacity(0.75)
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
