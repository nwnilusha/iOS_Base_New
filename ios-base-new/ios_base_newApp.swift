//
//  ios_base_newApp.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import SwiftUI
import SwiftData

@main
struct ios_base_newApp: App {
    
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                HomeView()
                    .navigationDestination(for: Routes.self) { route in
                        appCoordinator.buildDestination(for: route)
                    }
            }
            .environmentObject(appCoordinator)
            .modelContainer(for: [ReportModel.self])
            
        }
        
        
    }
}
