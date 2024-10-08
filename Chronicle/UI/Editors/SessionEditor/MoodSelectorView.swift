//
//  MoodSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/6/24.
//

import SwiftUI
import SwiftData

struct MoodSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    @State private var viewModel = MoodSelectorViewModel()
    @State private var selectedMoodIndex: Double = 0.0
    
    @State private var gradientColors: [Color] = [.primary.opacity(0.2), Color(.systemBackground).opacity(0)]
    
    
    var moodColors: [Color] {
        MoodType.allCases.map { $0.color }
    }
    
    var selectedMood: MoodType {
        let moodValence = selectedMoodIndex.round(toNearest: 0.5)
        return MoodType(rawValue: moodValence) ?? .neutral
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(.systemGroupedBackground))
                .ignoresSafeArea()
            Rectangle()
                .fill(.purple.opacity(0.125))
                .ignoresSafeArea()
            EllipticalGradient(colors: gradientColors, center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5)
                .rotationEffect(.degrees(90))
                .animation(.easeInOut(duration: 0.5), value: gradientColors)
            
            VStack(spacing: 68) {
                Text("How do you feel?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                Text(selectedMood.label)
                    .font(.system(size: 38, weight: .medium, design: .rounded))
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.regularMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)
                    .animation(.default, value: selectedMood.label)
                CustomSliderView(value: $selectedMoodIndex, range: -1...1)
                    .frame(height: 42)
                    .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            NavigationLink {
                MoodDescriptorSelectView(sessionViewModel: $sessionViewModel, viewModel: $viewModel, parentDismiss: dismiss)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .contentShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .padding()
            .background(.regularMaterial,
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.primary.opacity(0.1))
            )
            .padding()
        }
        .onAppear {
            if let mood = sessionViewModel.mood {
                viewModel.mood = mood
                viewModel.emotions = mood.emotions ?? []
                selectedMoodIndex = mood.type?.rawValue ?? 0.0
            } else {
                viewModel.mood = Mood(type: .neutral)
            }
        }
        .onChange(of: selectedMoodIndex) { oldValue, newValue in
            updateGradientColors(for: newValue)
            viewModel.mood?.type = selectedMood
            viewModel.mood?.valence = selectedMoodIndex
        }
        .tint(.primary)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.close)
            }
        }
    }
    
    private func updateGradientColors(for value: Double) {
        let colorsCount = moodColors.count
        let normalizedValue = (value + 1) / 2
        let index = normalizedValue * Double(colorsCount - 1)
        let lowerIndex = Int(floor(index))
        let upperIndex = Int(ceil(index))
        let interpolation = index - Double(lowerIndex)
        
        let lowerColor = moodColors[lowerIndex]
        let upperColor = moodColors[upperIndex]
        
        let interpolatedColor = interpolateColor(from: lowerColor, to: upperColor, with: interpolation)
        
        gradientColors = [interpolatedColor.opacity(0.5), .black.opacity(0)]
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

@Observable
class MoodSelectorViewModel {
    var mood: Mood?
    var emotions: [Emotion] = []
}

#Preview {
    @State var viewModel = SessionEditorViewModel()
    
    return NavigationStack {
        MoodSelectorView(sessionViewModel: $viewModel)
            .modelContainer(SampleData.shared.container)
    }
}
