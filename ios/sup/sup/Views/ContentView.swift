//
//  ContentView.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthService
    
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
