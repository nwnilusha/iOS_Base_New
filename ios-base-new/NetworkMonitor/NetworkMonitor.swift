//
//  NetworkMonitor.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 8/7/25.
//

import Network
import Combine

final class NetworkMonitor: NetworkMonitoring, ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
