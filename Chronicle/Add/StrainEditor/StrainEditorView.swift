//
//  StrainEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData

struct StrainEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var viewModel = AddStrainViewModel()
    var strain: Strain?
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Name") {
                        TextField("Blue Dream", text: $viewModel.name)
                    }
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(StrainType.allCases) { strainType in
                            Text(strainType.rawValue.localizedCapitalized).tag(strainType)
                        }
                    }
                    Section("Description") {
                        TextField("Description of the strain", text: $viewModel.desc, axis: .vertical)
                    }
                }
                Spacer()
                Button {
                    save()
                    dismiss()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accentColor)
                .disabled(viewModel.name.isEmpty)
                .padding()
            }
            .navigationTitle("\(strain != nil ? "Editing" : "New") Strain")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear {
                if let strain {
                    viewModel.name = strain.name
                    viewModel.type = strain.type
                    viewModel.subtype = strain.subtype
                    viewModel.desc = strain.desc
                }
            }
        }
    }
    
    private func save() {
        if let strain {
            strain.name = viewModel.name
            strain.type = viewModel.type
            strain.subtype = viewModel.subtype
            strain.desc = viewModel.desc
        } else {
            let newStrain = Strain(name: viewModel.name, type: viewModel.type)
            newStrain.desc = viewModel.desc
            
            modelContext.insert(newStrain)
        }
    }
}

@Observable
class AddStrainViewModel {
    var name: String = ""
    var type: StrainType = .sativa
    var subtype: StrainSubType?
    var desc: String = ""
}

#Preview {
    return StrainEditorView()
}
