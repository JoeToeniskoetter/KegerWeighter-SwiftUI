//
//  SettingsViewModel.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/8/21.
//

import Foundation
import SwiftUI
import Resolver

class SettingsViewModel: ObservableObject{
    @Injected var sessionStore: SessionStore
    @Published var temp: Bool
    @Published var beerSize: Bool
    
    init(){
        let defaults = UserDefaults.standard
        self.temp = defaults.object(forKey:"Settings.Temp") as? Bool ?? true
        self.beerSize = defaults.object(forKey:"Settings.BeerSize") as? Bool ?? true
    }
    
    func signOut(){
        self.sessionStore.signOut()
    }
    
}
