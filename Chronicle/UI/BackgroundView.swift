//
//  BackgroundView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI

struct BackgroundView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            if #available(iOS 18.0, *) {
                MeshGradient(width: 3, height: 3, points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(isAnimating ? 0.4 : 0.6,  isAnimating ? 0.4 : 0.6), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ], colors: [
                    .indigo, .purple, .purple,
                    .purple, Color(.systemBackground).opacity(isAnimating ? 0.5 : 1.0), .green,
                    .green, .green, .mint
                ],
                             smoothsColors: true,
                             colorSpace: .perceptual)
            } else {
                // Fallback on earlier versions
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
        }
        .blur(radius: 75)
        .overlay(
            Rectangle()
                .fill(Color(.systemGroupedBackground))
                .opacity(0.75)
        )
        .ignoresSafeArea()
        .onAppear {
            if #available(iOS 18.0, *) {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}

#Preview {
    BackgroundView()
}
