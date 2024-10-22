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
    
    @FocusState var focusedField: StrainEditorField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        TextField("Strain Name", text: $viewModel.name)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding(.vertical, 8)
                            .padding(.trailing)
                            .focused($focusedField, equals: .name)
                            .submitLabel(.done)
                        HStack {
                            Menu {
                                Button("None") {
                                    withAnimation {
                                        viewModel.type = nil
                                    }
                                }
                                ForEach(StrainType.allCases) { strainType in
                                    Button {
                                        withAnimation {
                                            viewModel.type = strainType
                                        }
                                    } label: {
                                        HStack {
                                            if strainType == viewModel.type {
                                                Image(systemName: "checkmark")
                                            }
                                            Text(strainType.rawValue.localizedCapitalized)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "leaf")
                                    HStack(spacing: 4) {
                                        if let type = viewModel.type {
                                            Text(type.rawValue.localizedCapitalized)
                                                .lineLimit(1)
                                        } else {
                                            Text("Type")
                                                .foregroundStyle(.secondary)
                                        }
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption)
                                    }
                                }
                                .contentShape(.capsule)
                            }
                            .menuStyle(.button)
                            .tint(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.accent.opacity(0.33),
                                        in: Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(.accent.opacity(0.5))
                            )
                            .transition(.opacity)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Description")
                            .headerTitle()
                        TextField("Strain description", text: $viewModel.desc, axis: .vertical)
                            .lineLimit(5...10)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                        in: RoundedRectangle(cornerRadius: 12))
                            
                    }
                }
                .padding(.horizontal)
            }
            .interactiveDismissDisabled()
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("\(strain != nil ? "Edit" : "Add") Strain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
            .onAppear {
                if let strain {
                    viewModel.name = strain.name
                    viewModel.type = strain.type ?? .sativa
                    viewModel.subtype = strain.subtype
                    viewModel.desc = strain.desc
                } else {
                    focusedField = .name
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
    var type: StrainType?
    var subtype: StrainSubType?
    var desc: String = ""
}

public enum StrainEditorField {
    case name
}

#Preview {
    return StrainEditorView()
}
