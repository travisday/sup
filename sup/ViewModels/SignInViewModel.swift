//
//  SignInViewModel.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loading = false
    @Published var error = false
        
    init() {

    }
    
    func login(auth: AuthService, completion: @escaping (_ message: String) -> Void) {
        auth.signIn(email: email, password: password) { message in
            completion(message)
        }
    }
    
    func resetPassword(auth: AuthService, completion: @escaping (_ message: String) -> Void) {
        auth.resetPassword(email: email) { message in
            completion(message)
        }
    }
}
