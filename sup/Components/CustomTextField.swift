//
//  CustomTextField.swift
//  KeepFit
//
//  Created by Nicolas Basile, John Kang, Alex Kim, Travis Day, Bryan Ho, Snehal Mulchandani on 2/11/21.
//  Copyright © 2021 CSCI-310 Team 26. All rights reserved.
//
//
import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    private let isPasswordType: Bool
    private let placeHolderText: String
    
    init(placeHolderText: String, text: Binding<String>, isPasswordType: Bool = false) {
        _text = text
        self.isPasswordType = isPasswordType
        self.placeHolderText = placeHolderText
    }
    
    var body: some View {
        VStack {
            if isPasswordType {
                SecureField(placeHolderText, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
                
            } else {
                TextField(placeHolderText, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
            }
        }
    }
}
