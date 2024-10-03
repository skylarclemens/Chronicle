//
//  Strain.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import Foundation
import SwiftData

@Model public class Strain {
    public var name: String
    public var type: StrainType
    public var subtype: StrainSubType?
    public var createdAt: Date
    public var desc: String
    public var favorite: Bool
    
    @Relationship(inverse: \Item.strain) public var items: [Item]
    
    init(name: String, type: StrainType, createdAt: Date = Date(), desc: String = "", favorite: Bool = false, items: [Item] = []) {
        self.name = name
        self.type = type
        self.createdAt = createdAt
        self.desc = desc
        self.favorite = favorite
        self.items = items
    }
    
    static func predicate(
        filter: InventoryFilter = .all,
        searchText: String
    ) -> Predicate<Strain> {
        if filter == .favorites {
            return #Predicate<Strain> { strain in
                (searchText.isEmpty || strain.name.localizedStandardContains(searchText))
                &&
                strain.favorite
            }
        }
        return #Predicate<Strain> { strain in
            searchText.isEmpty || strain.name.localizedStandardContains(searchText)
        }
    }
}
