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
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
        } headerRight: {
            Button("Add", systemImage: "plus.circle.fill") {
                openPicker = true
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.accent)
            .padding(.trailing)
        }
        .sheet(isPresented: $openPicker) {
            IngredientSelectorView(ingredients: $ingredients)
                .presentationDetents([.height(250)])
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
            VStack(alignment: .leading) {
                HStack {
                    Text("Name")
                    TextField("Ingredient", text: $newIngredient)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 8)
                        .padding(.trailing)
                }
                .padding(.vertical, 8)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
                Button {
                    withAnimation {
                        add()
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .disabled(newIngredient.isEmpty)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accent)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .safeAreaInset(edge: .top) {
                if !addedIngredients.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(addedIngredients.sorted(), id: \.self) { ingredient in
                                Button {
                                    withAnimation {
                                        remove(ingredient: ingredient)
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(ingredient)
                                            .font(.footnote)
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.editorInput)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .contentMargins(.horizontal, 16)
                    .contentMargins(.top, 8)
                    .scrollIndicators(.hidden)
                }
            }
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
