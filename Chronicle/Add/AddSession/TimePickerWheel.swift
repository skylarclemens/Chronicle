//
//  TimePickerWheel.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/13/24.
//

import SwiftUI

struct TimePickerWheel: View {
    @State var time: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    var totalInSeconds: Double {
        Double((time.hours * 3600) + time.minutes * 60)
    }
    var label: String = ""
    var showBackground: Bool = true
    @Binding var timerNumber: Double
    
    @State var openPopover: Bool = false
    var body: some View {
        Button {
            openPopover = true
        } label: {
            if !label.isEmpty && timerNumber == 0 {
                Text(label)
                    .font(.subheadline)
            } else {
                let timeStr = time.hours > 0 ? "\(time.hours) hr, \(time.minutes) min" : "\(time.minutes) min"
                if showBackground {
                    Text(timeStr)
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 6, leading: 11, bottom: 6, trailing: 11))
                        .background(Color(UIColor.tertiarySystemFill))
                        .clipShape(.rect(cornerRadius: 6))
                } else {
                    Text(timeStr)
                        .font(.subheadline)
                }
            }
        }
        .buttonStyle(.plain)
        .popover(isPresented: $openPopover) {
            HStack(spacing: 0) {
                Picker("hours", selection: $time.hours) {
                    ForEach(0...23, id: \.self) { num in
                        Text("\(num) hour\(num > 1 || num == 0 ? "s" : "")").tag(num)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: -16))
                .padding(.trailing, -16)
                Picker("minutes", selection: $time.minutes) {
                    ForEach(0...59, id: \.self) { num in
                        Text("\(num) minute\(num > 1 || num == 0 ? "s" : "")").tag(num)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: 16))
                .padding(.leading, -16)
            }
            .presentationCompactAdaptation(.popover)
        }
        .onChange(of: totalInSeconds) { oldValue, newValue in
            self.timerNumber = totalInSeconds
        }
    }
}

#Preview {
    TimePickerWheel(timerNumber: .constant(0.0))
}
