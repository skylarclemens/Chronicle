//
//  NotesEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/5/24.
//

import SwiftUI

struct NotesEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var notes: String
    @State var editorText = ""
    
    var body: some View {
        VStack {
            TextField("Best sesh ever.", text: $editorText, axis: .vertical)
                .lineLimit(10, reservesSpace: true)
                .padding(12)
                .background(.thinMaterial,
                            in: RoundedRectangle(cornerRadius: 8))
                .padding()
            Spacer()
            Button {
                withAnimation {
                    notes = editorText
                }
                dismiss()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
            }
            .disabled(editorText.isEmpty)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color(red: 16 / 255, green: 69 / 255, blue: 29 / 255))
            .padding()
        }
        .onAppear {
            if !notes.isEmpty {
                editorText = notes
            }
        }
        .toolbar {
            // Close
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
}

#Preview {
    @State var notes = ""
    return NavigationStack {
        NotesEditorView(notes: $notes)
    }
}
