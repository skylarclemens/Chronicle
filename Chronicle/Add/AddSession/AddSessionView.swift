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
    
    @State var selectedEffect: Effect?
    @State var intensity: Double = 5.0
    
    var body: some View {
        VStack {
            List {
                if viewModel.effects.count > 0 {
                    ForEach(viewModel.effects, id: \.self) { effect in
                        HStack {
                            Text(effect.effect.name)
                            Spacer()
                            Text("Intensity: \(effect.intensity)")
                        }
                    }
                    .onDelete(perform: removeEffect)
                }
            }
            
            Form {
                Picker("Effect", selection: $selectedEffect) {
                    Text("None").tag(nil as Effect?)
                    ForEach(Effect.predefinedEffects, id: \.self) { effect in
                        HStack(spacing: 4) {
                            Text(effect.emoji)
                            Text(effect.name)
                        }
                        .tag(effect as Effect?)
                        
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
                    addEffect()
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
    
    private func addEffect() {
        if let selectedEffect = selectedEffect {
            let sessionEffect = SessionEffect(effect: selectedEffect, intensity: Int(intensity))
            
            modelContext.insert(sessionEffect)
            viewModel.effects.append(sessionEffect)
        }
        
        selectedEffect = nil
        intensity = 5
    }
    
    private func removeEffect(at offsets: IndexSet) {
        viewModel.effects.remove(atOffsets: offsets)
    }
}

struct AddSessionFlavorsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: AddSessionViewModel
    let parentDismiss: DismissAction
    
    @State var selectedFlavor: Flavor?
    
    var body: some View {
        VStack {
            List {
                if viewModel.flavors.count > 0 {
                    ForEach(viewModel.flavors, id: \.self) { flavor in
                        HStack(spacing: 4) {
                            Text(flavor.flavor.emoji)
                            Text(flavor.flavor.name)
                        }
                    }
                    .onDelete(perform: removeFlavor)
                }
            }
            
            Form {
                Picker("Flavor", selection: $selectedFlavor) {
                    Text("None").tag(nil as Flavor?)
                    ForEach(Flavor.predefinedFlavors, id: \.self) { flavor in
                        HStack(spacing: 4) {
                            Text(flavor.emoji)
                            Text(flavor.name)
                        }
                        .tag(flavor as Flavor?)
                        
                    }
                }.pickerStyle(.navigationLink)
                Button("Add Flavor") {
                    addFlavor()
                }
                .disabled(selectedFlavor == nil)
            }
            
            Spacer()
            Button {
                save()
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
    
    private func save() {
        if let item = viewModel.item {
            let newSession = Session(item: item)
            newSession.date = viewModel.date
            newSession.title = viewModel.title
            newSession.effects = viewModel.effects
            newSession.flavors = viewModel.flavors
            newSession.notes = viewModel.notes
            newSession.duration = viewModel.duration
            newSession.location = viewModel.location
            newSession.imagesData = viewModel.selectedImagesData
            
            modelContext.insert(newSession)
        }
    }
    
    private func addFlavor() {
        if let selectedFlavor = selectedFlavor {
            let sessionFlavor = SessionFlavor(flavor: selectedFlavor)
            
            modelContext.insert(sessionFlavor)
            viewModel.flavors.append(sessionFlavor)
        }
        
        selectedFlavor = nil
    }
    
    private func removeFlavor(at offsets: IndexSet) {
        viewModel.flavors.remove(atOffsets: offsets)
    }
}

@Observable
class AddSessionViewModel {
    var date: Date = Date()
    var title: String = ""
    var item: Item?
    var duration: Double = 0
    var effects: [SessionEffect] = []
    var flavors: [SessionFlavor] = []
    var notes: String = ""
    var location: String = ""
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    var selectedImages: [UIImage] = []
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