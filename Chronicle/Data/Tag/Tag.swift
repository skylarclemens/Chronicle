//
//  Tag.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/23/24.
//

import SwiftData

@Model
public class Tag {
    var name: String = ""
    var items: [Item]?
    var sessions: [Session]?
    
    init(name: String, items: [Item]? = [], sessions: [Session]? = []) {
        self.name = name
        self.items = items
        self.sessions = sessions
    }
    
    var hasNoItemsOrSessions: Bool {
        if let items, let sessions {
            return items.isEmpty && sessions.isEmpty
        }
        return true
    }
    
    public enum TagContext {
        case item, session, all
    }
}
