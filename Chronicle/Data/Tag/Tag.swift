//
//  Tag.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/23/24.
//

import SwiftData

@Model
public class Tag {
    var name: String
    var items: [Item]?
    var sessions: [Session]?
    
    init(name: String, items: [Item]? = nil, sessions: [Session]? = nil) {
        self.name = name
        self.items = items
        self.sessions = sessions
    }
}
