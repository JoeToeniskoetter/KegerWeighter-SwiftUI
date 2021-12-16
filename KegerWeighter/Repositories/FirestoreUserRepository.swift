//
//  FirestoreUserRepository.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/15/21.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

import Combine
import Resolver


protocol UserRepository {
    func updateFCMToken()
}



class FirestoreUserRepository: UserRepository, ObservableObject {
    
    
    @Injected var db: Firestore
    @Published private var authenticationService: SessionStore = Resolver.resolve()
    @Published var user: FirebaseUser?
    
    var userPath: String = "users"
    var userId: String = "unknown"

    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
            print("Initializing user repo")
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                
                if user != nil {
                    self?.fetchUserInfo()
                }
            }
            .store(in: &cancellables)
        
        $user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                if user != nil{
                    self?.updateFCMToken()
                }
            }.store(in: &cancellables)
        
    }
    
    func fetchUserInfo(){
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        listenerRegistration = db.collection(userPath)
            .document(self.userId)
            .addSnapshotListener { (querySnapshot, error) in
                
                guard let querySnapshot = querySnapshot else {
                    print("Error fetching snapshot: \(error!)")
                    return
                }
                guard let data = querySnapshot.data() else {
                    print("Document data was empty.")
                    return
                }
                do{
                    print(data)
                    self.user = try querySnapshot.data(as: FirebaseUser.self)
                }catch{
                    print(error.localizedDescription)
                }
            }
    }
    
    
    func updateFCMToken(){
        print("Updating users token")
        let token = Messaging.messaging().fcmToken
        self.db.collection(userPath)
            .document(userId)
            .updateData(["fcmToken" : FieldValue.arrayUnion([token ?? ""])]){ error in
                if let error = error {
                    print("Error updating document: \(error)")
                    //                completion(false)
                } else {
                    print("Document successfully updated!")
                    //                completion(true)
                }
            }
        
    }
    
    func removeFCMToken(){
        print("Removing users token")
        let token = Messaging.messaging().fcmToken
        self.db.collection(userPath)
            .document(userId)
            .updateData(["fcmToken" : FieldValue.arrayRemove([token ?? ""])]){ error in
                if let error = error {
                    print("Error updating document: \(error)")
                    //                completion(false)
                } else {
                    print("Document successfully updated!")
                    //                completion(true)
                }
            }
        
    }
}
