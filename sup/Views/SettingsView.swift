//
//  SettingsView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var userService: UserService
    @State private var didReAuth = false
    @State var getPasswordSheet = false
    @State var updateEmailSheet = false
    @State var updatePasswordSheet = false
    @State var errorMessage = ""
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 25) {
            
            CustomButton(title: "Reset Password",
                         font: UIConfiguration.buttonFont,
                         color: UIConfiguration.buttonColor,
                         textColor: .white,
                         width: 275,
                         height: 45,
                         action: self.resetPassword )
            
            CustomButton(title: "Change Email",
                         font: UIConfiguration.buttonFont,
                         color: UIConfiguration.buttonColor,
                         textColor: .white,
                         width: 275,
                         height: 45,
                         action: self.changeEmail )
            
            CustomButton(title: "Delete Account",
                         font: UIConfiguration.buttonFont,
                         color: UIConfiguration.buttonColor,
                         textColor: .white,
                         width: 275,
                         height: 45,
                         action: self.deleteAccount )
            
            Text(errorMessage)
                .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                    color: UIConfiguration.tintColor))
            
            
        }.navigationBarTitle("Settings", displayMode: .inline)
        .padding(.horizontal, 25)
        .sheet(isPresented: self.$getPasswordSheet) {
            ReAuthView(reAuth: self.$didReAuth)
        }
        .sheet(isPresented: self.$updateEmailSheet) {
            UpdateEmailView(msg: self.$errorMessage)
        }
        .sheet(isPresented: self.$updatePasswordSheet) {
            UpdatePasswordView(msg: self.$errorMessage)
        }
        .onAppear {
            self.getPasswordSheet.toggle()
        }
    }
    
    func resetPassword() {
        if (!self.didReAuth) {
            self.getPasswordSheet.toggle()
        } else {
            self.updatePasswordSheet.toggle()
        }
        
    }
    
    func deleteAccount() {
        if (!self.didReAuth) {
            self.getPasswordSheet.toggle()
        } else {
            auth.deleteAccount()
        }
        
    }
    
    func changeEmail() {
        if (!self.didReAuth) {
            self.getPasswordSheet.toggle()
        } else {
            self.updateEmailSheet.toggle()
        }
            
        
    }
}
