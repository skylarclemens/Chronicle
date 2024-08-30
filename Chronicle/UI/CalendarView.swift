//
//  CalendarView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/29/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var date: Date?
    
    var body: some View {
        VStack {
            DatePicker("", selection: Binding<Date>(get: {self.date ?? Date()}, set: {self.date = $0}), displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .frame(width: 320)
        }
        .padding()
        .background(.regularMaterial,
                    in: RoundedRectangle(cornerRadius: 12))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("Clear") {
                    date = nil
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    @State var date: Date?
    return NavigationView {
        CalendarView(date: $date)
    }
}
