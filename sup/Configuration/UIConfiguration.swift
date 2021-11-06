//
//  UIConfiguration.swift
//  KeepFit
//
//  Created by Nicolas Basile, John Kang, Alex Kim, Travis Day, Bryan Ho, Snehal Mulchandani on 2/11/21.
//  Copyright © 2021 CSCI-310 Team 26. All rights reserved.
//

import SwiftUI
import UIKit

// We can use this file to create "presets" for styling,
// Meaning we don't have to copy/paste the same color a bunch of times,
// we can instead make that specific style a variable

class UIConfiguration {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    // Fonts
    static let titleFont = UIFont(name: "Avenir-Heavy", size: 32)!
    static let subtitleFont = UIFont(name: "Avenir-Heavy", size: 20)!
    static let buttonFont = UIFont(name: "Avenir-Heavy", size: 20)!
    static let tabFont = UIFont(name: "Avenir-Heavy", size: 18)!

    static let backgroundColor: UIColor = .white
    static let tintColor = UIColor(hexString: "#fece2f")
    static let subtitleColor = UIColor(hexString: "#464646")
    static let buttonColor = UIColor(hexString: "#fece2f")
    static let buttonBorderColor = UIColor(hexString: "#B0B3C6")
    static let noTint = UIColor(hexString: "#4D4D4D")
}
