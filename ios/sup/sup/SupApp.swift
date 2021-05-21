//
//  supApp.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI
import Firebase

@main
struct SupApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthService())
        }
    }
}
