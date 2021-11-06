//
//  ReAuthView.swift
//  sup
//
//  Created by Travis on 9/23/21.
//

import SwiftUI

struct ReAuthView: View {
    @ObservedObject private var viewModel: ReAuthViewModel
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var userService: UserService
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var errorMessage = ""
    @Binding var isAuth: Bool
    
    init(reAuth: Binding<Bool>) {
        self.viewModel = ReAuthViewModel()
        self._isAuth = reAuth
    }
    
    
    var body: some View {
            
            VStack(alignment: .center, spacing: 25) {
                
                Text("Verify Password")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                
                CustomTextField(placeHolderText: "Password",
                                text: $viewModel.password,
                                isPasswordType: true)
                    
                
                
                CustomButton(title: "Submit",
                             font: UIConfiguration.buttonFont,
                             color: UIConfiguration.buttonColor,
                             textColor: .white,
                             width: 275,
                             height: 45,
                             action: self.reAuth )
                
                Text(errorMessage)
                    .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                        color: UIConfiguration.tintColor))
                
            }.padding(.horizontal, 25)
    }
    
    func reAuth() {
        self.viewModel.reAuth(auth: auth, email: userService.user!.email!, password: self.viewModel.password) { message in
            self.errorMessage = message

            if message == "" {
                self.isAuth = true
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
        
    }
    
}
