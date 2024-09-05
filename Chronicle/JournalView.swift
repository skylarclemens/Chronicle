//
//  JournalView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @State private var openCalendar: Bool = false
    @State private var date: Date?
    
    var body: some View {
        NavigationStack {
            ZStack {
                SessionsListView(date: date)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        openCalendar = true
                    } label: {
                        HStack {
                            if let date {
                                Text(date, style: .date)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .padding(.leading, 4)
                            }
                            Image(systemName:"calendar")
                                .font(.subheadline)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 7)
                    .background(.quaternary,
                                in: RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .strokeBorder(.quaternary)
                    )
                }
            }
            .sheet(isPresented: $openCalendar) {
                NavigationStack {
                    CalendarView(date: $date.safeBinding(defaultValue: Date()), clearFunction: {
                        self.date = nil
                    })
                }
                .presentationDetents([.medium])
                .presentationBackground(.thickMaterial)
            }
        }
    }
}

#Preview {
    return JournalView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
