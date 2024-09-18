//
//  ReminderViewModel.swift
//  CoreDataiOS
//
//  Created by Shukri on 19/09/24.
//

import SwiftUI
import CoreData

class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var filteredReminders: [Reminder] = []
    @Published var currentFilter: ReminderFilter = .all
    
    // MARK: - CRUD Operations
       
       func saveReminder(title: String, notes: String?, date: Date, reminderType: String, context: NSManagedObjectContext) {
           let newReminder = Reminder(context: context)
           newReminder.id = UUID()
           newReminder.title = title
           newReminder.notes = notes
           newReminder.date = date
           newReminder.isCompleted = false
           newReminder.reminderType = reminderType
           
           do {
               try context.save()
               fetchReminders(context: context)
           } catch {
               print("Failed to save reminder: \(error.localizedDescription)")
           }
       }
       
       func fetchReminders(context: NSManagedObjectContext) {
           let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
           fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.date, ascending: true)]
           
           do {
               reminders = try context.fetch(fetchRequest)
               applyFilter() // Apply the filter right after fetching
           } catch {
               print("Failed to fetch reminders: \(error.localizedDescription)")
           }
       }
       
       func toggleReminderCompletion(reminder: Reminder, context: NSManagedObjectContext) {
           reminder.isCompleted.toggle()
           
           do {
               try context.save()
               fetchReminders(context: context)
           } catch {
               print("Failed to toggle reminder completion: \(error.localizedDescription)")
           }
       }
       
       func deleteReminder(reminder: Reminder, context: NSManagedObjectContext) {
           context.delete(reminder)
           
           do {
               try context.save()
               fetchReminders(context: context)
           } catch {
               print("Failed to delete reminder: \(error.localizedDescription)")
           }
       }
       
       // MARK: - Filtering
       
       func setFilter(_ filter: ReminderFilter) {
           currentFilter = filter
           applyFilter()
       }
       
       private func applyFilter() {
           switch currentFilter {
           case .all:
               filteredReminders = reminders
           case .active:
               filteredReminders = reminders.filter { !$0.isCompleted }
           case .completed:
               filteredReminders = reminders.filter { $0.isCompleted }
           }
       }
       
       // MARK: - Utility Functions
       
       func remindersByDate() -> [Date: [Reminder]] {
           let groupedReminders = Dictionary(grouping: filteredReminders) { reminder in
               Calendar.current.startOfDay(for: reminder.date ?? Date())
           }
           return groupedReminders
       }
       
       func formattedDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           return formatter.string(from: date)
       }
}

enum ReminderFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}
