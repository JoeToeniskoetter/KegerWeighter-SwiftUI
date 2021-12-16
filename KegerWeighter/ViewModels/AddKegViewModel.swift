//
//  AddKegViewModel.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/11/21.
//

import Foundation
import FirebaseFunctions

class AddKegViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = false
    @Published var kegSize: KegSize = .halfBarrel
    @Published var kegerWeighterId = ""
    @Published var beerType = ""
    @Published var location = ""
    @Published var firstNotification = "50"
    @Published var secondNotification = "25"
    @Published var errorMessage = ""
    @Published var errorAddingKeg: Bool = false
    @Published var loading: Bool = false
    private var functions = Functions.functions()
    
    func isFormValid()-> Bool{
        return self.kegerWeighterId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.beerType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func addKeg(completion: @escaping (_ success: Bool) -> Void){
//        self.functions.useEmulator(withHost: "localhost", port:5001)
        self.loading = true
        self.functions.httpsCallable("addKeg").call([
            "id": self.kegerWeighterId,
            "kegSize": self.kegSize.rawValue,
            "beerType": self.beerType,
            "location": self.location,
            "firstNotificationPerc": Int(self.firstNotification) ?? 0,
            "secondNotificationPerc": Int(self.secondNotification) ?? 0,
            "subscribed": self.notificationsEnabled
        ]) { result, error in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
                print(code, message, details)
                self.errorMessage = message
                self.errorAddingKeg = true
            }
              self.loading = false
              completion(false)
            // ...
          }
            
          if let data = result?.data {
            print(data)
              self.errorMessage = ""
              self.loading = false
              completion(true)
          }
        }
    }
}
