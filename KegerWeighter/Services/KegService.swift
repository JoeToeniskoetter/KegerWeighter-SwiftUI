//
//  KegService.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/14/21.
//

import Foundation
import FirebaseFirestore

class KegService{
    private var db = Firestore.firestore()
    
    func update(keg:Keg, id: String, completion: @escaping (_ success: Bool) -> Void){
        self.db.collection("kegs")
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
