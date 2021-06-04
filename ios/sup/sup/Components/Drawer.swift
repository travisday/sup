//
//  Drawer.swift
//  sup
//
//  Created by Travis on 5/20/21.
//

import SwiftUI

struct Drawer: View {

    @State private var action: Int? = 0
    @EnvironmentObject var auth: AuthService


    var body: some View {

        VStack(alignment: .leading) {

            HStack {
                NavigationLink(destination: AccountView(), tag: 1, selection: $action) { EmptyView() }
                Button(action: {self.action = 1}) {
                    Image(systemName: "person.crop.square.fill")
                        .foregroundColor(Color(UIConfiguration.buttonColor))
                        .imageScale(.large)
                    Text("Profile")
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        .font(.headline)
                }
            }.padding(.top, 30)
            
            HStack {
                NavigationLink(destination: AddFriendsView(), tag: 2, selection: $action) { EmptyView() }
                Button(action: {self.action = 2}) {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(Color(UIConfiguration.buttonColor))
                        .imageScale(.large)
                    Text("Add Friends")
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        .font(.headline)
                }
            }.padding(.top, 30)

            HStack {
                NavigationLink(destination: SettingsView(), tag: 3, selection: $action) { EmptyView() }
                Button(action: {self.action = 3}) {
                    Image(systemName: "gear")
                        .foregroundColor(Color(UIConfiguration.buttonColor))
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        .font(.headline)
                }
            }.padding(.top, 30)

            HStack {
                Button(action: {auth.signOut()}) {
                    Image(systemName: "arrow.uturn.left.square.fill")
                        .foregroundColor(Color(UIConfiguration.buttonColor))
                        .imageScale(.large)
                    Text("Log out")
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        .font(.headline)
                }
            }.padding(.top, 30)

            Spacer()
        }
    }
}

struct Drawer_Previews: PreviewProvider {
    static var previews: some View {
        Drawer()
    }
}
