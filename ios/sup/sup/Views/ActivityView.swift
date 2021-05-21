//
//  ActivityView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationView {
            Text("recent activity")
            
        }.navigationBarTitle("Activity", displayMode: .inline)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
