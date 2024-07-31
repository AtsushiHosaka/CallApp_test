//
//  CallApp_testApp.swift
//  CallApp_test
//
//  Created by 保坂篤志 on 2024/06/26.
//

import SwiftUI
import AgoraRtcKit

@main
struct CallingApp: App {
    init() {
        let config = AgoraRtcEngineConfig()
        config.appId = "e7ce13b9864c4178a8020dd8e90e9d0d"
        _ = AgoraRtcEngineKit.sharedEngine(with: config, delegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

