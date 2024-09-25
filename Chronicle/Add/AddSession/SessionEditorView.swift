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
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = SessionEditorViewModel()
    @State private var openCalendar: Bool = false
    @State private var openNotes: Bool = false
    @State private var openMood: Bool = false
    @State private var openTags: Bool = false
    @State private var showingCamera: Bool = false
    @State private var showingPhotosPicker: Bool = false
    @State private var showingPhotosConfirmationDialog: Bool = false
    @FocusState var focusedField: Field?
    
    var session: Session?
    
    @Query(sort: \Item.name) var items: [Item]
    
    var body: some View {
        NavigationStack {
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
                                    Picker("Item", selection: $viewModel.item) {
                                        Text("Item").tag(nil as Item?)
                                        ForEach(items, id: \.self) { item in
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
                        if let item = viewModel.item {
                            Section {
                                VStack(alignment: .leading) {
                                    Text("Amount")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    HStack {
                                        TextField("2.5", value: $viewModel.amountConsumed, format: .number)
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(.plain)
                                            .padding(.horizontal)
                                            .padding(.vertical, 11)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .clipShape(.rect(cornerRadius: 10))
                                        Text(item.unit ?? "")
                                            .padding(.horizontal)
                                            .padding(.vertical, 11)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                    
                                }
                                .padding(.top)
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
                                .padding(.top)
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Mood")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                if let currentMood = viewModel.mood {
                                    HStack(alignment: .bottom) {
                                        Text(currentMood.type.label)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(currentMood.type.color.opacity(0.33))
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
                            }
                            if let currentMood = viewModel.mood, !currentMood.emotions.isEmpty {
                                DetailSection(header: "Feelings", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(currentMood.emotions, id: \.self) { emotion in
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
                                }
                                .buttonStyle(.mood)
                                .controlSize(.large)
                            }
                        }
                        .padding(.top)
                        Section {
                            SessionEditorAdditionalView(viewModel: $viewModel, openTags: $openTags)
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
                    .disabled(viewModel.item == nil || viewModel.title.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color(red: 16 / 255, green: 69 / 255, blue: 29 / 255))
                    .padding()
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
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                /// Toolbar to add items to session
                ToolbarItemGroup(placement: .bottomBar) {
                    /*PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                        Label("Select photos", systemImage: "photo.fill")
                    }
                    .tint(.primary)*/
                    Button("Open camera", systemImage: "photo.fill") {
                        showingPhotosConfirmationDialog = true
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
                }
                /// Show same toolbar when keyboard opens
                ToolbarItemGroup(placement: .keyboard) {
                    /*PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                        Label("Select photos", systemImage: "photo.fill")
                    }
                    .tint(.primary)*/
                    Button("Open camera", systemImage: "photo.fill") {
                        showingPhotosConfirmationDialog = true
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
            .scrollDismissesKeyboard(.immediately)
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
                    MoodSelectorView(sessionViewModel: $viewModel)
                }
                .tint(.primary)
                .presentationDetents([.large])
                .presentationBackground(.thickMaterial)
            }
            .sheet(isPresented: $openTags) {
                TagEditorView(tags: $viewModel.tags, context: .session)
            }
            .confirmationDialog("Choose an option", isPresented: $showingPhotosConfirmationDialog) {
                Button("Camera") {
                    showingCamera = true
                }
                .tint(.accent)
                Button("Select photos") {
                    showingPhotosPicker = true
                }
                .tint(.accent)
            }
            .photosPicker(isPresented: $showingPhotosPicker, selection: $viewModel.pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)]))
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPicker(isPresented: $showingCamera, image: $viewModel.cameraSelection)
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
                viewModel.amountConsumed = session.amountConsumed
                viewModel.tags = session.tags
                
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
            session.location = viewModel.location
            session.imagesData = viewModel.selectedImagesData
            session.mood = viewModel.mood
            session.tags = viewModel.tags
            if let amountConsumed = viewModel.amountConsumed {
                session.amountConsumed = amountConsumed
            }
            
            if self.session == nil {
                modelContext.insert(session)
            }
            
            try modelContext.save()
        }
    }
    
    enum Field {
        case title, notes
    }
}

struct SessionEditorAdditionalView: View {
    @Binding var viewModel: SessionEditorViewModel
    @Binding var openTags: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                openTags = true
            } label: {
                HStack {
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

@Observable
class SessionEditorViewModel {
    var date: Date = Date()
    var title: String = ""
    var item: Item?
    var duration: Double = 0
    var mood: Mood?
    var notes: String = ""
    var location: String = ""
    var amountConsumed: Double? = nil
    var tags: [Tag] = []
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    
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
