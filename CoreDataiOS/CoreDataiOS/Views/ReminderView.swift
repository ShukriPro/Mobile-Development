import SwiftUI


struct ReminderView: View {
    @StateObject private var viewModel = ReminderViewModel()
    @Environment(\.managedObjectContext) private var context
    @State private var showingAddReminder = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.remindersByDate().keys.sorted(), id: \.self) { date in
                    Section(header: Text(viewModel.formattedDate(date))) {
                        ForEach(viewModel.remindersByDate()[date] ?? []) { reminder in
                            ReminderRowView(reminder: reminder, viewModel: viewModel)
                        }
                    }
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReminder = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Filter", selection: $viewModel.currentFilter) {
                        ForEach(ReminderFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.currentFilter) { newFilter in
                        viewModel.setFilter(newFilter)
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchReminders(context: context)
        }
    }
}


struct ReminderRowView: View {
    let reminder: Reminder
    @ObservedObject var viewModel: ReminderViewModel
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.title ?? "No Title")
                    .font(.headline)
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Button(action: {
                viewModel.toggleReminderCompletion(reminder: reminder, context: context)
            }) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteReminder(reminder: reminder, context: context)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
