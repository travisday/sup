//
//  ContentView.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var userService: UserService
    
    func getUser () {
        auth.listen()
    }
    
    var body: some View {
        Group {
            if (auth.session != nil) {
                HomeView()
            } else {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}
