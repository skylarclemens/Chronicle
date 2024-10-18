//
//  AddNewActivityView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/18/24.
//

import SwiftUI

struct AddNewActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: ActivitiesViewModel
    
    @State private var name: String = ""
    @State private var category: ActivityCategory? = .entertainment
    
    var nameAlreadyExists: Bool {
        viewModel.activities.contains { $0.name == self.name }
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
                    Picker("Category", selection: $category) {
                        ForEach(ActivityCategory.allCases, id: \.rawValue) { category in
                            Text(category.label).tag(category)
                        }
                    }
                    .tint(.accent)
                }
            }
            .contentMargins(.top, 16)
            .navigationTitle("Add New Activity")
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
                        addNewActivity()
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
    
    private func addNewActivity() {
        let newActivity = Activity(name: name, category: category, isCustom: true)
        withAnimation {
            modelContext.insert(newActivity)
            viewModel.activities.append(newActivity)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        VStack {}
        .sheet(isPresented: .constant(true)) {
            AllActivitiesList(sessionViewModel: $viewModel)
        }
    }
    .modelContainer(SampleData.shared.container)
}
