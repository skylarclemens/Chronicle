//
//  SessionEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData
import PhotosUI
import MapKit

struct SessionEditorView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = SessionEditorViewModel()
    @State private var openCalendar: Bool = false
    @State private var openNotes: Bool = false
    @State private var openMood: Bool = false
    @State private var openTags: Bool = false
    @State private var openAccessories: Bool = false
    @State private var openRecorder: Bool = false
    @State private var showRecording: Bool = false
    @State private var showingImagesPicker: Bool = false
    @State private var openLocationSearch: Bool = false
    @State private var shouldUpdateInventory: Bool = true
    @State private var showingInventoryUpdateConfirmation: Bool = false
    
    @FocusState var focusedField: Field?
    
    var session: Session?
    
    @Query(sort: \Item.name) var items: [Item]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    EditableHorizontalImagesView(selectedImagesData: $viewModel.selectedImagesData, rotateImages: true)
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
                                    Picker("Item", selection: $viewModel.item.animation()) {
                                        Text("Item").tag(nil as Item?)
                                        ForEach(items, id: \.id) { item in
                                            Text(item.name).tag(item as Item?)
                                        }
                                    }
                                }
                                .tint(.primary)
                                .padding(.leading, 8)
                                .background(.accent.opacity(0.33),
                                            in: Capsule())
                                .overlay(
                                    Capsule()
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
                                    .buttonStyle(.editorInput)
                                    Button {} label: {
                                        HStack {
                                            Image(systemName: "timer")
                                            TimePickerWheel(label: "Duration", showBackground: false, timerNumber: $viewModel.duration)
                                        }
                                    }
                                    .buttonStyle(.editorInput)
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            if let item = viewModel.item {
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("Amount Consumed")
                                            .headerTitle()
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Amount")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                HStack {
                                                    TextField(item.selectedUnits?.amount.promptValue ?? "2.5", value: $viewModel.amountConsumed, format: .number)
                                                        .keyboardType(.decimalPad)
                                                        .textFieldStyle(.plain)
                                                        .focused($focusedField, equals: .amount)
                                                        .padding(.horizontal)
                                                        .padding(.vertical, 8)
                                                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                                                        .clipShape(.rect(cornerRadius: 10))
                                                    Text(item.selectedUnits?.amount.rawValue ?? "")
                                                }
                                            }
                                            .padding(.trailing)
                                            Divider()
                                            Toggle("Update Inventory", systemImage: "arrow.triangle.2.circlepath", isOn: $shouldUpdateInventory)
                                                .onChange(of: shouldUpdateInventory) { _, newValue in
                                                    if newValue {
                                                        showingInventoryUpdateConfirmation = true
                                                    }
                                                }
                                                .padding(.trailing)
                                                .padding(.vertical, 4)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.leading)
                                        .background(Color(UIColor.secondarySystemGroupedBackground),
                                                    in: RoundedRectangle(cornerRadius: 12))
                                        if let currentInventory = item.currentInventory,
                                           currentInventory.value > 0 {
                                            Group {
                                                Text("Current Inventory: ") +
                                                Text(currentInventory.value, format: .number) +
                                                Text(" \(currentInventory.unit.rawValue)")
                                            }
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                            .padding(.leading, 8)
                                        }
                                    }
                                }
                                .alert("Update Inventory?", isPresented: $showingInventoryUpdateConfirmation) {
                                    Button("Yes") { shouldUpdateInventory = true }
                                    Button("No") { shouldUpdateInventory = false }
                                } message: {
                                    Text("Do you want to automatically update your item's current amount based on this session?")
                                }
                                .animation(.default, value: viewModel.item)
                            }
                            if !viewModel.notes.isEmpty {
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("Notes")
                                            .headerTitle()
                                        Text(viewModel.notes)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                                        in: RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("Logs")
                                    .headerTitle()
                                LogsPickerView(viewModel: $viewModel)
                            }
                            if let audioData = viewModel.audioData {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Audio")
                                            .headerTitle()
                                        Spacer()
                                        Menu {
                                            Button("Edit", systemImage: "pencil") {
                                                openRecorder.toggle()
                                            }
                                            Button("Remove", systemImage: "trash", role: .destructive) {
                                                withAnimation {
                                                    viewModel.audioData = nil
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
                                        AudioPlayerView(audioData: audioData)
                                    }
                                }
                            }
                            if let location = viewModel.locationInfo,
                               let mapItem = location.getMapData() {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Location")
                                            .headerTitle()
                                        Spacer()
                                        Menu {
                                            Button("Remove", systemImage: "trash", role: .destructive) {
                                                withAnimation {
                                                    viewModel.locationInfo = nil
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
                                    Map(interactionModes: []) {
                                        Annotation(location.name ?? "", coordinate: mapItem.placemark.coordinate) {
                                            Text(location.name ?? "")
                                        }
                                    }
                                    .frame(height: 125)
                                    .clipShape(.rect(cornerRadius: 12))
                                }
                            }
                            
                            Section {
                                SessionEditorAdditionalView(viewModel: $viewModel, openTags: $openTags, openAccessories: $openAccessories)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 120)
                .frame(maxHeight: .infinity)
            }
            .safeAreaInset(edge: .bottom, alignment: .center) {
                /// Save Session button
                ZStack {
                    ZStack {
                        Color(UIColor.systemBackground).mask(
                            LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                                .opacity(0.9)
                        )
                        .allowsHitTesting(false)
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
                        .saveButton()
                        .disabled(viewModel.item == nil || viewModel.title.isEmpty)
                    }
                    .ignoresSafeArea(.keyboard)
                    if openRecorder {
                        if showRecording {
                            Color(UIColor.systemBackground).mask(
                                LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                            )
                            .allowsHitTesting(false)
                            .transition(.opacity)
                        }
                        VoiceRecordingView(sessionViewModel: $viewModel, openRecorder: $openRecorder, showRecording: $showRecording)
                            .zIndex(1)
                            .transition(.blurReplace)
                    }
                }
                .frame(height: 120)
            }
            .navigationTitle("\(session == nil ? "New" : "Edit") Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                /// Close
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                /// Toolbar to add items to session
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Select photos", systemImage: "photo.fill") {
                        showingImagesPicker = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                    Button("Open notes", systemImage: "note.text") {
                        openNotes = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                    Button("Open voice recorder", systemImage: "waveform") {
                        withAnimation {
                            openRecorder.toggle()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                    Button("Add location", systemImage: "location.fill") {
                        openLocationSearch = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    .disabled(viewModel.locationInfo != nil)
                }
                /// Show same toolbar when keyboard opens
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Select photos", systemImage: "photo.fill") {
                        showingImagesPicker = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                    Button("Open notes", systemImage: "note.text") {
                        openNotes = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    .padding(.horizontal)
                    Spacer()
                    Button("Open voice recorder", systemImage: "waveform") {
                        withAnimation {
                            openRecorder.toggle()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    Spacer()
                    Button("Add location", systemImage: "location.fill") {
                        openLocationSearch = true
                    }
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    .disabled(viewModel.locationInfo != nil)
                }
            }
            .toolbarBackground(.visible, for: .bottomBar)
            .interactiveDismissDisabled()
            .scrollDismissesKeyboard(.immediately)
            .imagesPicker(isPresented: $showingImagesPicker, pickerItems: $viewModel.pickerItems, imagesData: $viewModel.selectedImagesData)
            .background(Color(.systemGroupedBackground))
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
            .sheet(isPresented: $openTags) {
                TagEditorView(tags: $viewModel.tags, context: .session)
            }
            .sheet(isPresented: $openAccessories) {
                AccessoriesSelectorView(accessories: $viewModel.accessories)
            }
            .sheet(isPresented: $openLocationSearch) {
                LocationSelectorView(locationInfo: $viewModel.locationInfo)
            }
        }
        .onAppear {
            if let session {
                viewModel.item = session.item
                viewModel.title = session.title
                viewModel.date = session.date
                viewModel.duration = session.duration ?? 0
                viewModel.locationInfo = session.locationInfo
                viewModel.notes = session.notes ?? ""
                viewModel.selectedImagesData = session.imagesData ?? []
                viewModel.transaction = session.transaction
                if let amountConsumed = session.transaction?.amount?.value {
                    viewModel.amountConsumed = abs(amountConsumed)
                }
                viewModel.tags = session.tags ?? []
                viewModel.accessories = session.accessories ?? []
                viewModel.wellnessEntries = session.wellnessEntries ?? []
                viewModel.activities = session.activities ?? []
                viewModel.effects = session.effects ?? []
                viewModel.audioData = session.audioData
                self.shouldUpdateInventory = session.transaction?.updateInventory ?? true
                
                if let mood = session.mood {
                    viewModel.mood = mood
                }
            } else {
                focusedField = .title
            }
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
            session.locationInfo = viewModel.locationInfo
            session.imagesData = viewModel.selectedImagesData
            session.mood = viewModel.mood
            session.tags = viewModel.tags
            session.accessories = viewModel.accessories
            session.audioData = viewModel.audioData
            let transaction = viewModel.transaction ?? InventoryTransaction(type: .consumption)
            transaction.updateInventory = shouldUpdateInventory
            if let amountConsumed = viewModel.amountConsumed {
                transaction.amount = Amount(value: -amountConsumed, unit: item.selectedUnits?.amount ?? .count)
                item.transactions?.append(transaction)
            }
            session.transaction = transaction
            session.wellnessEntries = viewModel.wellnessEntries
            session.activities = viewModel.activities
            session.effects = viewModel.effects
            
            if self.session == nil {
                modelContext.insert(session)
            }
            
            try modelContext.save()
        }
    }
    
    enum Field {
        case title, amount
    }
}

struct SessionEditorAdditionalView: View {
    @Binding var viewModel: SessionEditorViewModel
    @Binding var openTags: Bool
    @Binding var openAccessories: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional")
                .headerTitle()
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Button {
                    openAccessories = true
                } label: {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundStyle(.secondary)
                        Text("Accessories")
                            .foregroundStyle(.primary)
                        Spacer()
                        HStack {
                            if !viewModel.accessories.isEmpty {
                                Text("\(viewModel.accessories.count)") +
                                Text(" selected")
                            }
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                Button {
                    openTags = true
                } label: {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundStyle(.secondary)
                        Text("Tags")
                            .foregroundStyle(.primary)
                        Spacer()
                        HStack {
                            if !viewModel.tags.isEmpty {
                                Text("\(viewModel.tags.count)") +
                                Text(" selected")
                            }
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
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
    var mood: Mood?
    var notes: String = ""
    var locationInfo: LocationInfo?
    var transaction: InventoryTransaction?
    var amountConsumed: Double?
    var tags: [Tag] = []
    var accessories: [Accessory] = []
    var wellnessEntries: [WellnessEntry] = []
    var activities: [Activity] = []
    var effects: [Effect] = []
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    
    var audioData: Data?
    
    var cameraSelection: UIImage?
    
    var dateString: String {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) ? "Today" : date.formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    SessionEditorView(session: SampleData.shared.session)
        .modelContainer(SampleData.shared.container)
}
