//
//  EffectSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/19/24.
//

import SwiftUI
import SwiftData

struct EffectSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    
    @State private var viewModel = EffectsViewModel()
    
    @Query(sort: [SortDescriptor(\Effect.isCustom, order: .reverse), SortDescriptor(\Effect.name)]) var effectList: [Effect]
    
    @State private var searchText: String = ""
    @State private var openAddNewEffect: Bool = false
    
    var filteredEffectList: [Effect] {
        if !searchText.isEmpty {
            return effectList.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        return effectList
    }
    
    var effectsByType: [EffectType?: [Effect]] {
        Dictionary(grouping: filteredEffectList, by: \.type)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Button {
                        openAddNewEffect = true
                    } label: {
                        HStack {
                            Text("Add New Effect")
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                
                ForEach(EffectType.allCases, id: \.id) { type in
                    if let typeEffects = effectsByType[type],
                       !typeEffects.isEmpty {
                        Section(type.rawValue) {
                            ForEach(typeEffects) { effect in
                                let selected = viewModel.effects.contains { $0.name == effect.name }
                                Button {
                                    withAnimation {
                                        if selected {
                                            viewModel.effects.removeAll { $0.name == effect.name }
                                        } else {
                                            viewModel.effects.append(effect)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if let emoji = effect.emoji {
                                            Text(emoji)
                                        }
                                        Text(effect.name)
                                        Spacer()
                                        Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(selected ? .accent : .secondary)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .contentMargins(.top, 0)
            .safeAreaInset(edge: .top) {
                if !viewModel.effects.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.effects) { effect in
                                Button {
                                    withAnimation {
                                        if viewModel.effects.contains(where: { $0.name == effect.name }) {
                                            viewModel.effects.removeAll { $0.name == effect.name }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        if let emoji = effect.emoji {
                                            Text(emoji)
                                                .font(.footnote)
                                        }
                                        Text(effect.name)
                                            .font(.footnote)
                                        Image(systemName: "xmark")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.editorInput)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .contentMargins(.horizontal, 16)
                    .contentMargins(.vertical, 8)
                    .scrollIndicators(.hidden)
                    .frame(maxHeight: 60, alignment: .top)
                    .background(
                        Color(.systemGroupedBackground)
                            .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                    )
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search effects")
            .navigationTitle("Select Effects")
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
        }
        .onAppear {
            if !sessionViewModel.effects.isEmpty {
                viewModel.effects = sessionViewModel.effects
            }
        }
        .sheet(isPresented: $openAddNewEffect) {
            AddNewEffectView(viewModel: $viewModel, effects: effectList)
                .presentationDetents([.height(250)])
        }
    }
    
    private func save() {
        withAnimation {
            sessionViewModel.effects = viewModel.effects
        }
    }
}

struct AddNewEffectView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: EffectsViewModel
    
    @State private var name: String = ""
    @State private var type: EffectType = .mental
    
    var effects: [Effect]
    
    var nameAlreadyExists: Bool {
        effects.contains { $0.name.localizedLowercase == self.name.localizedLowercase }
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
                        ForEach(EffectType.allCases, id: \.rawValue) { type in
                            Text(type.rawValue.localizedCapitalized).tag(type)
                        }
                    }
                    .tint(.accent)
                }
            }
            .contentMargins(.top, 16)
            .navigationTitle("Add New Effect")
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
                        addNewEffect()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
    }
    
    private func addNewEffect() {
        let newEffect = Effect(name: name, type: type, isCustom: true)
        withAnimation {
            modelContext.insert(newEffect)
            viewModel.effects.append(newEffect)
        }
    }
}

@Observable
class EffectsViewModel {
    var effects: [Effect] = []
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        EffectSelectorView(sessionViewModel: $viewModel)
    }
    .modelContainer(SampleData.shared.container)
}
