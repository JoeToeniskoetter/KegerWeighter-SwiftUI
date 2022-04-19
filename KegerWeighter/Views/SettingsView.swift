//
//  SettingsView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/8/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @StateObject var viewModel = SettingsViewModel()
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        Form{
            Picker(selection: self.$settingsStore.beerSize, label: Text("Beer Size")){
                ForEach(BeerSize.allCases) { size in
                    Text(size.rawValue.capitalized).tag(size)
                }
            }.onChange(of: self.settingsStore.beerSize, perform: { newValue in
                self.settingsStore.updateBeerSize()
            })
            Picker(selection: self.$settingsStore.tempType, label: Text("Temperature Measurement")){
                ForEach(TemperatureTypes.allCases) { measurement in
                    Text(measurement.rawValue.capitalized).tag(measurement)
                }
            }.onChange(of: self.settingsStore.tempType, perform: { newValue in
                self.settingsStore.updateTemp()
            })
            Section(header: Text("Account")){
                HStack{
                    Text("Email: ").foregroundColor(.gray)
                    Text(viewModel.sessionStore.user?.email ?? "")
                }
                Button("Sign Out"){
                    self.viewModel.signOut()
                }.foregroundColor(Color.red)
            }
        }.navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SettingsStore())
    }
}
