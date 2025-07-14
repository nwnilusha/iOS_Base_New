//
//  NetworkMonitorView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 8/7/25.
//

import Foundation
import SwiftUICore
import SwiftUI

struct NetworkAlertModifier: ViewModifier {
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var lastConnectionStatus: Bool = true

    func body(content: Content) -> some View {
        content
            .onChange(of: networkMonitor.isConnected) { _, newValue in
                if newValue != lastConnectionStatus {
                    lastConnectionStatus = newValue
                    alertTitle = newValue ? "Internet Connection Restored" : "No Internet Connection"
                    alertMessage = newValue ? "You're back online." : "Please check your internet connection."
                    showAlert = true
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
    }
}

extension View {
    func networkAlert() -> some View {
        self.modifier(NetworkAlertModifier())
    }
}
