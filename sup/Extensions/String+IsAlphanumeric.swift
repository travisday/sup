//
//  String+IsAlphanumeric.swift
//  sup
//
//  Created by Travis on 9/16/21.
//

import Foundation

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
