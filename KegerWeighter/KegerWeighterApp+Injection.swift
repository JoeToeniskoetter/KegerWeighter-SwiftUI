//
//  KegerWeighterApp+Injection.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/15/21.
//

import Foundation
import Resolver
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore
import FirebaseMessaging

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .application
        // register Firebase services
        register { Auth.auth() }
        register { Functions.functions() }
        register { Firestore.firestore() }
        register { Messaging.messaging() }
        
        // register application components
        register { SessionStore() }
        register { FirestoreKegRepository() }
        register { FirestoreUserRepository() }
        
    }
    
}

extension Auth {
    func emulate()-> Auth{
        print("Running emulate")
#if DEBUG
        print("Using the Firebase Auth Emulator running on port 9099")
        self.useEmulator(withHost:"localhost", port:9099)
#endif
        return self
    }
}

extension Functions {
  func emulate() -> Functions {
#if DEBUG
    print("Using the Firebase Emulator for Cloud Functions, running on port 5001")
//    self.useFunctionsEmulator(origin: "https://localhost:5001")
      self.useFunctionsEmulator(origin: "http://localhost:5001")
#endif
    return self
  }
}

extension Firestore {
  func useEmulator() -> Firestore {
    #if DEBUG
    print("Using the Firebase Emulator for Cloud Firestore, running on port 8080")
    let settings = self.settings
    settings.host = "localhost:8080"
    settings.isPersistenceEnabled = false
    settings.isSSLEnabled = false
    self.settings = settings
    #else
    print("Using Cloud Firestore in production")
    #endif
    return self
  }
}
