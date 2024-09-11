//
//  MoodDescriptorSelectView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/7/24.
//

import SwiftUI
import SwiftData

struct MoodDescriptorSelectView: View {
    @Binding var viewModel: SessionEditorViewModel
    let parentDismiss: DismissAction
    
    @State var currentMood: Trait?
    @State var selectedEffects: [Trait] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 15 / 255, green: 7 / 255, blue: 19 / 255))
                .ignoresSafeArea()
            VStack {
                Text("What best describes how you’re feeling?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding()
                EffectsSelectView(selectedEffects: $selectedEffects)
            }
            .frame(maxHeight: .infinity)
            VStack {
                Button {
                    if !selectedEffects.isEmpty {
                        viewModel.effects.removeAll()
                        for effect in selectedEffects {
                            viewModel.addTrait(effect)
                        }
                    }
                    if let currentMood {
                        viewModel.addTrait(currentMood)
                    }
                    parentDismiss()
                } label: {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .padding()
                .background(.regularMaterial,
                            in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.ultraThinMaterial)
                )
                .padding()
            }
            .frame(height: 150)
            .background(
                Color(UIColor.systemBackground).mask(
                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                )
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if !viewModel.effects.isEmpty {
                var initialSelectedEffects: [Trait] = []
                for effect in viewModel.effects {
                    initialSelectedEffects.append(effect.trait)
                }
                self.selectedEffects = initialSelectedEffects
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct EffectsSelectView: View {
    @Query var allEffects: [Trait]
    @Binding var selectedEffects: [Trait]
    
    init(selectedEffects: Binding<[Trait]>) {
        self._selectedEffects = selectedEffects
        
        let effect = TraitType.effect.rawValue
        let filter = #Predicate<Trait> {
            $0.type.rawValue == effect
        }
        self._allEffects = Query(filter: filter)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 30)), GridItem(.flexible(minimum: 30)), GridItem(.flexible(minimum: 30))]) {
                ForEach(allEffects, id: \.self) { effect in
                    let effectSelected = selectedEffects.contains { $0.name == effect.name }
                    Button {
                        if effectSelected {
                            selectedEffects.removeAll { $0.name == effect.name }
                        } else {
                            selectedEffects.append(effect)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(effect.emoji ?? "")
                                .font(.footnote)
                            Text(effect.name)
                                .font(.footnote)
                            if effectSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.footnote)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .tag(effect as Trait?)
                    .padding(8)
                    .background(.regularMaterial,
                                in: RoundedRectangle(cornerRadius: 12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.ultraThinMaterial)
                    )
                }
            }
            .padding(.bottom, 150)
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = SessionEditorViewModel()
    
    return NavigationStack {
        MoodDescriptorSelectView(viewModel: $viewModel, parentDismiss: dismiss)
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    @State var selectedEffects: [Trait] = []
    return EffectsSelectView(selectedEffects: $selectedEffects)
        .modelContainer(SampleData.shared.container)
}
