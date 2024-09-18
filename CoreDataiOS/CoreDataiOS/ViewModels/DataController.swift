//
//  DataController.swift
//  CoreDataiOS
//
//  Created by Shukri on 18/09/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MyDatabase")  // Ensure this matches your Core Data model file's name
        
        container.loadPersistentStores { description, error in
            if let error = error {
                // If loading fails, print the error message
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                // Loading was successful
                print("Core Data loaded successfully!")
            }
        }
    }
}


