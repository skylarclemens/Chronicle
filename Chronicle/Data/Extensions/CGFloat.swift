//
//  CGFloat.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/6/24.
//

import Foundation

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}
