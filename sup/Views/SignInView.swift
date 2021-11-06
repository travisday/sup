//
//  SignInView.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject private var viewModel: SignInViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage = ""
    @State var loading = false
    @State var error = false
    
    @EnvironmentObject var auth: AuthService
    
    init() {
        self.viewModel = SignInViewModel()
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 30) {
            Text("Log In")
                .modifier(TextModifier(font: UIConfiguration.titleFont,
                                       color: UIConfiguration.tintColor))
                .padding(.leading, 25)
            
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .center, spacing: 25) {
                    CustomTextField(placeHolderText: "E-mail",
                                    text: $viewModel.email)
                    CustomTextField(placeHolderText: "Password",
                                    text: $viewModel.password,
                                    isPasswordType: true)
                }
                .padding(.horizontal, 25)

                VStack(alignment: .center, spacing: 20) {
                    CustomButton(title: "Log In",
                                 font: UIConfiguration.buttonFont,
                                 color: UIConfiguration.tintColor,
                                 textColor: .white,
                                 width: 275,
                                 height: 55,
                                 action: self.login)
                    
                    CustomButton(title: "Forgot password?",
                                 font: UIConfiguration.subtitleFont,
                                 color: UIConfiguration.subtitleColor,
                                 textColor: .white,
                                 width: 200,
                                 height: 35,
                                 action: self.resetPassword)

                    Text(errorMessage)
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                }
            }
        }
        Spacer()
    }
    
    private func login() {
        self.viewModel.login(auth: self.auth) { message in
            self.errorMessage = message
        }
    }

    private func resetPassword() {
        self.viewModel.resetPassword(auth: self.auth) { message in
            self.errorMessage = message
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
