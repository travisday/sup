//
//  SignUpView.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: AuthService
    
    init() {
        self.viewModel = SignUpViewModel()
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("Sign Up")
                    .padding(.leading, 25)
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: "User Name",
                                      text: $viewModel.username)
                        CustomTextField(placeHolderText: "E-mail Address",
                                      text: $viewModel.email)
                        CustomTextField(placeHolderText: "Password",
                                      text: $viewModel.password,
                                      isPasswordType: true)
                    }
                    .padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        CustomButton(title: "Create Account",
                                     font: UIConfiguration.buttonFont,
                                     color: UIConfiguration.buttonColor,
                                     textColor: .white,
                                     width: 275,
                                     height: 45,
                                     action: self.signUp)
                    }
                    Text(errorMessage)
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                            color: UIConfiguration.tintColor))
                }
            }
            Spacer()
        }
    }
    
    private func signUp() {
        // Bug fix: Creating user without username
        if(self.viewModel.username == "") {
            self.errorMessage = "Username cannot be empty"
            return
        }
        self.viewModel.signUp(auth:self.auth) { message in
            self.errorMessage = message
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
