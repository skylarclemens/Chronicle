//
//  AddContentSheets.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/29/24.
//

import SwiftUI

struct AddContentSheets: ViewModifier {
    @State var openAddItem: Bool = false
    @State var openAddSession: Bool = false
    @State var openAddAccessory: Bool = false
    @State var openAddStrain: Bool = false
    @State var openAddSelector: Bool = false
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                Button {
                    openAddSelector = true
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55)
                .background(.accent.opacity(0.33),
                    in: Circle())
                .background(.background,
                            in: Circle())
                .shadow(color: .black.opacity(0.15), radius: 10)
                .contentShape(Circle())
                .padding(.trailing)
                .padding(.bottom)
            }
            .sheet(isPresented: $openAddItem) {
                ItemEditorView()
            }
            .sheet(isPresented: $openAddStrain) {
                StrainEditorView()
            }
            .sheet(isPresented: $openAddSession) {
                SessionEditorView()
            }
            .sheet(isPresented: $openAddAccessory) {
                AccessoryEditorView()
            }
            .sheet(isPresented: $openAddSelector) {
                AddView(openAddItem: $openAddItem, openAddSession: $openAddSession, openAddAccessory: $openAddAccessory, openAddStrain: $openAddStrain)
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.visible)
            }
    }
}

extension View {
    func addContentSheets() -> some View {
        modifier(AddContentSheets())
    }
}
