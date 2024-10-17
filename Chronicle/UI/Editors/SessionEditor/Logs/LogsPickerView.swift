//
//  LogsPickerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/16/24.
//

import SwiftUI
import SwiftData

struct LogsPickerView: View {
    @Binding var viewModel: SessionEditorViewModel
    
    @State private var openMood: Bool = false
    @State private var openWellness: Bool = false
    
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
                    .controlSize(.extraLarge)
                }
                if viewModel.wellnessEntries.isEmpty {
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
                        .controlSize(.extraLarge)
                    }
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
                            Menu {
                                Button("Edit", systemImage: "pencil") {
                                    openMood = true
                                }
                                Button("Remove", systemImage: "trash", role: .destructive) {
                                    withAnimation {
                                        viewModel.mood = nil
                                    }
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .imageScale(.large)
                                    .padding(8)
                                    .contentShape(Circle())
                            }
                            .buttonStyle(.plain)
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
                                                .font(.caption)
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
            if !viewModel.wellnessEntries.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Wellness")
                            .font(.title3.weight(.medium))
                        Spacer()
                        Menu {
                            Button("Edit", systemImage: "pencil") {
                                openWellness = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .padding(8)
                                .contentShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    DetailSection(isScrollView: true) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.wellnessEntries) { entry in
                                    HStack {
                                        Text(entry.wellness?.name ?? "")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        if let intensity = entry.intensity {
                                            Text(intensity, format: .number)
                                                .font(.footnote)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(.secondarySystemFill),
                                                            in: RoundedRectangle(cornerRadius: 6))
                                        }
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
                .id("WellnessSelectorView")
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
        viewModel.wellnessEntries = [SampleData.shared.wellnessEntry]
    }
}
