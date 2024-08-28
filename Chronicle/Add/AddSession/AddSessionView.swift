//
//  AddSessionView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddSessionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddSessionViewModel()
    
    @Query(sort: \Item.name) var items: [Item]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $viewModel.title)
                    }
                    Section {
                        Picker("Item", systemImage: "tray", selection: $viewModel.item) {
                            Text("None").tag(nil as Item?)
                            ForEach(items, id: \.self) { item in
                                Text(item.name).tag(item as Item?)
                            }
                        }
                    }
                    Section {
                        DatePicker(selection: $viewModel.date) {
                            Label("Date", systemImage: "calendar")
                        }
                        HStack {
                            Label("Duration", systemImage: "clock")
                            Spacer()
                            TimePickerWheel(timerNumber: $viewModel.duration)
                        }
                    }
                    Section {
                        HStack(spacing: 16) {
                            Label("Location", systemImage: "map")
                            // TODO: Update to use map and location
                            TextField("My room", text: $viewModel.location)
                        }
                    }
                    Section("Photos") {
                        if viewModel.selectedImages.count > 0 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 8) {
                                    ForEach(viewModel.selectedImages, id: \.self) { uiImage in
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150, alignment: .leading)
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                }
                                .padding()
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                            Label("Select photos", systemImage: "photo.badge.plus")
                        }
                        .onChange(of: viewModel.pickerItems) { oldValues, newValues in
                            Task {
                                viewModel.selectedImages = []
                                viewModel.selectedImagesData = []
                                
                                for value in newValues {
                                    if let imageData = try? await value.loadTransferable(type: Data.self),
                                        let uiImage = UIImage(data: imageData) {
                                        viewModel.selectedImagesData.append(imageData)
                                        withAnimation {
                                            viewModel.selectedImages.append(uiImage)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Section("Notes") {
                        TextField("Best sesh ever.", text: $viewModel.notes, axis: .vertical)
                            .lineLimit(8, reservesSpace: true)
                    }
                }
                Spacer()
                NavigationLink {
                    AddSessionEffectsView(viewModel: $viewModel, parentDismiss: dismiss)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accentColor)
                .padding()
                .disabled(viewModel.item == nil)
            }
            .navigationTitle("New Session")
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
    }
}

struct AddSessionEffectsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: AddSessionViewModel
    let parentDismiss: DismissAction
    
    @State var selectedEffect: Trait?
    @State var intensity: Double = 5.0
    
    var body: some View {
        VStack {
            List {
                if !viewModel.effects.isEmpty {
                    ForEach(viewModel.effects, id: \.self) { effect in
                        HStack {
                            Text(effect.trait.name)
                            Spacer()
                            Text("Intensity: \(effect.intensity)")
                        }
                    }
                    .onDelete(perform: viewModel.removeEffect)
                }
            }
            Spacer()
            Form {
                Picker("Effect", selection: $selectedEffect) {
                    Text("None").tag(nil as Trait?)
                    ForEach(Trait.predefinedEffects, id: \.self) { effect in
                        HStack(spacing: 4) {
                            Text(effect.emoji ?? "")
                            Text(effect.name)
                        }
                        .tag(effect as Trait?)
                        
                    }
                }.pickerStyle(.navigationLink)
                VStack(alignment: .leading) {
                    Text("Intensity")
                    Slider(value: $intensity, in: 0...10, step: 1) {
                        Text("Intensity")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("10")
                    }
                    Text(intensity, format: .number)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Button("Add Effect") {
                    if let selectedEffect {
                        viewModel.addTrait(selectedEffect, intensity: Int(intensity))
                        self.selectedEffect = nil
                        intensity = 5
                    }
                }
                .disabled(selectedEffect == nil)
            }
            Spacer()
            NavigationLink {
                AddSessionFlavorsView(viewModel: $viewModel, parentDismiss: parentDismiss)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
        }
        .navigationTitle("Effects")
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

struct AddSessionFlavorsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: AddSessionViewModel
    let parentDismiss: DismissAction
    
    @State var selectedFlavor: Trait?
    
    var body: some View {
        VStack {
            List {
                if viewModel.flavors.count > 0 {
                    ForEach(viewModel.flavors, id: \.self) { flavor in
                        HStack(spacing: 4) {
                            Text(flavor.trait.emoji ?? "")
                            Text(flavor.trait.name)
                        }
                    }
                    .onDelete(perform: viewModel.removeFlavor)
                }
            }
            
            Form {
                Picker("Flavor", selection: $selectedFlavor) {
                    Text("None").tag(nil as Trait?)
                    ForEach(Trait.predefinedFlavors, id: \.self) { flavor in
                        HStack(spacing: 4) {
                            Text(flavor.emoji ?? "")
                            Text(flavor.name)
                        }
                        .tag(flavor as Trait?)
                        
                    }
                }.pickerStyle(.navigationLink)
                Button("Add Flavor") {
                    if let selectedFlavor {
                        viewModel.addTrait(selectedFlavor)
                        self.selectedFlavor = nil
                    }
                }
                .disabled(selectedFlavor == nil)
            }
            
            Spacer()
            Button {
                do {
                    try viewModel.save(modelContext: modelContext)
                } catch {
                    print("New session could not be saved.")
                }
                parentDismiss()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
        }
        .navigationTitle("Flavors")
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

@Observable
class AddSessionViewModel {
    var date: Date = Date()
    var title: String = ""
    var item: Item?
    var duration: Double = 0
    var effects: [SessionTraitViewModel] = []
    var flavors: [SessionTraitViewModel] = []
    var sessionTraits: [SessionTrait] = []
    var notes: String = ""
    var location: String = ""
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    var selectedImages: [UIImage] = []
    
    func save(modelContext: ModelContext) throws {
        if let item {
            let newSession = Session(item: item)
            newSession.date = date
            newSession.title = title
            newSession.notes = notes
            newSession.duration = duration
            newSession.location = location
            newSession.imagesData = selectedImagesData
            
            updateTraits(for: effects, modelContext: modelContext)
            updateTraits(for: flavors, modelContext: modelContext)
            
            newSession.traits = sessionTraits
            
            modelContext.insert(newSession)
            
            try modelContext.save()
        }
    }
    
    private func updateTraits(for traitViewModels: [SessionTraitViewModel], modelContext: ModelContext) {
        if let item {
            for traitVM in traitViewModels {
                let itemTrait = item.traits.first { $0.trait.id == traitVM.trait.id } ?? ItemTrait(trait: traitVM.trait, item: item)
                let sessionTrait = SessionTrait(itemTrait: itemTrait, intensity: traitVM.intensity)
                
                sessionTraits.append(sessionTrait)
            }
        }
    }
    
    func addTrait(_ trait: Trait, intensity: Int = 0) {
        if trait.type == .effect {
            effects.append(SessionTraitViewModel(trait: trait, intensity: intensity))
        } else if trait.type == .flavor {
            flavors.append(SessionTraitViewModel(trait: trait))
        }
    }
    
    func removeEffect(at offsets: IndexSet) {
        effects.remove(atOffsets: offsets)
    }
    
    func removeFlavor(at offsets: IndexSet) {
        flavors.remove(atOffsets: offsets)
    }
}

struct SessionTraitViewModel: Identifiable, Hashable {
    let id = UUID()
    let trait: Trait
    let intensity: Int
    
    init(trait: Trait, intensity: Int = 0) {
        self.trait = trait
        self.intensity = intensity
    }
}

#Preview {
    AddSessionView()
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddSessionViewModel()
    
    return NavigationStack {
        AddSessionEffectsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddSessionViewModel()
    
    return NavigationStack {
        AddSessionFlavorsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}
