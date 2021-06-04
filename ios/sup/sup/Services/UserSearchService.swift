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
    
    static func searchUsers(input: String, onSuccess: @escaping (_ user: [User]) -> Void) {
        
        Firestore.firestore().collection("users")
            .whereField("name", isGreaterThanOrEqualTo: input)
            .whereField("name", isLessThan: input + "z")
            .getDocuments { (querySnapshot, error) in
            guard let snap = querySnapshot else {
                print("error")
                return
            }
            
            var users = [User]()
            for document in snap.documents {
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let score = data["score"] as? Double ?? 0
                let user = User(uid: id, displayName: name, email: email)
                user.score = score
                
                if (user.id != Auth.auth().currentUser!.uid) {
                    users.append(user)
                }
                
                onSuccess(users)
            }
             
        }
    }
    
}
