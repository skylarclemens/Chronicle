//
//  AddView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/29/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var openAddItem: Bool
    @Binding var openAddSession: Bool
    @Binding var openAddAccessory: Bool
    @Binding var openAddStrain: Bool
    var columns: [GridItem] = [GridItem](repeating: GridItem(), count: 4)
        
    var body: some View {
        VStack {
            Text("ADD NEW")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding()
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(AddOption.allCases, id: \.self) { option in
                    addButton(option: option)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private func addButton(option: AddOption) -> some View {
        Button {
            dismiss()
            switch option {
            case .item:
                openAddItem = true
            case .session:
                openAddSession = true
            case .accessory:
                openAddAccessory = true
            case .strain:
                openAddStrain = true
            }
        } label: {
            VStack {
                Image(systemName: option.symbol())
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .frame(width: 65, height: 65)
                    .background(.accent.opacity(0.25),
                                in: Circle())
                Text(option.label())
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
        }
    }
    
    private enum AddOption: CaseIterable {
        case item, session, accessory, strain
        
        func symbol() -> String {
            switch self {
            case .item:
                "cube.fill"
            case .session:
                "book.pages.fill"
            case .accessory:
                "wrench.and.screwdriver.fill"
            case .strain:
                "leaf.fill"
            }
        }
        
        func label() -> String {
            switch self {
            case .item:
                "Item"
            case .session:
                "Session"
            case .accessory:
                "Accessory"
            case .strain:
                "Strain"
            }
        }
    }
}

#Preview {
    @Previewable @State var openAddItem: Bool = false
    @Previewable @State var openAddSession: Bool = false
    @Previewable @State var openAddAccessory: Bool = false
    @Previewable @State var openAddStrain: Bool = false
    
    AddView(openAddItem: $openAddItem, openAddSession: $openAddSession, openAddAccessory: $openAddAccessory, openAddStrain: $openAddStrain)
}
