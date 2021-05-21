//
//  SettingsView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            
            Text("some settings")
            
        }.navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
