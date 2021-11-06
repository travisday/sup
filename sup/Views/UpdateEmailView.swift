//
//  UpdateEmailView.swift
//  sup
//
//  Created by Travis on 9/27/21.
//

import Foundation
import SwiftUI

struct UpdateEmailView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var userService: UserService
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var errorMessage = ""
    @State var email = ""
    @Binding var msg: String
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 25) {
                
                Text("Update Email")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                
                CustomTextField(placeHolderText: "Email",
                                text: self.$email)
                    
                CustomButton(title: "Submit",
                             font: UIConfiguration.buttonFont,
                             color: UIConfiguration.buttonColor,
                             textColor: .white,
                             width: 275,
                             height: 45,
                             action: self.update )
                
                Text(errorMessage)
                    .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                        color: UIConfiguration.tintColor))
                
            }.padding(.horizontal, 25)
            
                        
        }
    }
    
    func update() {
        auth.updateEmail(email: self.email) { message in
            self.errorMessage = message
            if message == "" {
                userService.updateEmail(email: self.email)
                msg = "Email updated! A verification email has been sent."
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        
    }
    
}
