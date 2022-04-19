//
//  DashboardViewModel.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import Resolver

class DashboardViewModel : ObservableObject{
    @Injected var sessionStore: SessionStore
    @Published var kegViewModels = [KegViewModel]()
    @Published var hasKegs:Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    var kegsPath: String = "kegs"
    var userId: String = "unknown"
    
    private var firestore = Firestore.firestore()
    private var listener: ListenerRegistration? = nil
    
    deinit{
        if self.listener != nil{
            self.listener?.remove()
        }
    }
    
    func fetchKegs(){
        if listener != nil {
            listener?.remove()
       }
        
        self.listener = self.firestore.collection(kegsPath).whereField("userId", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener{(querySnapshot, err) in

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let newKegs = documents.compactMap { queryDocumentSnapshot -> Keg? in
                print(queryDocumentSnapshot.data())
                do{
                    let newKeg = try queryDocumentSnapshot.data(as: Keg.self)
                    return newKeg
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                return nil
            }

                for keg in newKegs{
                    print(keg)
                    if let kegOffset = self.kegViewModels.firstIndex(where: {$0._id == keg.getID()}) {
                        self.kegViewModels[kegOffset].beerType = keg.beerType;
                        self.kegViewModels[kegOffset].online = keg.online;
                        self.kegViewModels[kegOffset].location = keg.location;
                        self.kegViewModels[kegOffset].percLeft = keg.data.percLeft;
                        self.kegViewModels[kegOffset].beersLeft = keg.data.beersLeft;
                        self.kegViewModels[kegOffset].firstNotificationPerc = keg.firstNotificationPerc;
                        self.kegViewModels[kegOffset].secondNotificationPerc = keg.secondNotificationPerc;
                        self.kegViewModels[kegOffset].subscribed = keg.subscribed;

                        self.kegViewModels[kegOffset].customTare = keg.data.customTare;
                        self.kegViewModels[kegOffset].weight = keg.data.weight;
                        self.kegViewModels[kegOffset].temp = keg.data.temp;
                        self.kegViewModels[kegOffset].beersToday = keg.data.beersToday;
                        self.kegViewModels[kegOffset].beersDaily = keg.data.beersDaily;
                        self.kegViewModels[kegOffset].beersDailyArray = keg.data.beersDailyArray;
                        self.kegViewModels[kegOffset].beersThisWeek = keg.data.beersThisWeek;
                        self.kegViewModels[kegOffset].beersWeekly = keg.data.beersWeekly;
                        self.kegViewModels[kegOffset].beersThisMonth = keg.data.beersThisMonth;
                        self.kegViewModels[kegOffset].beersMonthly = keg.data.beersMonthly;
                        self.kegViewModels[kegOffset].firstNotificationSent = keg.data.firstNotificationSent;
                        self.kegViewModels[kegOffset].secondNotificationSent = keg.data.secondNotificationSent;
                        self.kegViewModels[kegOffset].potentialNewKeg = keg.potentialNewKeg;
                    } else {
                        let newKvm = KegViewModel(keg:keg)
                        self.kegViewModels.append(newKvm)
                    }
                }
            self.hasKegs = self.kegViewModels.count > 0;
            print(self.kegViewModels)

        }
    }
//
//    func addKegsToList(querySnapshot: QuerySnapshot, err: Any){
//
//    }
    
    
    
}
