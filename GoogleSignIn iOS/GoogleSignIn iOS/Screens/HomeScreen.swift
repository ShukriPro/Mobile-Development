import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct HomeScreen: View {
    @Binding var isSignedIn: Bool
    @State private var userEmail: String = ""
    @State private var profilePictureURL: URL?
    @State private var userName: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 20) {
                        // Profile Picture
                        profileImage
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // User Name
                            Text(userName)
                                .font(.headline)
                            
                            // User Email
                            Text(userEmail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Edit Profile")) {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }
                    
                    NavigationLink(destination: Text("Settings")) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(action: signOut) {
                        Label("Sign Out", systemImage: "arrow.right.circle")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
        }
        .onAppear {
            fetchUserData()
        }
    }
    
    private var profileImage: some View {
        Group {
            if let profilePictureURL = profilePictureURL {
                AsyncImage(url: profilePictureURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func fetchUserData() {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email ?? "No email available"
            self.profilePictureURL = user.photoURL
            self.userName = user.displayName ?? "User"
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
