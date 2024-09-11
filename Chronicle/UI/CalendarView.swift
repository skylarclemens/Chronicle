//
//  CalendarView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/29/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var date: Date
    var clearFunction: (() -> Void)?
    var displayedComponents: DatePickerComponents = [.date]
    
    var body: some View {
        VStack {
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .datePickerStyle(.graphical)
                .frame(width: 320, height: 360)
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
                    if let clearFunction {
                        clearFunction()
                    } else {
                        date = Date()
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    @State var date: Date = Date()
    @State var show = true
    return VStack {
        
    }
    .sheet(isPresented: $show) {
        NavigationStack {
            CalendarView(date: $date, displayedComponents: [.date, .hourAndMinute])
        }
        .presentationDetents([.height(460)])
        .presentationBackground(.thickMaterial)
    }
}
