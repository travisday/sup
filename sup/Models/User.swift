//
//  File.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import Foundation

class User: Identifiable, Codable, Equatable, ObservableObject {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var email: String?
    var username: String?
    var name: String?
    var score: Double?
    var sendCount: Int?
    var maxSup: Int?
    var lastOnline: String?
    var pushToken: String?
    var profilePic: String?
    var streak: Int?

    init(uid: String, username: String?, email: String?) {
        self.id = uid
        self.email = email
        self.username = username
    }

}
