//
//  ItemEditorAdditionalView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/23/24.
//

import SwiftUI

struct ItemEditorAdditionalView: View {
    @Binding var viewModel: ItemEditorViewModel
    @State var openTags: Bool = false
    @FocusState.Binding var focusedField: ItemEditorField?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                openTags = true
                focusedField = nil
            } label: {
                HStack {
                    Text("Tags")
                        .foregroundStyle(.primary)
                    Spacer()
                    HStack {
                        if !viewModel.tags.isEmpty {
                            Text("\(viewModel.tags.count)") +
                            Text(" selected")
                        }
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $openTags) {
            TagEditorView(tags: $viewModel.tags, context: .item)
                .presentationDragIndicator(.hidden)
        }
    }
}
