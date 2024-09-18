//
//  CoreDataiOSApp.swift
//  CoreDataiOS
//
//  Created by Shukri on 18/09/24.
//

import SwiftUI

@main
struct CoreDataiOSApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
