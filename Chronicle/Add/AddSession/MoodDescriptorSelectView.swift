//
//  MoodDescriptorSelectView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/7/24.
//

import SwiftUI
import SwiftData

struct MoodDescriptorSelectView: View {
    @Binding var sessionViewModel: SessionEditorViewModel
    @Binding var viewModel: MoodSelectorViewModel
    let parentDismiss: DismissAction
    
    @State var selectedEmotions: [Emotion] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 15 / 255, green: 7 / 255, blue: 19 / 255))
                .ignoresSafeArea()
            VStack {
                Text("What best describes how you’re feeling?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding()
                EmotionsSelectView(selectedEmotions: $selectedEmotions)
            }
            .frame(maxHeight: .infinity)
            VStack {
                Button {
                    if let mood = viewModel.mood {
                        mood.emotions = selectedEmotions
                        sessionViewModel.mood = mood
                    }
                    parentDismiss()
                } label: {
                    Text("Done")
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
            .frame(height: 150)
            .background(
                Color(UIColor.systemBackground).mask(
                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                )
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if let mood = viewModel.mood {
                print(mood.type.label)
            }
            if !viewModel.emotions.isEmpty {
                selectedEmotions = viewModel.emotions
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct EmotionsSelectView: View {
    @Binding var selectedEmotions: [Emotion]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 30)), GridItem(.flexible(minimum: 30)), GridItem(.flexible(minimum: 30))]) {
                ForEach(Emotion.initialEmotions, id: \.self) { emotion in
                    let emotionSelected = selectedEmotions.contains { $0.name == emotion.name }
                    Button {
                        if emotionSelected {
                            selectedEmotions.removeAll { $0.name == emotion.name }
                        } else {
                            selectedEmotions.append(emotion)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(emotion.emoji ?? "")
                                .font(.footnote)
                            Text(emotion.name)
                                .font(.footnote)
                            if emotionSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.footnote)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .tag(emotion as Emotion?)
                    .padding(8)
                    .background(.regularMaterial,
                                in: RoundedRectangle(cornerRadius: 12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.ultraThinMaterial)
                    )
                }
            }
            .padding(.bottom, 150)
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var sessionViewModel = SessionEditorViewModel()
    @State var viewModel = MoodSelectorViewModel()
    
    return NavigationStack {
        MoodDescriptorSelectView(sessionViewModel: $sessionViewModel, viewModel: $viewModel, parentDismiss: dismiss)
    }
    .modelContainer(SampleData.shared.container)
}
