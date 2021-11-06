//
//  AuthService.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthService : ObservableObject {
    
    var didChange = PassthroughSubject<AuthService, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(uid: user.uid, username: user.displayName, email: user.email)
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }

    func signUp(username: String, email: String, password: String, completion: @escaping (_ message: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

            if let error = error {
                if username.isEmpty { completion("Username cannot be empty") }
                else { completion(error.localizedDescription) }
            } else {
                // If an email account is successfully created, attempt to add the username next
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { error in
                    if error != nil { completion("Error with username") }
                    else {
                        completion("")
                        // add user to firestore
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).setData(
                            [
                                "username": username,
                                "email": email,
                                "name": "",
                                "pushToken": "",
                                "score": 0,
                                "maxSup": 20,
                                "sendCount": 20,
                                "profilePic": "",
                                
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("User added with ID: \(Auth.auth().currentUser!.uid)")
                                }
                            }
                    }
                }
            }
            
        }
        
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                print(error)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (_ message: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                if email.isEmpty { completion("Email cannot be empty") }
                else if password.isEmpty { completion("Password cannot be empty") }
                else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."
                { completion("Account not found. Either your username or password are incorrect")}
                else { completion(error.localizedDescription) }
            }
            else {
                completion("")
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (_ message: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                if email.isEmpty { completion("Email cannot be empty") }
                else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."
                { completion("An account was not found with this email")}
                else { completion(error.localizedDescription) }
            }
            else { completion("A password reset email has been sent to \(email)") }
        }
    }
    
    func updateEmail(email: String, completion: @escaping (_ message: String) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error {
                print(error)
                completion("Unable to update email")
            } else {
                completion("")
            }
        }
//        Auth.auth().currentUser?.sendEmailVerification { error in
//            if let error = error {
//                print(error)
//            }
//        }
        
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        
        self.db.collection("users").document(Auth.auth().currentUser!.uid).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("User deleted")
                }
            }

        user?.delete { error in
          if let error = error {
            print(error)
          } else {
            // Account deleted.
          }
        }
    }
    
    func updatePassword(password: String, completion: @escaping (_ message: String) -> Void) {
        
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if let error = error {
                print(error)
                completion("Unable to update password")
            } else {
                completion("")
            }
        }
        
    }
    
    func reAuth(email: String, password: String, completion: @escaping (_ message: String) -> Void) {
        
        let email = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: email) { authResult, error  in
            if error != nil {
                completion("Invalid Password")
            } else {
                if authResult != nil {
                    completion("")
                } else {
                    completion("Something went wrong")
                }
                
            }
        }
    }
            
    

    func signOut () {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error logging out")
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
