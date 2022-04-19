//
//  Keg.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/6/21.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Keg: Codable, Identifiable{

    @DocumentID var id:String? = UUID().uuidString;
    var beerType: String;
    var online:Bool;
    var location: String;
    var kegSize: KegSize;
    var firstNotificationPerc: Int;
    var secondNotificationPerc: Int;
    var subscribed: Bool;
    var data : KegData
    var createdAt:Int?
    var potentialNewKeg: Bool
    
    func getID()-> String{
        return self._id.wrappedValue ?? ""
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case online
        case beerType
        case location
        case kegSize
        case firstNotificationPerc
        case secondNotificationPerc
        case subscribed
        case createdAt
        case data
        case potentialNewKeg
    }
}

struct KegData: Codable{
    var customTare, beersLeft, weight: Int
    var percLeft: Float
    var temp, beersToday: Int
    var beersDaily: [String:Int]
    var beersDailyArray: [Double]
    var beersThisWeek: Int
    var beersWeekly: [String:Int]
    var beersWeeklyArray: [Double]
    var beersThisMonth: Int
    var beersMonthly: [String:Int]
    var beersMonthlyArray: [Double]
    var firstNotificationSent, secondNotificationSent: Bool
    
    enum CodingKeys: String, CodingKey{
        case customTare
        case beersLeft
        case percLeft
        case weight
        case temp
        case beersToday
        case beersDaily
        case beersDailyArray
        case beersThisWeek
        case beersWeekly
        case beersWeeklyArray
        case beersThisMonth
        case beersMonthly
        case beersMonthlyArray
        case firstNotificationSent
        case secondNotificationSent
    }
    
    func isTrendHigher(_ trend: [String:Int])-> Bool{
        let vals = Array(trend.values)
        return vals[0] > vals[1]
    }
    
}

enum KegSize: String, Codable, CaseIterable, Identifiable {
    case halfBarrel = "1/2 Barrel";
    case quarterBarrle = "1/4 Barrel";
    case sixthBarrel = "1/6 Barrel";
    case ponyKeg = "Pony Keg"
    case fiftyLitre = "50 Litre"
    
    var id :String {self.rawValue}
    
}
