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

        }
        
        var newScore: Double
        if (userTo.score! < 10) {
            newScore = userTo.score! + 1
        } else {
            newScore = userTo.score! + 0.3
        }
        
        let now = Date()
        let formatter = DateFormatter()
        
        db.collection("users").document(userTo.id).updateData(
            [
                "score": newScore,
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
        db.collection("users").document(userTo.id).collection("activity").document().setData(
            [
                "event": "@\(userFrom.username ?? "") sent you a sup",
                "date": now
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend request sent to: \(reqUser.id)")
                }
            }
        
        
        db.collection("users").document(userFrom.id).collection("activity").document().setData(
            [
                "event": "you sent @\(userTo.username ?? "") a sup",
                "date": now
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend request sent to: \(reqUser.id)")
                }
            }
        
        var newCount: Int
        if (userFrom.sendCount == 0) {
            newCount = 0
        } else {
            newCount = userFrom.sendCount! - 1
        }
        
        db.collection("users").document(userFrom.id).updateData(
            [
                "score": (userFrom.score ?? 0) + 0.1,
                "sendCount": newCount,
                
            ]) { err in
                if let err = err {
                    print("Error sending friend request: \(err)")
                } else {
                    //print("Friend added to: \(self.user?.id ?? "")")
                }
            }
        
        
    }
   
    
}


