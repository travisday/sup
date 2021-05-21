//
//  SwiftUIView.swift
//  sup
//
//  Created by Travis on 5/19/21.
//

import SwiftUI

struct AuthView: View {
    @State private var action: Int? = 0
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 40) {
                Image("sup_icon")
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding(.top, 100)
                
                Text("SUP!")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                
                VStack(spacing: 25) {
                    NavigationLink(destination: SignUpView(), tag: 1, selection: $action) { EmptyView() }
                    CustomButton(title: "Create Account",
                                 font: UIConfiguration.buttonFont,
                                 color: UIConfiguration.buttonColor,
                                 textColor: .white,
                                 width: 275,
                                 height: 45,
                                 action: {self.action = 1})
                    NavigationLink(destination: SignInView(), tag: 2, selection: $action) { EmptyView() }
                    CustomButton(title: "Log In",
                                 font: UIConfiguration.buttonFont,
                                 color: UIConfiguration.buttonColor,
                                 textColor: .white,
                                 width: 275,
                                 height: 45,
                                 action: {self.action = 2})

                }
            }
            Spacer()
        }.accentColor(Color(UIConfiguration.subtitleColor))

    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
