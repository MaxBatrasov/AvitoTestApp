//
//  NetworkMonitor.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 19.10.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: connectionType = .unkown
    
    enum connectionType {
        case wifi
        case cellular
        case ethernet
        case unkown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .unsatisfied:
                self?.isConnected = false
            case .satisfied:
                self?.isConnected = true
            case .requiresConnection:
                self?.isConnected = false
            default:
                self?.isConnected = false
            }
            self?.getConnectionType(path)
            if self?.isConnected == false {
                NotificationCenter.default.post(name: .internetDown, object: nil, userInfo: nil)
            } else {
                NotificationCenter.default.post(name: .internetIsBack, object: nil, userInfo: nil)
            }
            print (self?.isConnected ?? "N/A")
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            self.connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            self.connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            self.connectionType = .ethernet
        } else {
            self.connectionType = .unkown
        }
    }
}
