//
//  AddStrainView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI
import SwiftData

struct AddStrainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddStrainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Name") {
                        TextField("Blue Dream", text: $viewModel.name)
                    }
                    Picker("Type", selection: $viewModel.type) {
                        Text("Sativa").tag(StrainType.sativa)
                        Text("Indica").tag(StrainType.indica)
                        Text("Hybrid").tag(StrainType.hybrid)
                    }
                    Section("Description") {
                        TextField("Description of the strain", text: $viewModel.desc, axis: .vertical)
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accentColor)
                .disabled(viewModel.name.isEmpty || viewModel.type == nil)
                .padding()
            }
            .navigationTitle("New Strain")
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
        }
    }
}

@Observable
class AddStrainViewModel {
    var name: String = ""
    var type: StrainType?
    var subtype: StrainSubType?
    var desc: String = ""
}

#Preview {
    //@State var viewModel = AddItemViewModel()
    return AddStrainView()
}
