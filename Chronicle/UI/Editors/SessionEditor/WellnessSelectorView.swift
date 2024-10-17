//
//  WellnessSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/16/24.
//

import SwiftUI
import SwiftData

struct WellnessSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    @State private var viewModel = WellnessSelectorViewModel()
    
    @State private var openAddWellness: Bool = false
    @State private var openAddWellnessEntry: Bool = false
    
    @Query(sort: [SortDescriptor(\Wellness.isCustom, order: .reverse), SortDescriptor(\Wellness.name)]) var wellnessList: [Wellness]
    
    var filteredWellnessList: [Wellness] {
        wellnessList.filter {
            if let name = $0.name {
                return !viewModel.entries.contains {
                    $0.wellness?.name == name
                }
            }
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.entries.isEmpty {
                        Text("None")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.entries) { entry in
                                if let wellness = entry.wellness {
                                    HStack {
                                        Text(wellness.name ?? "")
                                        Text(wellness.type?.rawValue.localizedCapitalized ?? "")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(.secondarySystemFill),
                                                        in: Capsule())
                                        Spacer()
                                        Text(entry.intensity ?? 0, format: .number)
                                        Button {
                                            withAnimation {
                                                viewModel.entries.removeAll { $0.id == entry.id }
                                            }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.secondary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                } header: {
                    HStack {
                        Text("Attribute")
                        Spacer()
                        Text("Intensity")
                    }
                }
                Section("Wellness Attributes") {
                    Button {
                        openAddWellness = true
                    } label: {
                        HStack {
                            Text("Add New Attribute")
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                        }
                        
                    }
                    ForEach(filteredWellnessList) { wellness in
                        Button {
                            withAnimation {
                                openAddWellnessEntry = true
                                viewModel.selectedWellness = wellness
                            }
                        } label: {
                            HStack {
                                Text(wellness.name ?? "")
                                Text(wellness.type?.rawValue.localizedCapitalized ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(.secondarySystemFill),
                                                in: Capsule())
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundStyle(.accent)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Wellness Entries")
            .navigationBarTitleDisplayMode(.inline)
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
                        save()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
            .sheet(isPresented: $openAddWellness) {
                AddCustomWellnessView(list: wellnessList)
                    .presentationDetents([.height(250)])
            }
            .sheet(isPresented: $openAddWellnessEntry) {
                AddWellnessEntryView(viewModel: $viewModel)
                    .presentationDetents([.height(250)])
            }
        }
        .onAppear {
            if !sessionViewModel.wellnessEntries.isEmpty {
                viewModel.entries.append(contentsOf: sessionViewModel.wellnessEntries)
            }
        }
        .onChange(of: viewModel.entries) { oldValue, newValue in
            print("Entries changed: \(newValue.count) entries")
        }
    }
    
    private func save() {
        sessionViewModel.wellnessEntries = viewModel.entries
    }
}

struct AddWellnessEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: WellnessSelectorViewModel
    @State private var intensity: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                if let wellness = viewModel.selectedWellness {
                    Text(wellness.name ?? "")
                    HStack {
                        Text("Intensity")
                        Spacer()
                        VStack(spacing: 0) {
                            Slider(value: $intensity, in: 0...10, step: 1) {
                                Text("Intensity")
                            } minimumValueLabel: {
                                Text("0")
                            } maximumValueLabel: {
                                Text("10")
                            }
                            Text(Int(intensity), format: .number)
                        }
                        .frame(maxWidth: 200)
                    }
                }
            }
            .navigationTitle("Add Wellness Entry")
            .navigationBarTitleDisplayMode(.inline)
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
                    Button("Add") {
                        addWellnessEntry()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
    }
    
    private func addWellnessEntry() {
        print("Before adding: \(viewModel.entries.count) entries")
        guard let wellness = viewModel.selectedWellness else { return }
        let newEntry = WellnessEntry(wellness: wellness, intensity: Int(intensity))
        withAnimation {
            viewModel.entries.append(newEntry)
        }
        print("After adding: \(viewModel.entries.count) entries")
    }
}

struct AddCustomWellnessView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var list: [Wellness]
    
    @State private var name: String = ""
    @State private var type: WellnessType = .symptom
    
    var nameAlreadyExists: Bool {
        list.contains { $0.name == self.name }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                } footer: {
                    if nameAlreadyExists {
                        Text("Name must be unique.")
                    }
                }
                Section {
                    Picker("Type", selection: $type) {
                        ForEach(WellnessType.allCases, id: \.rawValue) { wellnessType in
                            Text(wellnessType.rawValue.localizedCapitalized).tag(wellnessType)
                        }
                    }
                    .tint(.accent)
                }
            }
            .navigationTitle("New Wellness Attribute")
            .navigationBarTitleDisplayMode(.inline)
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
                    Button("Add") {
                        addNewWellness()
                        dismiss()
                    }
                    .disabled(name.isEmpty || nameAlreadyExists)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
    }
    
    private func addNewWellness() {
        let newWellness = Wellness(name: name, type: type, isCustom: true)
        withAnimation {
            modelContext.insert(newWellness)
        }
    }
}

@Observable
class WellnessSelectorViewModel {
    var entries: [WellnessEntry] = []
    var selectedWellness: Wellness? = nil
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        VStack {}
        .sheet(isPresented: .constant(true)) {
            WellnessSelectorView(sessionViewModel: $viewModel)
        }
    }
    .modelContainer(SampleData.shared.container)
}
