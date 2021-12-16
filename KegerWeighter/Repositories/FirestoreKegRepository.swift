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
    @Published var authenticationService: SessionStore = Resolver.resolve()
    @LazyInjected var functions: Functions

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

//        // (re)load data if user changes
//        authenticationService.$session
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] user in
//                self?.loadData()
//            }
//            .store(in: &cancellables)
    }

//    private func loadData() {
//        if listenerRegistration != nil {
//            listenerRegistration?.remove()
//        }
//        listenerRegistration = db.collection(kegsPath)
//            .whereField("userId", isEqualTo: self.userId)
//            .addSnapshotListener { (querySnapshot, error) in
//
//                if let querySnapshot = querySnapshot {
//
//
//                    let newKegs = querySnapshot.documents.compactMap { queryDocumentSnapshot -> Keg? in
//                        print(queryDocumentSnapshot.data())
//                        do{
//                            let newKeg = try queryDocumentSnapshot.data(as: Keg.self)
//                            return newKeg
//                        } catch let DecodingError.dataCorrupted(context) {
//                            print(context)
//                        } catch let DecodingError.keyNotFound(key, context) {
//                            print("Key '\(key)' not found:", context.debugDescription)
//                            print("codingPath:", context.codingPath)
//                        } catch let DecodingError.valueNotFound(value, context) {
//                            print("Value '\(value)' not found:", context.debugDescription)
//                            print("codingPath:", context.codingPath)
//                        } catch let DecodingError.typeMismatch(type, context)  {
//                            print("Type '\(type)' mismatch:", context.debugDescription)
//                            print("codingPath:", context.codingPath)
//                        } catch {
//                            print("error: ", error)
//                        }
//                        return nil
//                    }
//
//                    for keg in newKegs{
//                        if let kegOffset = self.kegs.firstIndex(where: {$0._id == keg.getID()}) {
//                            self.kegs[kegOffset].beerType = keg.beerType;
//                            self.kegs[kegOffset].location = keg.location;
//                            self.kegs[kegOffset].percLeft = keg.data.percLeft
//                            self.kegs[kegOffset].beersLeft = keg.data.beersLeft;
//                            self.kegs[kegOffset].firstNotificationPerc = keg.firstNotificationPerc;
//                            self.kegs[kegOffset].secondNotificationPerc = keg.secondNotificationPerc;
//                            self.kegs[kegOffset].subscribed = keg.subscribed;
//
//                            self.kegs[kegOffset].customTare = keg.data.customTare;
//                            self.kegs[kegOffset].weight = keg.data.weight;
//                            self.kegs[kegOffset].temp = keg.data.temp;
//                            self.kegs[kegOffset].beersToday = keg.data.beersToday;
//                            self.kegs[kegOffset].beersDaily = keg.data.beersDaily;
//                            self.kegs[kegOffset].beersDailyArray = keg.data.beersDailyArray;
//                            self.kegs[kegOffset].beersThisWeek = keg.data.beersThisWeek;
//                            self.kegs[kegOffset].beersWeekly = keg.data.beersWeekly;
//                            self.kegs[kegOffset].beersThisMonth = keg.data.beersThisMonth;
//                            self.kegs[kegOffset].beersMonthly = keg.data.beersMonthly;
//                            self.kegs[kegOffset].firstNotificationSent = keg.data.firstNotificationSent;
//                            self.kegs[kegOffset].secondNotificationSent = keg.data.secondNotificationSent;
//                            self.kegs[kegOffset].potentialNewKeg = keg.potentialNewKeg;
//                        } else {
//                            self.kegs.append(KegViewModel(keg:keg))
//                        }
//                    }
//
//                    print(self.kegs)
//
//                }
//            }
//    }


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
                    completion(false)
                } else {
                    print("Document successfully updated!")
                    completion(true)
                }
            }

    }

}
