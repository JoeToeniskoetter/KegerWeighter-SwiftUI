//
//  KegViewModel.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/7/21.
//
import Combine
import Foundation
import FirebaseFirestore
import Resolver

class KegViewModel: ObservableObject, Identifiable {
    @Injected var kegRepository: FirestoreKegRepository
          
    @Published var _id: String = ""
    @Published var beerType:String = ""
    @Published var location: String = ""
    @Published var percLeft: Float = 0.0
    @Published var beersLeft: Int = 0
    @Published var firstNotificationPerc: Int = 0
    @Published var secondNotificationPerc: Int = 0
    @Published var kegSize: KegSize = .halfBarrel
    @Published var subscribed: Bool = false
    
    @Published var customTare: Int = 0
    @Published var weight: Int = 0
    @Published var temp: Int = 0
    @Published var beersToday: Int = 0
    @Published var beersDaily: [String:Int] = [:]
    @Published var beersDailyArray: [Double] = []
    @Published var beersThisWeek: Int = 0
    @Published var beersWeekly:  [String:Int] = [:]
    @Published var beersWeeklyArray: [Double] = []
    @Published var beersThisMonth: Int = 0
    @Published var beersMonthly: [String:Int] = [:]
    @Published var beersMonthlyArray: [Double] = []
    @Published var firstNotificationSent: Bool = false
    @Published var secondNotificationSent: Bool = false
    @Published var potentialNewKeg: Bool = false
    
    var id:String {self._id}
    
    init(keg: Keg){
        
        self._id = keg.getID()
        self.beerType = keg.beerType
        self.location = keg.location
        self.percLeft = keg.data.percLeft
        self.beersLeft = keg.data.beersLeft
        self.firstNotificationPerc = keg.firstNotificationPerc
        self.secondNotificationPerc = keg.secondNotificationPerc
        self.subscribed = keg.subscribed

        self.customTare = keg.data.customTare
        self.weight = keg.data.weight
        self.temp = keg.data.temp
        self.beersToday = keg.data.beersToday
        self.beersDaily = keg.data.beersDaily
        self.beersDailyArray = keg.data.beersDailyArray
        self.beersThisWeek = keg.data.beersThisWeek
        self.beersWeekly = keg.data.beersWeekly
        self.beersWeeklyArray = keg.data.beersWeeklyArray
        self.beersThisMonth = keg.data.beersThisMonth
        self.beersMonthly = keg.data.beersMonthly
        self.beersMonthlyArray = keg.data.beersMonthlyArray
        self.firstNotificationSent = keg.data.firstNotificationSent
        self.secondNotificationSent = keg.data.secondNotificationSent
        self.potentialNewKeg = keg.potentialNewKeg
        
    
    }
    
    func toModel()-> Keg{
        return Keg(
            beerType: self.beerType,
            location: self.location,
            kegSize: self.kegSize,
            firstNotificationPerc: self.firstNotificationPerc,
            secondNotificationPerc: self.secondNotificationPerc,
            subscribed: self.subscribed,
            data:
                KegData(customTare: self.customTare,
                        beersLeft: self.beersLeft,
                        weight: self.weight,
                        percLeft: self.percLeft,
                        temp: self.temp,
                        beersToday: self.beersToday,
                        beersDaily: self.beersDaily,
                        beersDailyArray: self.beersDailyArray,
                        beersThisWeek: self.beersThisWeek,
                        beersWeekly: self.beersWeekly,
                        beersWeeklyArray: self.beersWeeklyArray,
                        beersThisMonth: self.beersThisMonth,
                        beersMonthly: self.beersMonthly,
                        beersMonthlyArray: self.beersMonthlyArray,
                        firstNotificationSent: self.firstNotificationSent,
                        secondNotificationSent: self.secondNotificationSent
                       ),
            potentialNewKeg: self.potentialNewKeg)
    }
    
    func update(completion: @escaping (_ success: Bool) -> Void){
//        self.db.collection("kegs")
//                .document(self._id)
//                .updateData([
//                    "beerType" : self.beerType,
//                    "location" : self.location,
//                    "kegSize": self.kegSize.rawValue,
//                    "firstNotificationPerc": self.firstNotificationPerc,
//                    "secondNotificationPerc": self.secondNotificationPerc,
//                    "subscribed": self.subscribed,
//                ]){ error in
//                    if let error = error {
//                        print("Error updating document: \(error)")
//                    } else {
//                        print("Document successfully updated!")
//                    }
//                }
        
        self.kegRepository.updateKeg(keg: self.toModel(), id: self._id, completion: completion)
    }
}

