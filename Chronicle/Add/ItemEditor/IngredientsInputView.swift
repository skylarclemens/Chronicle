//
//  IngredientsInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct IngredientsInputView: View {
    @Binding var ingredients: [String]
    @State private var openPicker: Bool = false
    
    var body: some View {
        InputSectionView(isScrollView: true) {
            if !ingredients.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .pillStyle()
                        }
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
                .padding(.vertical)
            } else {
                Button {
                    openPicker = true
                } label: {
                    HStack {
                        Text("Add")
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tint(.primary)
                .padding(.vertical)
                .padding(.horizontal)
            }
        } header: {
            HStack {
                Text("Ingredients")
                    .foregroundStyle(.secondary)
                Spacer()
                if !ingredients.isEmpty {
                    Button {
                        openPicker = true
                    } label: {
                        Text("Edit")
                            .font(.subheadline)
                    }
                    .tint(.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.regularMaterial,
                                in: Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(.quaternary)
                    )
                    .padding(.trailing)
                }
            }
        }
        .sheet(isPresented: $openPicker) {
            IngredientSelectorView(ingredients: $ingredients)
                .interactiveDismissDisabled()
                .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct IngredientSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var ingredients: [String]
    
    @State private var addedIngredients = Set<String>()
    
    @State private var newIngredient: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("Ingredient", text: $newIngredient)
                                .textFieldStyle(.roundedBorder)
                            Button("Add", systemImage: "plus.circle.fill") {
                                withAnimation {
                                    add()
                                }
                            }
                            .labelStyle(.iconOnly)
                            .disabled(newIngredient.isEmpty)
                        }
                        .padding()
                    }
                    .background(.ultraThickMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    List {
                        ForEach(addedIngredients.sorted(), id: \.self) { ingredient in
                            HStack {
                                HStack {
                                    Text(ingredient)
                                }
                                Spacer()
                                Button("Delete", systemImage: "xmark.circle.fill") {
                                    withAnimation {
                                        remove(ingredient: ingredient)
                                    }
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                    }
                }
                ZStack {
                    Color(UIColor.systemBackground).mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .allowsHitTesting(false)
                    VStack {
                        Button {
                            withAnimation {
                                setIngredients()
                            }
                            dismiss()
                        } label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(Color(red: 16 / 255, green: 69 / 255, blue: 29 / 255))
                        .padding()
                        .ignoresSafeArea(.keyboard)
                    }
                    .padding(.vertical, 20)
                }
                .frame(height: 120)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Add Cannabinoids")
            .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            addedIngredients = Set(ingredients)
        }
    }
    
    private func setIngredients() {
        ingredients = Array(addedIngredients)
    }
    
    private func add() {
        addedIngredients.insert(newIngredient)
        newIngredient = ""
    }
    
    private func remove(ingredient: String) {
        addedIngredients.remove(ingredient)
    }
}

#Preview {
    @Previewable @State var ingredients: [String] = []
    IngredientsInputView(ingredients: $ingredients)
}
