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
                                        .buttonStyle(SessionInputButton())
                                        Button {} label: {
                                            HStack {
                                                Image(systemName: "timer")
                                                TimePickerWheel(label: "Duration", showBackground: false, timerNumber: $viewModel.duration)
                                            }
                                        }
                                        .buttonStyle(SessionInputButton())
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
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 120)
                    .frame(maxHeight: .infinity)
                }
                /// Save Session button
                VStack {
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
                /// Show same toolbar when keyboard opens
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
                    MoodSelectorView(sessionViewModel: $viewModel)
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
                
                if let mood = session.mood {
                    viewModel.mood = mood
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
            session.mood = viewModel.mood
            
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
    var mood: Mood?
    var notes: String = ""
    var location: String = ""
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    
    var dateString: String {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) ? "Today" : date.formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    SessionEditorView(session: SampleData.shared.session)
        .modelContainer(SampleData.shared.container)
}
