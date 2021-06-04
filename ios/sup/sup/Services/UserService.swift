//
//  UserService.swift
//  sup
//
//  Created by Travis on 5/25/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import Firebase
import Combine

class UserService : ObservableObject {
    @Published var user: User?
    @Published var requests_sent = [User]()
    @Published var requests_rec = [User]()
    
    let db = Firestore.firestore()
    
    
    func getCurrentUser(documentId: String) {
        let docRef = db.collection("users").document(documentId)
        docRef.addSnapshotListener { document, error in
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
                    self.user = User(uid: id, displayName: name, email: email)
                    self.user?.score = score
                    print("Data: \(self.user?.email ?? "email nil")")
                }
              }
            }
        }
        
        //TODO: fetch the requests
        docRef.collection("request_sent").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                    print("Error getting friend requests: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let id = document.documentID
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        let tmp = User(uid: id, displayName: name, email: "")
                
                        if let index = self.requests_sent.firstIndex(of: tmp) {
                            self.requests_sent[index] = tmp
                        } else {
                            self.requests_sent.append(tmp)
                        }
                    }
                }
            }
        
        docRef.collection("request_rec").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                    print("Error getting friend requests: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let id = document.documentID
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        let tmp = User(uid: id, displayName: name, email: "")
                        self.requests_rec.append(tmp)
                        
                        
                    }
                }
            }
    }
    
    func sendFriendRequest(reqUser:User) {
        // add request to the user the current user would like to friend
        db.collection("users").document(reqUser.id).collection("request_rec").document(user?.id ?? "").setData(
            [
                "name": user?.displayName ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    print("Friend request sent to: \(reqUser.id)")
                }
            }
        
        // add the request to current user
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("request_sent").document(reqUser.id).setData(
            [
                "name": reqUser.displayName ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend request sent to: \(reqUser.id)")
                }
            }
    }
    
    func acceptFriendRequest(reqUser:User) {
        
        let index = self.requests_rec.firstIndex(of: reqUser)
        self.requests_rec.remove(at: index!)
        
        // remove the current user from the users sent list
        db.collection("users").document(reqUser.id).collection("request_rec").document(user?.id ?? "").delete()
        
        // remove the user from the current users rec list
        db.collection("users").document(user?.id ?? "").collection("request_sent").document(reqUser.id).delete()
        
        //add user to current users friend list
        db.collection("users").document(user?.id ?? "").collection("friends").document(reqUser.id).setData(
            [
                "name": reqUser.displayName ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
        // add current user to users friend list
        db.collection("users").document(reqUser.id).collection("friends").document(user?.id ?? "").setData(
            [
                "name": self.user?.displayName ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    print("Friend added to: \(reqUser.id)")
                }
            }
           
    }

    
}

