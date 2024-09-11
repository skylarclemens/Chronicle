//
//  MoodSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/6/24.
//

import SwiftUI

struct MoodSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: SessionEditorViewModel
    @State private var selectedMoodIndex: Double = 2
    
    @State private var gradientColors: [Color] = [.white.opacity(0.2), .black.opacity(0)]
    
    var moodColors: [Color] {
        Trait.predefinedMoods.map { $0.color.color }
    }
    var currentMood: Trait? {
        Trait.predefinedMoods[Int(round(selectedMoodIndex))]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 15 / 255, green: 7 / 255, blue: 19 / 255))
                .ignoresSafeArea()
            EllipticalGradient(colors: gradientColors, center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5)
                .rotationEffect(.degrees(90))
                .animation(.easeInOut(duration: 0.5), value: gradientColors)
            
            VStack(spacing: 68) {
                Text("How do you feel?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                Text(currentMood?.name ?? "")
                    .font(.system(size: 38, weight: .medium, design: .rounded))
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.1),
                                in: RoundedRectangle(cornerRadius: 10))
                CustomSliderView(value: $selectedMoodIndex, range: 0...CGFloat((Trait.predefinedMoods.count - 1)))
                    .frame(height: 42)
                    .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            NavigationLink {
                MoodDescriptorSelectView(viewModel: $viewModel, parentDismiss: dismiss, currentMood: currentMood)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .contentShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .padding()
            .background(.regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.ultraThinMaterial)
            )
            .padding()
        }
        .onAppear {
            if let sessionMood = viewModel.moodTrait,
               let moodIndex = Trait.predefinedMoods.firstIndex(where: { $0.id == sessionMood.trait.id }) {
                selectedMoodIndex = Double(moodIndex)
            }
        }
        .onChange(of: selectedMoodIndex) { oldValue, newValue in
            updateGradientColors(for: newValue)
        }
        .tint(.primary)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func updateGradientColors(for value: Double) {
        let lowerIndex = Int(floor(value))
        let upperIndex = Int(ceil(value))
        let interpolation = value - Double(lowerIndex)
        
        let lowerColor = moodColors[lowerIndex]
        let upperColor = moodColors[upperIndex]
        
        let interpolatedColor = interpolateColor(from: lowerColor, to: upperColor, with: interpolation)
        
        gradientColors = [interpolatedColor.opacity(0.3), .black.opacity(0)]
    }
    
    private func interpolateColor(from: Color, to: Color, with fraction: Double) -> Color {
        guard let fromComponents = UIColor(from).cgColor.components,
              let toComponents = UIColor(to).cgColor.components else {
            return from
        }
        
        let r = fromComponents[0] + (toComponents[0] - fromComponents[0]) * fraction
        let g = fromComponents[1] + (toComponents[1] - fromComponents[1]) * fraction
        let b = fromComponents[2] + (toComponents[2] - fromComponents[2]) * fraction
        
        return Color(red: r, green: g, blue: b)
    }
}

#Preview {
    @State var viewModel = SessionEditorViewModel()
    
    return NavigationStack {
        MoodSelectorView(viewModel: $viewModel)
            .modelContainer(SampleData.shared.container)
    }
}
