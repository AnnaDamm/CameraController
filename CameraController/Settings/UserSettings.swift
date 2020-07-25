//
//  UserSettings.swift
//  CameraController
//
//  Created by Itay Brenner on 7/25/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation
import Combine
import ServiceManagement

class UserSettings: ObservableObject {
    static let shared = UserSettings()

    @Published var openAtLogin: Bool {
        didSet {
            let success = SMLoginItemSetEnabled("com.itaysoft.CameraController.Helper" as CFString, openAtLogin)
            if success {
                UserDefaults.standard.set(openAtLogin, forKey: "login")
            }
        }
    }

    @Published var readRate: RefreshSettingsRate {
        didSet {
            UserDefaults.standard.set(readRate, forKey: "readRate")
        }
    }

    @Published var writeRate: RefreshSettingsRate {
        didSet {
            UserDefaults.standard.set(writeRate, forKey: "writeRate")
        }
    }

    private init() {
        openAtLogin = UserDefaults.standard.bool(forKey: "login")
        readRate = RefreshSettingsRate(rawValue: UserDefaults.standard.integer(forKey: "readRate")) ?? .disabled
        writeRate = RefreshSettingsRate(rawValue: UserDefaults.standard.integer(forKey: "writeRate")) ?? .disabled
    }
}
