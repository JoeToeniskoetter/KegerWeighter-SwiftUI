//
//  EditKegForm.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/8/21.
//

import Foundation
import SwiftUI


struct EditKegFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var kegViewModel: KegViewModel
    @State var notificationsEnabled: Bool = false
    
    func validateForm() -> Bool{
        return self.kegViewModel.beerType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.kegViewModel.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        (
            self.notificationsEnabled
            && self.kegViewModel.firstNotificationPerc < 1
        )
        
        ||
        
        (
            self.notificationsEnabled
            && self.kegViewModel.secondNotificationPerc > self.kegViewModel.firstNotificationPerc
        )
    }
    
    var kegSizes = Array(KegSize.allCases)
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New keg info")) {
                    TextField("Beer Type", text: self.$kegViewModel.beerType)
                    TextField("Location", text: self.$kegViewModel.location)
                    Picker(selection: self.$kegViewModel.kegSize, label: Text("Keg Size")){
                        ForEach(KegSize.allCases) { size in
                            Text(size.rawValue.capitalized).tag(size)
                        }
                    }
                }
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn: self.$kegViewModel.subscribed.animation()) {
                        Text("Notify Me When This Keg is Low")
                    }
                    
                }
                
                if self.kegViewModel.subscribed {
                    Section(header: Text("First Notification %")){
                        TextField("", value: self.$kegViewModel.secondNotificationPerc, formatter: NumberFormatter())
                            .padding()
                            .keyboardType(.decimalPad)
                        
                    }
                    Section(header: Text("Second Notification %")){
                        TextField("", value: self.$kegViewModel.firstNotificationPerc, formatter: NumberFormatter())
                            .padding()
                            .keyboardType(.decimalPad)
                        
                    }
                }
                Button("Save"){
                    self.kegViewModel.update(completion: {result in
                        if result {
                            presentationMode.wrappedValue.dismiss()
                        }else{
                            print("error")
                        }
                    })
                }.disabled(self.validateForm())
                
            }.navigationBarTitle("New Keg")
                .toolbar {
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
    }
}

