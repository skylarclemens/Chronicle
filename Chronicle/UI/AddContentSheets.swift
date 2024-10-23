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
    @State var allowHaptic: Bool = true
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            if openAddSelector {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(duration: 0.33)) {
                            openAddSelector = false
                        }
                    }
            }
            VStack(alignment: .trailing) {
                ZStack(alignment: .bottom) {
                    if openAddSelector {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .blur(radius: 50)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .frame(width: 210, height: 320)
                        VStack(alignment: .trailing, spacing: 16) {
                            ForEach(AddOption.allCases, id: \.self) { option in
                                addButton(option: option)
                            }
                        }
                        .padding([.top, .leading, .bottom])
                        .transition(.blurReplace.combined(with: .scale(0.5, anchor: .bottomTrailing)))
                    }
                }
                Button {
                    withAnimation(.interactiveSpring(duration: 0.33)) {
                        openAddSelector.toggle()
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55)
                .background(.accent.opacity(0.4),
                            in: Circle())
                .background(.background,
                            in: Circle())
                .rotationEffect(.degrees(openAddSelector ? -45 : 0))
                .shadow(color: .black.opacity(0.1), radius: 10)
                .contentShape(Circle())
                .sensoryFeedback(trigger: openAddSelector) { oldValue, newValue in
                    if allowHaptic {
                        return .impact(flexibility: .solid, intensity: 0.75)
                    }
                    return nil
                }
                .padding(.trailing)
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $openAddItem) {
            ItemEditorView()
        }
        .sheet(isPresented: $openAddSession) {
            SessionEditorView()
        }
        .sheet(isPresented: $openAddStrain) {
            StrainEditorView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $openAddAccessory) {
            AccessoryEditorView()
                .presentationDetents([.medium])
        }
        .onDisappear {
            allowHaptic = false
            withAnimation(.interactiveSpring(duration: 0.33)) {
                openAddSelector = false
            }
        }
        .onAppear {
            allowHaptic = true
        }
    }
    
    @ViewBuilder
    private func addButton(option: AddOption) -> some View {
        Button {
            switch option {
            case .item:
                withAnimation(.interactiveSpring(duration: 0.33)) {
                    openAddSelector = false
                }
                openAddItem = true
            case .session:
                withAnimation(.interactiveSpring(duration: 0.33)) {
                    openAddSelector = false
                }
                openAddSession = true
            case .accessory:
                withAnimation(.interactiveSpring(duration: 0.33)) {
                    openAddSelector = false
                }
                openAddAccessory = true
            case .strain:
                withAnimation(.interactiveSpring(duration: 0.33)) {
                    openAddSelector = false
                }
                openAddStrain = true
            }
        } label: {
            HStack(spacing: 12) {
                Text(option.label())
                    .font(.title3)
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
                Image(systemName: option.symbol())
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .frame(width: 50, height: 50)
                    .background(.accent.opacity(0.25),
                                in: Circle())
                    .background(.background,
                                in: Circle())
            }
        }
        .buttonStyle(.add)
    }
    
    private enum AddOption: CaseIterable {
        case item, accessory, strain, session
        
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

extension View {
    func addContentSheets() -> some View {
        modifier(AddContentSheets())
    }
}

#Preview {
    NavigationStack {
        VStack {
            ScrollView {
                
            }
        }
        .addContentSheets()
        .background(
            BackgroundView()
        )
    }
    .modelContainer(SampleData.shared.container)
}
