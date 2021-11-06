//
//  ReAuthViewModel.swift
//  sup
//
//  Created by Travis on 9/23/21.
//

import Foundation

class ReAuthViewModel: ObservableObject {
    @Published var password: String = ""
    
    func reAuth(auth: AuthService, email: String, password: String, completion: @escaping (_ message: String) -> Void) {
        auth.reAuth(email:email, password: password) { message in
            completion(message)
        }
    }
        
}
