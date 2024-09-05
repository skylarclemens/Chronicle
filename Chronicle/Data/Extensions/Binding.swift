//
//  Binding.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/5/24.
//

import Foundation
import SwiftUI

extension Binding {
    func safeBinding<T>(defaultValue: T) -> Binding<T> where Value == Optional<T> {
        Binding<T>.init(
            get: {
                self.wrappedValue ?? defaultValue
            },
            set: { newValue in
                self.wrappedValue = newValue
            }
        )
    }
}
