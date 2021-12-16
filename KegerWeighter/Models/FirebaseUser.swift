//
//  FirebaseUser.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/16/21.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit


class FirebaseUser: Codable, Identifiable{
    
    @DocumentID var id:String? = UUID().uuidString;
    var email: String?
    var photoUrl: String?
    var role: String
    var uid: String
    var fcmToken: [String]
    
    
    func getID()-> String{
        return self._id.wrappedValue ?? ""
    }
    
    enum CodingKeys: String, CodingKey{
        case email, photoUrl, role, uid
        case fcmToken
    }
}
