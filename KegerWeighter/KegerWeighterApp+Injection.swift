//
//  KegerWeighterApp+Injection.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/15/21.
//

import Foundation
import Resolver
import FirebaseFunctions
import FirebaseFirestore
import FirebaseMessaging

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .application
        // register Firebase services
        register { Functions.functions() }
        register { Firestore.firestore() }
        register { Messaging.messaging() }
        
        // register application components
        register { SessionStore() }
        register { FirestoreKegRepository() }
        register { FirestoreUserRepository() }
        
    }
}
