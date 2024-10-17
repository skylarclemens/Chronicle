//
//  HeaderTitle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/17/24.
//

import SwiftUICore

extension Text {
    func headerTitle() -> some View {
        self
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}
