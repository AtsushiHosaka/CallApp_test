//
//  CallView.swift
//  CallApp_test
//
//  Created by 保坂篤志 on 2024/06/26.
//

import SwiftUI

struct CallView: View {
    @EnvironmentObject private var callManager: CallManager
    @State private var channelName = ""
    
    var body: some View {
        VStack {
            if callManager.isInCall {
                Text("In call")
                Button("Leave Call") {
                    callManager.leaveChannel()
                }
            } else {
                TextField("Enter channel name", text: $channelName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Join Call") {
                    guard !channelName.isEmpty else { return }
                    callManager.joinChannel(channelName: channelName)
                }
            }
        }
        .padding()
    }
}
