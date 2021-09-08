//
//  PushService.swift
//  sup
//
//  Created by Travis on 6/16/21.
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

class PushService : ObservableObject {
    
    let db = Firestore.firestore()
    
    func sendPush(userTo: User, userFrom: User){
        // send push
        Functions.functions().httpsCallable("sendMessage").call(["idTo": userTo.id, "idFrom": userFrom.id]) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
            }
            // Handle error in your app
            // ...
          }

          // Retrieve the custom authentication token and sign in. See
          // https://firebase.google.com/docs/auth/ios/custom-auth
            
          }
        
        
        db.collection("users").document(userTo.id).updateData(
            [
                "score": (userTo.score ?? 0) + 1.0,
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
        db.collection("users").document(userFrom.id).updateData(
            [
                "score": (userFrom.score ?? 0) + 1.0,
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
        
    }
   
    
}


