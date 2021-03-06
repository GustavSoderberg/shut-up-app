/**
 
 - Description:
 The WelcomeView.swift is a view that displays the FirebaseUI for user-login as well as registering a username for new users. Also provides checks that either saves the user to firestore/coredata (whichever one is needed)
 
 - Authors:
 Andreas J
 Gustav S
 Calle H
 
 */

import SwiftUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI

var showLoginViewGlobal : Bool = true

struct WelcomeView: View {
    
    @AppStorage("firstTime") var firstTime = true
    
    @Binding var showWelcomeView : Bool
    @State var showLoginView = showLoginViewGlobal
    @State var refresh = 1
    @State var username = ""
    @State var isRegistered : Bool = true
    
    var body: some View {
        
        VStack {
            
            if refresh > 0 {
                
                if let currentUser = Auth.auth().currentUser {
                    
                    if let photoUrl = currentUser.photoURL {
                        
                        AsyncImage(url: photoUrl) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                        } placeholder: {
                            ProgressView()
                        }
                        
                    }
                    
                    Text("Welcome! \n What should we call you?")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    TextField(
                        "Username",
                        text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(Color.black)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .frame(width: 250.0)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .bottom, .trailing])
                    .padding(.horizontal, 45.0)
                    
                    Button {
                        
                        if !username.isEmpty {
                            
                            um.register(username: username, uid: currentUser.uid, photoUrl: currentUser.photoURL!.absoluteString)
                            showWelcomeView = false
                            
                        }
                        
                    } label: {
                        Text("Continue")
                    }
                    
                }
                
                
            }
        }
        .sheet(isPresented: $showLoginView, onDismiss: {
            
            if firstTime && !um.loginCheck(uid: Auth.auth().currentUser?.uid ?? "", firstTime: true){
                firstTime = false
                showWelcomeView = false
            }
            else {
                showWelcomeView = um.loginCheck(uid: Auth.auth().currentUser?.uid ?? "", firstTime: false)
                refresh += 1
            }
            
            
        }) {
            
            LoginView(showLoginView: $showLoginView)
            
        }
        
    }
    
}

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

/**
 
 - Description:
 The LoginView is provided by FirebaseAuthUI that displays a User Interface which the user can login on a service of their choice.
 The code was originally written for storyboard but has been translated by us to work with SwiftUI
 
 - Authors:
 Andreas J
 Gustav S
 Calle H
 
 */

struct LoginView : View {
    
    @Binding var showLoginView : Bool
    @State private var viewState = CGSize(width: 0, height: screenHeight)
    @State private var MainviewState = CGSize.zero
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body : some View {
        ZStack {
            CustomLoginViewController(delegate: authViewModel) { (error) in
                if error == nil {
                    self.status()
                }
            }
        }
    }
    
    func status() {
        self.viewState = CGSize(width: 0, height: 0)
        self.MainviewState = CGSize(width: 0, height: screenHeight)
    }
}

struct CustomLoginViewController : UIViewControllerRepresentable {
    var delegate: FUIAuthDelegate?
    
    var dismiss : (_ error : Error? ) -> Void
    
    func makeCoordinator() -> CustomLoginViewController.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        let authUI = FUIAuth.defaultAuthUI()!
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://example.appspot.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")
        
        let twitterAuthProvider = FUIOAuth.twitterAuthProvider()
        let facebookAuthProvider = FUIFacebookAuth(authUI: authUI)
        let githubAuthProvider = FUIOAuth.githubAuthProvider(withAuthUI: authUI)
        let googleAuthProvider = FUIGoogleAuth(authUI: authUI)
        
        let authProviders: [FUIAuthProvider] = [
            twitterAuthProvider,
            facebookAuthProvider,
            googleAuthProvider,
            githubAuthProvider,
        ]
        
        authUI.providers = authProviders
        authUI.delegate = self.delegate
        
        let authViewController = authUI.authViewController()
        
        return authViewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomLoginViewController>)
    {
        
    }
    
    class Coordinator: NSObject {
        var parent: CustomLoginViewController
        
        init(_ customLoginViewController : CustomLoginViewController) {
            self.parent = customLoginViewController
        }
        
    }
}

class AuthViewModel: NSObject, ObservableObject, FUIAuthDelegate {
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        
        if let error = error {
            print("\(error) \n Failed to sign in")
        }
        else {
            
            showLoginViewGlobal = false
            
        }
    }
}
