//
//  AppConfig.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 14/7/25.
//

import Foundation

struct AppConfig {
    static var isDebugModeEnabled: Bool {
        get {
            #if DEBUG
            let userDefaultsValue = UserDefaults.standard.bool(forKey: "debug_mode")
            return userDefaultsValue
            #endif
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "debug_mode")
        }
    }
}
