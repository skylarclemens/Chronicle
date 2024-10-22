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
    @State private var openEffects: Bool = false
    @State private var openWellness: Bool = false
    @State private var openActivity: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                if viewModel.mood == nil || viewModel.effects.isEmpty {
                    HStack {
                        if viewModel.mood == nil {
                            Button {
                                openMood = true
                            } label: {
                                HStack {
                                    Image(systemName: "face.smiling")
                                    Text("Mood")
                                    Spacer()
                                    Image(systemName: "plus")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.mood)
                            .controlSize(.extraLarge)
                        }
                        if viewModel.effects.isEmpty {
                            Button {
                                openEffects = true
                            } label: {
                                HStack {
                                    Image(systemName: "theatermasks.fill")
                                    Text("Effects")
                                    Spacer()
                                    Image(systemName: "plus")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.sessionLog(color: .orange))
                            .controlSize(.extraLarge)
                        }
                    }
                }
                HStack {
                    if viewModel.wellnessEntries.isEmpty {
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
                    if viewModel.activities.isEmpty {
                        Button {
                            openActivity = true
                        } label: {
                            HStack {
                                Image(systemName: "figure.run")
                                Text("Activities")
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.sessionLog(color: .green))
                        .controlSize(.extraLarge)
                    }
                }
            }
            
            /// Mood
            if let currentMood = viewModel.mood,
                let moodType = currentMood.type {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text("Mood")
                            .font(.title3.weight(.medium))
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
                    DetailSection {
                        Text(moodType.label)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(moodType.color.opacity(0.33))
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            /// Effects
            if !viewModel.effects.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Effects")
                            .font(.title3.weight(.medium))
                        Spacer()
                        Menu {
                            Button("Edit", systemImage: "pencil") {
                                openEffects = true
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
                                ForEach(viewModel.effects) { effect in
                                    HStack {
                                        if let emoji = effect.emoji {
                                            Text(emoji)
                                        }
                                        Text(effect.name)
                                    }
                                    .font(.subheadline)
                                    .pillStyle()
                                }
                            }
                        }
                        .contentMargins(.horizontal, 16)
                        .scrollIndicators(.hidden)
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
                                    if let wellness = entry.wellness {
                                        HStack {
                                            Text(wellness.name)
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
                        }
                        .contentMargins(.horizontal, 16)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            
            /// Activities
            if !viewModel.activities.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Activities")
                            .font(.title3.weight(.medium))
                        Spacer()
                        Menu {
                            Button("Edit", systemImage: "pencil") {
                                openActivity = true
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
                                ForEach(viewModel.activities) { activity in
                                    HStack {
                                        if let symbol = activity.symbol {
                                            Image(systemName: symbol)
                                        }
                                        Text(activity.name)
                                            .font(.subheadline)
                                    }
                                    .pillStyle()
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
        .sheet(isPresented: $openEffects) {
            EffectSelectorView(sessionViewModel: $viewModel)
        }
        .sheet(isPresented: $openWellness) {
            WellnessSelectorView(sessionViewModel: $viewModel)
                .id("WellnessSelectorView")
        }
        .sheet(isPresented: $openActivity) {
            ActivitySelectorView(sessionViewModel: $viewModel)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Logs")
                    .headerTitle()
                LogsPickerView(viewModel: $viewModel)
            }
            .padding(.horizontal)
        }
    }
    .modelContainer(SampleData.shared.container)
    .onAppear {
        viewModel.mood = SampleData.shared.mood
        viewModel.effects = [SampleData.shared.effect]
        //viewModel.wellnessEntries = [SampleData.shared.wellnessEntry]
        //viewModel.activities = [SampleData.shared.activity]
    }
}
