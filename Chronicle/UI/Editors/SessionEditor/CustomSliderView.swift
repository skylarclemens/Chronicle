//
//  CustomSliderView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/6/24.
//

import SwiftUI

struct CustomSliderView: View {
    @Binding private var value: Double
    @State var thumbOffset: CGFloat
    @State var lastSliderPosition: CGFloat
    @State var viewWidth: CGFloat = 0
    
    var range: ClosedRange<CGFloat>
    var thumbSize: CGFloat
    var leadingOffset: CGFloat

    init(value: Binding<Double>, lastSliderPosition: CGFloat = 0.0, range: ClosedRange<CGFloat> = -1...1, thumbSize: CGFloat = 32, leadingOffset: CGFloat? = nil) {
        self._value = value
        self.lastSliderPosition = lastSliderPosition
        self.range = range
        self.thumbSize = thumbSize
        self.leadingOffset = leadingOffset ?? thumbSize / 8
        self.thumbOffset = self.leadingOffset
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height * 0.5)
                    .fill(.regularMaterial)
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: geometry.size.height * 0.5)
                            .strokeBorder(.ultraThinMaterial)
                    )
                Circle()
                    .fill(.white.opacity(0.9))
                    .frame(width: thumbSize)
                    .shadow(radius: 10)
                    .offset(x: thumbOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                if abs(gestureValue.translation.width) < 0.1 {
                                    lastSliderPosition = thumbOffset
                                }
                                
                                let nextSliderPosition = max(leadingOffset, min(lastSliderPosition + gestureValue.translation.width, geometry.size.width - leadingOffset - thumbSize))
                                thumbOffset = nextSliderPosition
                                updateValue(position: nextSliderPosition, width: geometry.size.width)
                            }
                    )
            }
            .onAppear {
                self.viewWidth = geometry.size.width
                updateThumbPosition()
            }
            .onChange(of: geometry.size.width) { oldWidth, newWidth in
                self.viewWidth = newWidth
                updateThumbPosition()
            }
        }
    }
    
    private func updateValue(position: CGFloat, width: CGFloat) {
        value = position.map(from: leadingOffset...(width - leadingOffset - thumbSize), to: range)
    }
    
    private func updateThumbPosition() {
        guard viewWidth > 0 else { return }
        let percentage = (CGFloat(value) - range.lowerBound) / (range.upperBound - range.lowerBound)
        let startingPosition = leadingOffset + percentage * (viewWidth - 2 * leadingOffset - thumbSize)
        thumbOffset = startingPosition
    }
}

#Preview {
    @State var value: Double = 0
    
    return CustomSliderView(value: $value)
        .frame(height: 42)
}
