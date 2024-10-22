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
        DetailSection(header: "Ingredients", isScrollView: true) {
            if !ingredients.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .pillStyle()
                        }
                        Button {
                            openPicker = true
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .tint(.accent)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(.accent.opacity(0.15),
                                    in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
        } headerRight: {
            Group {
                if ingredients.isEmpty {
                    Button {
                        openPicker = true
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .tint(.accent)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(.accent.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 12))
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
            }
            .navigationTitle("Add Ingredients")
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
                    Button("Done") {
                        withAnimation {
                            setIngredients()
                        }
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
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
