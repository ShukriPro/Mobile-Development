import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct LoginScreen: View {
    @Binding var isSignedIn: Bool
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // App Logo
                Image(systemName: "lock.shield")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Welcome")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Sign In Button
                Button(action: signInWithGoogle) {
                    HStack {
                        Image("google_logo") // Ensure you have Google's logo in the assets
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                .disabled(isLoading)
                .padding(.horizontal, 50)
                
                Spacer()
                
                // Sign Up Navigation Link
                NavigationLink(destination:  SignupView(viewModel: AuthenticationViewModel())) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .padding(.top, 15)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .overlay(
                Group {
                    if isLoading {
                        Color(.systemBackground).opacity(0.8).edgesIgnoringSafeArea(.all)
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
            )
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Error during Google Sign-In: \(error.localizedDescription)")
                isLoading = false
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                isLoading = false
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                isLoading = false
                if error == nil {
                    isSignedIn = true
                } else {
                    print("Firebase sign-in failed: \(error?.localizedDescription ?? "No error")")
                }
            }
        }
    }
}
