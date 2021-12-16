//
//  Settings.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/8/21.
//

import Foundation


struct Settings: Codable {
    let tempType: TemperatureTypes
    let beerSize: BeerSize
}

enum TemperatureTypes: String, Codable, CaseIterable, Identifiable {
    case farenheight = "Farenheight"
    case celcius = "Celcius"
    
    var id: String {self.rawValue}
}

enum BeerSize: String, Codable, CaseIterable, Identifiable {
    case sixteenOz = "16oz"
    case twelveOz = "12oz"
    
    var id: String {self.rawValue}
}

