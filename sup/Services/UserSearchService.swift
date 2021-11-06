//
//  UserSearchService.swift
//  sup
//
//  Created by Travis on 5/26/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class UserSearchService {
    
    let db = Firestore.firestore()
    
    static func searchUsers(input: String, friends: [User], onSuccess: @escaping (_ user: [User]) -> Void) {
        
        Firestore.firestore().collection("users")
            .whereField("username", isGreaterThanOrEqualTo: input)
            .whereField("username", isLessThan: input + "z")
            .getDocuments { (querySnapshot, error) in
            guard let snap = querySnapshot else {
                print("error")
                return
            }
            
            var users = [User]()
            for document in snap.documents {
                let data = document.data()
                let id = document.documentID
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let score = data["score"] as? Double ?? 0
                let user = User(uid: id, username: username, email: email)
                user.score = score
                
                if (user.id != Auth.auth().currentUser!.uid && (!friends.contains(user)) ) {
                    users.append(user)
                }
                
                onSuccess(users)
            }
             
        }
    }
    
    
    static func searchUsernames(input: String, onSuccess: @escaping (_ users: [QueryDocumentSnapshot]) -> Void) {
        
        Firestore.firestore().collection("users")
            .whereField("username", isEqualTo: input)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    onSuccess(querySnapshot!.documents)
            }
        }
    }
    
}
