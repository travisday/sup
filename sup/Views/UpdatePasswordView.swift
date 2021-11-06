//
//  UpdatePasswordView.swift
//  sup
//
//  Created by Travis on 9/27/21.
//

import SwiftUI

struct UpdatePasswordView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var userService: UserService
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var errorMessage = ""
    @State var password = ""
    @Binding var msg: String
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 25) {
                
                Text("Change Password")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                
                CustomTextField(placeHolderText: "Password",
                                text: self.$password,
                                isPasswordType: true)
                    
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
        auth.updatePassword(password: self.password) { message in
            self.errorMessage = message
            if message == "" {
                msg = "Password Updated!"
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        
    }
    
}
