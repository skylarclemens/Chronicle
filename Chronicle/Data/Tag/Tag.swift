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
    @Relationship var items: [Item]
    @Relationship var sessions: [Session]
    
    init(name: String, items: [Item] = [], sessions: [Session] = []) {
        self.name = name
        self.items = items
        self.sessions = sessions
    }
    
    var hasNoItemsOrSessions: Bool {
        items.isEmpty && sessions.isEmpty
    }
    
    public enum TagContext {
        case item, session, all
    }
}
