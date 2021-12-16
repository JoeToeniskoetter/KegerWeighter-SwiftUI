//
//  SettingsStore.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/8/21.
//

import Foundation
import Combine

class SettingsStore: ObservableObject{
    @Published var tempType: TemperatureTypes = .farenheight
    @Published var beerSize: BeerSize = .twelveOz
    private var defaults = UserDefaults.standard
    
    init(){
        let tempType = defaults.string(forKey:"Settings.Temp") ?? TemperatureTypes.farenheight.rawValue
        let beerSize = defaults.string(forKey:"Settings.BeerSize") ?? BeerSize.twelveOz.rawValue
        
        self.tempType = TemperatureTypes(rawValue: tempType) ?? TemperatureTypes.farenheight
        self.beerSize = BeerSize(rawValue: beerSize) ?? BeerSize.twelveOz
    }
    
    func updateTemp(){
        print("updating temp setting: ", self.tempType)
        defaults.set(self.tempType.rawValue, forKey: "Settings.Temp")
    }
    
    func updateBeerSize(){
        print("updating beerSize setting: ", self.beerSize)
        defaults.set(self.beerSize.rawValue, forKey: "Settings.BeerSize")
    }
}
