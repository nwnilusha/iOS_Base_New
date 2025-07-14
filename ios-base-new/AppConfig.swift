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
            return UserDefaults.standard.bool(forKey: "debug_mode") || true
            #else
            return UserDefaults.standard.bool(forKey: "debug_mode")
            #endif
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "debug_mode")
        }
    }
}
