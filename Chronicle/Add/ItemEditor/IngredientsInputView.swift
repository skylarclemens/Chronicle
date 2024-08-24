//
//  IngredientsInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct IngredientsInputView: View {
    @Binding var ingredients: [String]
    @State private var newIngredient: String = ""
    
    var body: some View {
        List {
            ForEach(ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
            .onDelete(perform: deleteIngredient)
            HStack {
                TextField("Ingredient", text: $newIngredient)
                Button {
                    addNewIngredient()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newIngredient.isEmpty)
                .padding(.leading, 16)
            }
        }
    }
    
    private func addNewIngredient() {
        ingredients.append(newIngredient)
        newIngredient = ""
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var ingredients: [String] = []
    return Form {
        IngredientsInputView(ingredients: $ingredients)
    }
}
