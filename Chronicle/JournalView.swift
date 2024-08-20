//
//  JournalView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Journal")
                }
            }
            .background(
                BackgroundView()
            )
            .navigationTitle("Journal")
        }
    }
}

#Preview {
    JournalView()
}
