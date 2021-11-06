//
//  ActivityView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var userService: UserService
    
    var body: some View {
        ScrollView {
            ForEach(userService.events.reversed()) { event in
                
                HStack(alignment: .center) {
                    Text(event.val).fontWeight(.bold)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.white))
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
                .padding(.top, 10)
                
                Divider()
            
            }
            
        }.navigationBarTitle("Activity", displayMode: .inline)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
