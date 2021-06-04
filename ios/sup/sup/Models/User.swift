//
//  File.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import Foundation

class User: Codable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var email: String?
    var displayName: String?
    var score: Double?
    var sendCount: Int?
    var maxSup: Int?
    var lastOnline: String?
    var pushToken: String?
    var profilePic: String?
    var streak: Int?
    var requests:[User]?
    var requested:[User]?

    init(uid: String, displayName: String?, email: String?) {
        self.id = uid
        self.email = email
        self.displayName = displayName
        self.requests = [User]()
        self.requested = [User]()
    }

}
