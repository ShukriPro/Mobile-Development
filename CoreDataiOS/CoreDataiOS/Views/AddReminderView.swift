//
//  AddReminderView.swift
//  CoreDataiOS
//
//  Created by Shukri on 19/09/24.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel: ReminderViewModel
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var date = Date()
    @State private var reminderType: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reminder Details")) {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Type", text: $reminderType)
                }
                
                Section {
                    Button("Save") {
                        viewModel.saveReminder(title: title, notes: notes, date: date, reminderType: reminderType, context: context)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)  // Disable save button if title is empty
                }
            }
            .navigationTitle("Add Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
