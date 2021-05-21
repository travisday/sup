//
//  AccountView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            Text("profile info")
            
        }.navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
