//
//  FirestoreKegRepository.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/15/21.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver

class BaseTaskRepository {
    @Published var kegs = [KegViewModel]()
}

protocol KegRepository: BaseTaskRepository {
    func addKeg(kvm: AddKegViewModel, completion: @escaping (_ success: Bool) -> Void)
    func removeKeg(_ keg: Keg)
    func updateKeg(keg:Keg, id: String, completion: @escaping (_ success: Bool) -> Void)
}



class FirestoreKegRepository: BaseTaskRepository, KegRepository, ObservableObject {


    @Injected var db: Firestore
    @Injected var functions: Functions
    @Published var authenticationService: SessionStore = Resolver.resolve()
    @Published var loading:Bool = false

    var kegsPath: String = "kegs"
    var userId: String = "unknown"

    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
    }


    func addKeg(kvm: AddKegViewModel, completion: @escaping (_ success: Bool) -> Void){
        self.functions.httpsCallable("addKeg").call([
            "id": kvm.kegerWeighterId,
            "kegSize": kvm.kegSize.rawValue,
            "beerType": kvm.beerType,
            "location": kvm.location,
            "firstNotificationPerc": Int(kvm.firstNotification) ?? 0,
            "secondNotificationPerc": Int(kvm.secondNotification) ?? 0,
            "subscribed": kvm.notificationsEnabled
        ]) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(code, message, details)
                }
                completion(false)
            }

            if let data = result?.data {
                print(data)
                completion(true)
            }
        }
    }



    func removeKeg(_ keg: Keg) {
        if let kegId = keg.id {
            db.collection(kegsPath).document(kegId).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateKeg(keg:Keg, id: String, completion: @escaping (_ success: Bool) -> Void){
        self.loading = true
        self.db.collection(kegsPath)
            .document(id)
            .updateData([
                "beerType" : keg.beerType,
                "location" : keg.location,
                "kegSize": keg.kegSize.rawValue,
                "firstNotificationPerc": keg.firstNotificationPerc,
                "secondNotificationPerc": keg.secondNotificationPerc,
                "subscribed": keg.subscribed,
            ]){ error in
                if let error = error {
                    print("Error updating document: \(error)")
                    self.loading = false
                    completion(false)
                } else {
                    print("Document successfully updated!")
                    self.loading = false
                    completion(true)
                }
            }

    }
    
    func resetKeg(keg: Keg, clearData:Bool, completion: @escaping (_ success: Bool) -> Void){
        self.loading = true
        self.functions.httpsCallable("resetKeg").call([
            "id": keg.id,
            "clearData": clearData
        ]) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(code, message, details)
                }
                self.loading = false
                completion(false)
            }

            if let data = result?.data {
                print(data)
                self.loading = false
                completion(true)
            }
        }
    }

}
