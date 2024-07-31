//
//  ContentView.swift
//  CallApp_test
//
//  Created by 保坂篤志 on 2024/06/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var callManager = CallManager()
    
    var body: some View {
        NavigationView {
            CallView()
                .environmentObject(callManager)
        }
    }
}


#Preview {
    ContentView()
}
