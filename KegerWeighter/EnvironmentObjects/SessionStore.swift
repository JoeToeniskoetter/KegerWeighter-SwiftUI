//
//  SessionStore.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import Foundation
import Firebase
import SwiftUI
import Combine
import Resolver

class SessionStore: ObservableObject{
    @Published var user: User?
    @Injected var firestore: Firestore
    @Injected var auth: Auth
    @Injected var functions: Functions
    private var handle: AuthStateDidChangeListenerHandle?
    @Published var error:String = ""
    
    init(){
        print("Creating new instance")
        self.handle = auth.addStateDidChangeListener{ (auth, user) in
            if let user = user{
                print("USER SIGNED IN")
                self.user = user
            } else {
                self.user = nil
            }
        }
    }
    
    func signOut() {
        self.removeFCMToken()
      do {
        try auth.signOut()
      }
      catch {
        print("Error when trying to sign out: \(error.localizedDescription)")
      }
    }
    
    public func signInWithEmail(email:String, password:String){
        auth.signIn(withEmail: email, password: password) {authDataResult, error in
            if let error = error{
                print("ERROR: ", error)
                self.error = error.localizedDescription
            }
        }
    }
    
    func removeFCMToken(){
        let userId = auth.currentUser?.uid
        let token = Messaging.messaging().fcmToken
        
        if token == nil{
            print("No token available")
            return
        }
        
        if userId == nil {
            print("no user id for fcm token")
            return
        }
        
        firestore.collection("users")
            .document(userId!)
            .updateData(["fcmToken" : FieldValue.arrayRemove([token ?? ""])])
        
    }
    
    deinit {
        if let handle = handle{
            auth.removeStateDidChangeListener(handle)
        }
    }
    
}
