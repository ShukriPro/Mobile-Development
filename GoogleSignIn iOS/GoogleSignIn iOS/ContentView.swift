//
//  ContentView.swift
//  GoogleSignIn iOS
//
//  Created by Shukri on 26/09/24.
//
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct ContentView: View {
    @State private var isSignedIn = Auth.auth().currentUser != nil // Initialize with Firebase auth state

    var body: some View {
        VStack {
            if isSignedIn {
                HomeScreen(isSignedIn: $isSignedIn) // Show HomeScreen when signed in
            } else {
                LoginScreen(isSignedIn: $isSignedIn) // Show LoginScreen when not signed in
            }
        }
        .onAppear {
            // Set the sign-in state when the view appears
            isSignedIn = Auth.auth().currentUser != nil
        }
    }
}
