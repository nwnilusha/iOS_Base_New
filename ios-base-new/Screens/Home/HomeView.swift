//
//  HomeView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 30/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    let geidColumns: [GridItem] = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                #if DEBUG
                .onLongPressGesture(minimumDuration: 2.0) {
                    DebugLogger.shared.log("Long press triggered: Navigating to Debugger")
                    coordinator.push(.Debugger)
                }
                #endif
            Spacer()
            LazyVGrid(columns: geidColumns) {
                Button {
                    DebugLogger.shared.log("Navigating to Popular Movies View")
                    coordinator.push(.populerMoviesView)
                } label: {
                    ItemView(informationText: "Popular Movies", imageName: "film")
                }
                
                Button {
                    DebugLogger.shared.log("Navigating to Users View")
                    coordinator.push(.users)
                } label: {
                    ItemView(informationText: "User-Posts", imageName: "person")
                }
                
                Button {
                    DebugLogger.shared.log("Navigating to Projects View")
                    coordinator.push(.projects)
                } label: {
                    ItemView(informationText: "Projects", imageName: "homekit")
                }
                
                Button {
                    DebugLogger.shared.log("Coming Soon button tapped")
                } label: {
                    ItemView(informationText: "Coming Soon", imageName: "star")
                }
            }
            .padding()
            Spacer()
        }
        .networkAlert()
    }
}


struct ItemView: View {
    let informationText: String
    let imageName: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundColor(.blue)
            
            Text(informationText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 220)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

//#Preview {
//    HomeView()
//}
