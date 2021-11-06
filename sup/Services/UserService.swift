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
import FirebaseStorage
import FirebaseMessaging
import FirebaseFunctions
import Firebase
import Combine

class UserService : ObservableObject {
    @Published var user: User?
    @Published var requests_sent = [User]()
    @Published var requests_rec = [User]()
    @Published var friends = [User]()
    @Published var events = [Event]()
    
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
                    let username = data?["username"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    let name = data?["name"] as? String ?? ""
                    let score = data?["score"] as? Double ?? 0
                    let sendCount = data?["sendCount"] as? Int ?? 0
                    let pushToken = data?["pushToken"] as? String ?? ""
                    let profilePic = data?["profilePic"] as? String ?? ""
                    self.user = User(uid: id, username: username, email: email)
                    self.user?.score = score
                    self.user?.name = name
                    self.user?.profilePic = profilePic
                    self.user?.sendCount = sendCount
                    self.user?.pushToken = pushToken
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
                        let username = data["username"] as? String ?? ""
                        let tmp = User(uid: id, username: username, email: "")
                
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
                        let username = data["username"] as? String ?? ""
                        let tmp = User(uid: id, username: username, email: "")
                        self.requests_rec.append(tmp)
                        
                        
                    }
                }
            }
        
        docRef.collection("activity").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                    print("Error getting activity: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let event = data["event"] as? String ?? ""
                        let e = Event(id: document.documentID, val: event)
                        
                        if self.events.firstIndex(of: e) == nil {
                            self.events.append(e)
                        }
                        
                    }
                }
            }
        
        self.getFriends(documentId: documentId)
            
    }
    
    func getFriends(documentId: String) {
        let docRef = db.collection("users").document(documentId)
        docRef.collection("friends").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                    print("Error getting friend requests: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let id = document.documentID
                        self.db.collection("users").document(id).addSnapshotListener { document, error in
                            if let error = error as NSError? {
                               print("Error getting document: \(error.localizedDescription)")
                            }
                            else {
                              if let document = document {
                                do {
                                    let id = document.documentID
                                    let data = document.data()
                                    let username = data?["username"] as? String ?? ""
                                    let name = data?["name"] as? String ?? ""
                                    let email = data?["email"] as? String ?? ""
                                    let score = data?["score"] as? Double ?? 0
                                    let sendCount = data?["sendCount"] as? Int ?? 0
                                    let pushToken = data?["pushToken"] as? String ?? ""
                                    let profilePic = data?["profilePic"] as? String ?? ""
                                    let tmp = User(uid: id, username: username, email: "")
                                    tmp.name = name
                                    tmp.email = email
                                    tmp.sendCount = sendCount
                                    tmp.score = score
                                    tmp.pushToken = pushToken
                                    tmp.profilePic = profilePic
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
    
    func sendFriendRequest(reqUser:User) {
        // add request to the user the current user would like to friend
        db.collection("users").document(reqUser.id).collection("request_rec").document(user?.id ?? "").setData(
            [
                "username": user?.username ?? "",
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
                "username": reqUser.username ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend request sent to: \(reqUser.id)")
                }
            }
        
        Functions.functions().httpsCallable("sendFollowRequest").call(["idTo": reqUser.id, "idFrom": user!.id]) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
            }
            // Handle error in your app
            // ...
          }

        }
    }
    
    func acceptFriendRequest(reqUser:User) {
        
        let index = self.requests_rec.firstIndex(of: reqUser)
        self.requests_rec.remove(at: index!)
        
        // remove the current user from the users sent list
        db.collection("users").document(reqUser.id).collection("request_sent").document(user?.id ?? "").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        // remove the user from the current users rec list
        db.collection("users").document(user?.id ?? "").collection("request_rec").document(reqUser.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        //add user to current users friend list
        db.collection("users").document(user?.id ?? "").collection("friends").document(reqUser.id).setData(
            [
                "username": reqUser.username ?? "",
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
                "username": self.user?.username ?? "",
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    print("Friend added to: \(reqUser.id)")
                }
            }
           
    }
    
    func updateInfo (username: String, name: String) {
        
        if username != self.user!.username {
            
            db.collection("users").document(self.user!.id).updateData(
                [
                    "username": username,
                ]) { err in
                    if let err = err {
                        print("Error updating doc: \(err)")
                    } else {
                        //print("Friend added to: \(self.user?.id ?? "")")
                    }
                }
        }
        
        if name != self.user!.name {
            
            db.collection("users").document(self.user!.id).updateData(
                [
                    "name": name,
                ]) { err in
                    if let err = err {
                        print("Error updating doc: \(err)")
                    } else {
                        print("name updated")
                    }
                }
        }
    }
    
    func updateEmail(email: String) {
        
        db.collection("users").document(self.user!.id).updateData(
            [
                "email": email,
            ]) { err in
                if let err = err {
                    print("Error updating doc: \(err)")
                } else {
                    //print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
    }
    
    func uploadProfilePic(img: UIImage){
        guard let d: Data = img.jpegData(compressionQuality: 0.5) else { return }

        let ref = Storage.storage().reference().child("profile_pics/\(Auth.auth().currentUser!.uid).jpg")
        
        let md = StorageMetadata()
        md.contentType = "image/jpeg"

        ref.putData(d, metadata: md) { (metadata, error) in
            if error == nil {
                ref.downloadURL(completion: { (url, error) in
                    print("Done, url is \(String(describing: url))")
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(
                        [
                            "profilePic": url?.absoluteString ?? "",
                        ]) { err in
                            if let err = err {
                                print("Error updating profile pic: \(err)")
                            } else {
                                print("Profile pic updated with User ID: \(Auth.auth().currentUser!.uid)")
                            }
                        }
                    
                })
            }else{
                print("error \(String(describing: error))")
            }
        }
    }

    
}

