//
//  AuthViewModel.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import Resolver


class AuthViewModel: ObservableObject {
    @Injected var userRepository: FirestoreUserRepository
    @Published var email:String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var authError: Bool = false
    @Published var loading: Bool = false

    
    private var signInWithAppleService:SignInWithAppleCoordinator = SignInWithAppleCoordinator()
    
    func signOut(){
        self.userRepository.removeFCMToken()
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func signInWithEmail(){
        self.loading = true
        Auth.auth().signIn(withEmail: self.email, password: self.password) { authDataResult, error in
            if let error = error {
                print("ERROR: ", error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.authError = true
                self.loading = false
                return
            }
            self.loading = false
        }
    }
    
    func signUpWithEmail(){
        self.loading = true
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authDataResult, error in
            if let error = error {
                print("ERROR: ", error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.authError = true
                return
            }
            self.loading = false
        }
    }
    
    func dismiessError(){
        self.authError = false
        self.errorMessage = ""
    }
    
    func resetPasswordEmail(email:String, completion: @escaping (_ success: Bool) -> Void){
        self.loading = true
        Auth.auth().sendPasswordReset(withEmail: email, completion:{err in
            self.loading = false
            completion(false)
        })
    }
    
    
    func handleGoogleSignIn(){
        self.loading = true
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { [unowned self] user, error in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            self.loading = false
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error{
                    self.errorMessage = error.localizedDescription
                }
                
            }
        }
    }
    
    func handleAppleSignIn(){
        self.signInWithAppleService.startSignInWithAppleFlow()
    }
    
    func removeFCMToken(completion: (_ success: Bool) -> Void){
        let userId = Auth.auth().currentUser?.uid
        let token = Messaging.messaging().fcmToken
        
        if token == nil{
            print("No token available")
            completion(true)
            return
        }
        
        if userId == nil {
            print("no user id for fcm token")
            completion(true)
            return
        }
        
        Firestore.firestore().collection("users")
            .document(userId!)
            .updateData(["fcmToken" : FieldValue.arrayRemove([token ?? ""])])
        
        completion(true)
        
    }
}
