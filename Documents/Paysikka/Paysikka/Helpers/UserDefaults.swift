//
//  UserDefaults.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation

public struct Standards {
    static let preferences = UserDefaults.standard
    struct Key {
        static let baseURL = "baseURL"
        static let isLoggedIn = "isLoggedIn"
        static let userName = "userName"
        static let password = "password"
    }
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            Standards.preferences.removePersistentDomain(forName: bundleID)
        }
    }
}
