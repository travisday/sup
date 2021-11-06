//
//  SignUpViewModel.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp(auth: AuthService, completion: @escaping (_ message: String) -> Void) {
        auth.signUp(username: username.trimmingCharacters(in: [" "]).lowercased(), email: email, password: password) { message in
            completion(message)
        }
    }
}
