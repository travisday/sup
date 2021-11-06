//
//  CustomButton.swift
//  KeepFit
//
//  Created by Nico Basile on 2/22/21.
//  Copyright © 2021 CSCI-310 Team 26. All rights reserved.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var font: UIFont
    var color: UIColor
    var textColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var action: () -> Void
    
    init(title: String, font: UIFont, color: UIColor, textColor: UIColor, width: CGFloat, height: CGFloat, action: @escaping () -> Void) {
        self.title = title
        self.font = font
        self.color = color
        self.textColor = textColor
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: font,
                                         color: color,
                                         textColor: textColor,
                                         width: width,
                                         height: height))
        }
    }
}
