//
//  AddFriendsViewModel.swift
//  sup
//
//  Created by Travis on 6/1/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import Firebase
import Combine

class AddFriendsViewModel: ObservableObject {
    
    func sendRequest(reqUser:User, userService:UserService){
        userService.sendFriendRequest(reqUser: reqUser)
    }
    
    func acceptRequest(reqUser:User, userService:UserService){
        userService.acceptFriendRequest(reqUser: reqUser)
    }
}
