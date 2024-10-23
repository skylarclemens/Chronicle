//
//  ItemEditorCompositionView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/23/24.
//

import SwiftUI

struct ItemEditorCompositionView: View {
    @Binding var viewModel: ItemEditorViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Composition")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 12) {
                    CannabinoidInputView(compounds: $viewModel.cannabinoids)
                    TerpeneInputView(compounds: $viewModel.terpenes)
                    IngredientsInputView(ingredients: $viewModel.ingredients)
                }
            }
        }
    }
}
