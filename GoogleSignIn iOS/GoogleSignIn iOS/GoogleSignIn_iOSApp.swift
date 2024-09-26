//
//  GoogleSignIn_iOSApp.swift
//  GoogleSignIn iOS
//
//  Created by Shukri on 26/09/24.
//

import SwiftUI
import Firebase

@main
struct GoogleSignIn_iOSApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
