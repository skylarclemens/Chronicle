//
//  AddSessionView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData

struct AddSessionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddSessionViewModel()
    
    @Query(sort: \Item.name) var items: [Item]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    DatePicker(selection: $viewModel.date) {
                        Label("Date", systemImage: "calendar")
                    }
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
                    HStack {
                        Label("Duration", systemImage: "clock")
                        Spacer()
                        TimePickerWheel(timerNumber: $viewModel.duration)
                    }
                }
                Section("Notes") {
                    TextField("Best sesh ever.", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(10, reservesSpace: true)
                }
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

@Observable
class AddSessionViewModel {
    var date: Date = Date()
    var item: Item?
    var duration: Double = 0
    var effects: [SessionEffect]?
    var flavors: [SessionFlavor]?
    var notes: String = ""
    var location: String = ""
}



#Preview {
    AddSessionView()
}
