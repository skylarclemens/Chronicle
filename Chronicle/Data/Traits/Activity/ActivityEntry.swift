//
//  ActivityEntry.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/17/24.
//

import Foundation
import SwiftData

@Model
public class ActivityEntry {
    public var id: UUID?
    @Relationship public var activity: Activity?
    public var session: Session?
    
    init(id: UUID = UUID(), activity: Activity? = nil, session: Session? = nil) {
        self.id = id
        self.activity = activity
        self.session = session
    }
}
