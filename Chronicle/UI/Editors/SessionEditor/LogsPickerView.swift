//
//  LogsPickerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/16/24.
//

import SwiftUI

struct LogsPickerView: View {
    @Binding var viewModel: SessionEditorViewModel
    
    @State private var openMood: Bool = false
    @State private var openWellness: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                if viewModel.mood == nil {
                    Button {
                        openMood = true
                    } label: {
                        HStack {
                            Image(systemName: "face.smiling")
                            Text("Mood and Emotions")
                            Spacer()
                            Image(systemName: "plus")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.mood)
                    .controlSize(.large)
                }
                HStack {
                    Button {
                        openWellness = true
                    } label: {
                        HStack {
                            Image(systemName: "heart")
                            Text("Wellness")
                            Spacer()
                            Image(systemName: "plus")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.sessionLog(color: .pink))
                    .controlSize(.large)
                }
            }
            
            /// Mood
            if let currentMood = viewModel.mood {
                VStack(alignment: .leading) {
                    if let moodType = currentMood.type {
                        HStack(alignment: .bottom) {
                            Text("Mood")
                                .font(.title3.weight(.medium))
                            Text(moodType.label)
                                .font(.subheadline)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(moodType.color.opacity(0.33))
                                )
                            Spacer()
                            Button {
                                openMood = true
                            } label: {
                                Text("Edit")
                            }
                            .buttonStyle(.mood)
                            .controlSize(.small)
                        }
                    }
                    if let moodEmotions = currentMood.emotions,
                       !moodEmotions.isEmpty {
                        DetailSection(header: "Feelings", isScrollView: true) {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(moodEmotions, id: \.self) { emotion in
                                        HStack {
                                            Text(emotion.emoji ?? "")
                                                .font(.system(size: 12))
                                            Text(emotion.name)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                        }
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.ultraThinMaterial)
                                        )
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 16)
                            .scrollIndicators(.hidden)
                        }
                    }
                }
            }
            
            /// Wellness
        }
        .sheet(isPresented: $openMood) {
            NavigationStack {
                MoodSelectorView(sessionViewModel: $viewModel)
            }
            .tint(.primary)
            .presentationDetents([.large])
            .presentationBackground(.thickMaterial)
        }
        .sheet(isPresented: $openWellness) {
            WellnessSelectorView(sessionViewModel: $viewModel)
        }
    }
}

struct WellnessSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        ScrollView {
            LogsPickerView(viewModel: $viewModel)
                .padding(.horizontal)
        }
    }
    .modelContainer(SampleData.shared.container)
    .onAppear {
        viewModel.mood = SampleData.shared.mood
    }
}
