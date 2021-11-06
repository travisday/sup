//
//  Event.swift
//  sup
//
//  Created by Travis on 10/7/21.
//

import Foundation

class Event: Identifiable, Codable, Equatable, ObservableObject {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var val: String


    init(id: String, val: String?) {
        self.id = id
        self.val = val ?? ""
    }

}

