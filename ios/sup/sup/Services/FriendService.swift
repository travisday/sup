//
//  CardService.swift
//  sup
//
//  Created by Travis on 9/2/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseMessaging
import FirebaseFunctions
import Firebase
import Combine

class FriendService : ObservableObject {
    
    let db = Firestore.firestore()
    @Published var friends: [User] = []
    
    func get(documentId: String) {
        let docRef = db.collection("users").document(documentId)
        
        docRef.collection("friends").addSnapshotListener { [self] (querySnapshot, err) in
            if let err = err {
                    print("Error getting friend requests: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let id = document.documentID
                        print("Test: \(id)")
                        db.collection("users").document(id).addSnapshotListener { document, error in
                            if let error = error as NSError? {
                               print("Error getting document: \(error.localizedDescription)")
                            }
                            else {
                              if let document = document {
                                do {
                                    let id = document.documentID
                                    let data = document.data()
                                    let name = data?["name"] as? String ?? ""
                                    let email = data?["email"] as? String ?? ""
                                    let score = data?["score"] as? Double ?? 0
                                    let pushToken = data?["pushToken"] as? String ?? ""
                                    let tmp = User(uid: id, displayName: name, email: "")
                                    tmp.email = email
                                    tmp.score = score
                                    tmp.pushToken = pushToken
                                    print("Test: \(email)")
                                    if let index = self.friends.firstIndex(of: tmp) {
                                        self.friends[index] = tmp
                                    } else {
                                        self.friends.append(tmp)
                                    }
                                    
                                }
                              }
                            }
                    }
                }
            }
        
    }
    }
    
}
