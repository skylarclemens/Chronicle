//
//  SessionEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct SessionEditorView: View {
    enum Field {
        case title, notes
    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = SessionEditorViewModel()
    @State private var openCalendar: Bool = false
    @State private var openNotes: Bool = false
    @FocusState var focusedField: Field?
    
    var session: Session?
    
    @Query(sort: \Item.name) var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading) {
                        HorizontalImagesView(selectedImagesData: $viewModel.selectedImagesData, rotateImages: true)
                            .frame(height: 180)
                        VStack(alignment: .leading) {
                            Section {
                                TextField("Title", text: $viewModel.title)
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                                    .padding(.vertical, 8)
                                    .padding(.trailing)
                                    .focused($focusedField, equals: .title)
                                    .submitLabel(.done)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Section {
                                    HStack(spacing: -4) {
                                        Image(systemName: "link")
                                        Picker("Item", systemImage: "tray", selection: $viewModel.item) {
                                            Text("Item").tag(nil as Item?)
                                            ForEach(items, id: \.self) { item in
                                                Text(item.name).tag(item as Item?)
                                            }
                                        }
                                    }
                                    .tint(.primary)
                                    .padding(.leading, 8)
                                    .background(.accent.opacity(0.33),
                                                in: RoundedRectangle(cornerRadius: 50))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .strokeBorder(.accent.opacity(0.5))
                                    )
                                }
                                Section {
                                    HStack {
                                        Button {
                                            openCalendar = true
                                        } label: {
                                            HStack {
                                                Image(systemName: "calendar")
                                                Text("\(viewModel.dateString), \(viewModel.date.formatted(date: .omitted, time: .shortened))")
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(.quaternary,
                                                    in: RoundedRectangle(cornerRadius: 50))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .strokeBorder(.quaternary)
                                        )
                                        
                                        Button {} label: {
                                            HStack {
                                                Image(systemName: "timer")
                                                TimePickerWheel(label: "Duration", showBackground: false, timerNumber: $viewModel.duration)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(viewModel.duration == 0 ? .secondary : .primary)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(.quaternary,
                                                    in: RoundedRectangle(cornerRadius: 50))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .strokeBorder(.quaternary)
                                        )
                                    }
                                }
                            }
                            if !viewModel.notes.isEmpty {
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("Notes")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        Text(viewModel.notes)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                                        in: RoundedRectangle(cornerRadius: 8))
                                    }
                                    .padding(.vertical)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // Save Session button
                VStack {
                    Spacer()
                    Button {
                        do {
                            try save()
                        } catch {
                            print("New/edited session could not be saved.")
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(viewModel.item == nil || viewModel.title.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color(red: 16 / 255, green: 69 / 255, blue: 29 / 255))
                    .padding()
                }
                .background(
                    Color(UIColor.systemBackground).mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                )
                .frame(height: 100)
            }
            .navigationTitle("\(session == nil ? "New" : "Edit") Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Close
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                // Toolbar to add items to session
                ToolbarItemGroup(placement: .bottomBar) {
                    PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                        Label("Select photos", systemImage: "photo.fill")
                    }
                    .tint(.primary)
                    Spacer()
                    Button("Open notes", systemImage: "note.text") {
                        openNotes = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                }
                // Show same toolbar when keyboard opens
                ToolbarItemGroup(placement: .keyboard) {
                    PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                        Label("Select photos", systemImage: "photo.fill")
                    }
                    .tint(.primary)
                    Spacer()
                    Button("Open notes", systemImage: "note.text") {
                        openNotes = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    .padding(.horizontal)
                    Spacer()
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    .tint(.primary)
                }
            }
            .toolbarBackground(.visible, for: .bottomBar)
            .interactiveDismissDisabled()
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.pickerItems) { oldValues, newValues in
                Task {
                    if viewModel.pickerItems.count == 0 { return }
                    
                    for value in newValues {
                        if let imageData = try? await value.loadTransferable(type: Data.self) {
                            withAnimation {
                                viewModel.selectedImagesData.append(imageData)
                            }
                        }
                    }
                    
                    viewModel.pickerItems.removeAll()
                }
            }
            .sheet(isPresented: $openCalendar) {
                NavigationStack {
                    CalendarView(date: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                }
                .presentationDetents([.height(460)])
                .presentationBackground(.thickMaterial)
            }
            .sheet(isPresented: $openNotes) {
                NavigationStack {
                    NotesEditorView(notes: $viewModel.notes)
                }
                .presentationDetents([.medium])
                .presentationBackground(.thickMaterial)
            }
        }
        .onAppear {
            if let session {
                viewModel.item = session.item
                viewModel.title = session.title
                viewModel.date = session.date
                viewModel.duration = session.duration ?? 0
                viewModel.location = session.location ?? ""
                viewModel.notes = session.notes ?? ""
                viewModel.selectedImagesData = session.imagesData ?? []
                
                viewModel.effects = session.traits
                    .filter { $0.itemTrait?.trait.type == .effect }
                    .map { SessionTraitViewModel($0) }
                viewModel.flavors = session.traits
                    .filter { $0.itemTrait?.trait.type == .flavor }
                    .map { SessionTraitViewModel($0) }
            }
            
            focusedField = .title
        }
    }
    
    func save() throws {
        if let item = viewModel.item {
            let newSession = session ?? Session()
            newSession.item = item
            newSession.date = viewModel.date
            newSession.title = viewModel.title
            newSession.notes = viewModel.notes
            newSession.duration = viewModel.duration
            newSession.location = viewModel.location
            newSession.imagesData = viewModel.selectedImagesData
            
            newSession.traits.forEach { modelContext.delete($0) }
            newSession.traits.removeAll()
            
            viewModel.updateTraits(for: viewModel.effects, modelContext: modelContext)
            viewModel.updateTraits(for: viewModel.flavors, modelContext: modelContext)
            
            newSession.traits = viewModel.sessionTraits
            if session == nil {
                modelContext.insert(newSession)
            }
            
            try modelContext.save()
        }
    }
}

struct SessionEditorEffectsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: SessionEditorViewModel
    let parentDismiss: DismissAction
    
    var session: Session?
    
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
                SessionEditorFlavorsView(viewModel: $viewModel, parentDismiss: parentDismiss, session: session)
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

struct SessionEditorFlavorsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: SessionEditorViewModel
    let parentDismiss: DismissAction
    
    var session: Session?
    
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
class SessionEditorViewModel {
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
    
    var dateString: String {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) ? "Today" : date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateTraits(for traitViewModels: [SessionTraitViewModel], modelContext: ModelContext) {
        if let item {
            for traitVM in traitViewModels {
                let itemTrait = item.traits.first { $0.trait.name == traitVM.trait.name } ?? ItemTrait(trait: traitVM.trait, item: item)
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
    
    init(_ sessionTrait: SessionTrait) {
        self.trait = sessionTrait.itemTrait!.trait
        self.intensity = sessionTrait.intensity ?? 0
    }
}

#Preview {
    SessionEditorView(session: SampleData.shared.session)
        .modelContainer(SampleData.shared.container)
}

/*#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = SessionEditorViewModel()
    
    return NavigationStack {
        SessionEditorEffectsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = SessionEditorViewModel()
    
    return NavigationStack {
        SessionEditorFlavorsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
    .modelContainer(SampleData.shared.container)
}*/
