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
    @State private var openMood: Bool = false
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
                                        .background(.regularMaterial,
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
                                        .background(.regularMaterial,
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
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Mood")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    if let currentMood = viewModel.moodTrait {
                                        HStack(alignment: .bottom) {
                                            Text(currentMood.trait.name)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(currentMood.trait.color.color.opacity(0.33))
                                                )
                                            Spacer()
                                            Button {
                                                openMood = true
                                            } label: {
                                                Text("Edit")
                                                    .font(.footnote)
                                                    .contentShape(RoundedRectangle(cornerRadius: 12))
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(
                                                        LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing)
                                                            .opacity(0.25)
                                                    )
                                            )
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(
                                                        LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing)
                                                            .opacity(0.75)
                                                    )
                                            )
                                        }
                                    }
                                }
                                if !viewModel.effects.isEmpty {
                                    DetailSection(header: "Feelings", isScrollView: true) {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(viewModel.effects, id: \.self) { effect in
                                                    HStack {
                                                        Text(effect.trait.emoji ?? "")
                                                            .font(.system(size: 12))
                                                        Text(effect.trait.name)
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
                                } else {
                                    Button {
                                        openMood = true
                                    } label: {
                                        HStack {
                                            Text("Log how you're feeling")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.secondary)
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .buttonStyle(.plain)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing)
                                                    .opacity(0.25)
                                            )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                LinearGradient(colors: [Color(red: 10 / 255, green: 132 / 255, blue: 255 / 255), Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)], startPoint: .leading, endPoint: .trailing)
                                                    .opacity(0.75)
                                            )
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 120)
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
                .frame(height: 120)
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
            .sheet(isPresented: $openMood) {
                NavigationStack {
                    MoodSelectorView(viewModel: $viewModel)
                }
                .tint(.primary)
                .presentationDetents([.large])
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
                if let moodTrait = session.traits.first(where: { $0.itemTrait?.trait.type == .mood }) {
                    viewModel.moodTrait = SessionTraitViewModel(moodTrait)
                }
            }
            
            focusedField = .title
        }
    }
    
    @MainActor
    func save() throws {
        if let item = viewModel.item {
            let session = self.session ?? Session()
            session.item = item
            session.date = viewModel.date
            session.title = viewModel.title
            session.notes = viewModel.notes
            session.duration = viewModel.duration
            session.location = viewModel.location
            session.imagesData = viewModel.selectedImagesData
            
            // Update removed traits
            let currentTraitIDs = Set(viewModel.effects.map { $0.trait.id } + [viewModel.moodTrait?.trait.id])
            session.traits.forEach { sessionTrait in
                if !currentTraitIDs.contains(sessionTrait.itemTrait?.trait.id) {
                    modelContext.delete(sessionTrait)
                }
            }
            
            // Update current traits and add new ones
            viewModel.updateTraits(for: viewModel.effects, in: session, modelContext: modelContext)
            if let moodTrait = viewModel.moodTrait {
                viewModel.updateTraits(for: [moodTrait], in: session, modelContext: modelContext)
            }
            
            if self.session == nil {
                modelContext.insert(session)
            }
            
            try modelContext.save()
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
    var moodTrait: SessionTraitViewModel?
    var notes: String = ""
    var location: String = ""
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    
    var dateString: String {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) ? "Today" : date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateTraits(for traitViewModels: [SessionTraitViewModel], in session: Session, modelContext: ModelContext) {
        if let item = session.item {
            for traitVM in traitViewModels {
                let itemTrait = item.traits.first { $0.trait.name == traitVM.trait.name } ?? {
                    let trait = getTrait(traitVM.trait, modelContext: modelContext)
                    return ItemTrait(trait: trait, item: item)
                }()
                
                if let existingSessionTrait = session.traits.first(where: { $0.itemTrait?.trait.name == traitVM.trait.name }) {
                    existingSessionTrait.intensity = traitVM.intensity
                } else {
                    let sessionTrait = SessionTrait(itemTrait: itemTrait, session: session, intensity: traitVM.intensity)
                    session.traits.append(sessionTrait)
                }
            }
        }
    }
    
    func addTrait(_ trait: Trait, intensity: Int = 0) {
        if trait.type == .effect {
            effects.append(SessionTraitViewModel(trait: trait, intensity: intensity))
        } else if trait.type == .mood {
            moodTrait = SessionTraitViewModel(trait: trait)
        }
    }
    
    func removeEffect(at offsets: IndexSet) {
        effects.remove(atOffsets: offsets)
    }
    
    func getTrait(_ trait: Trait, modelContext: ModelContext) -> Trait {
        let id = trait.id
        var traitFetchDescriptor = FetchDescriptor<Trait>(predicate: #Predicate {
            $0.id == id
        })
        traitFetchDescriptor.fetchLimit = 1
        let fetchedTrait = try? modelContext.fetch(traitFetchDescriptor).first
        return fetchedTrait ?? trait
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
