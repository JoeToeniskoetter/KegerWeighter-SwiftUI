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
    @State private var showingAlert = false
    @State private var loading = false
    
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
                Section(header:Text("Reset Keg")){
                    Button("Reset Keg"){
                        self.showingAlert = true
                    }.foregroundColor(.red)
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Reset Keg?"),
                                message: Text("This will clear out any incorrect readings"),
                                primaryButton: .destructive(Text("Reset"), action:{
                                    self.loading = true
                                    self.kegViewModel.reset( clearData: true, completion: { sucess in
                                        
                                        if(sucess){
                                            print("keg reset success")
                                            self.loading = false
                                            self.presentationMode.wrappedValue.dismiss()
                                        }else{
                                            print("could not reset keg")
                                        }
                                    })
                                }),
                                secondaryButton: .default(Text("Cancel"), action:{
                                    print("Cancel")
                                })
                            )
                        }
                }
                
            }.navigationBarTitle("Edit Keg")
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button("Cancel"){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        Button(action: {
                            self.kegViewModel.update(completion: {result in
                                if result {
                                    presentationMode.wrappedValue.dismiss()
                                }else{
                                    print("error")
                                }
                            })
                        }, label: {
                            if self.loading{
                                ProgressView()
                            }else{
                                Text("Save")
                            }
                        }).disabled(self.validateForm())
                    }
                    
                }
            
        }
    }
}


struct EditKegFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditKegFormView(kegViewModel:KegViewModel(keg: Keg(
            beerType: "Bud Select",
            online: true,
            location: "Basement 2",
            kegSize: .halfBarrel,
            firstNotificationPerc: 0,
            secondNotificationPerc: 0,
            subscribed: false,
            data : KegData(
                customTare: 0,
                beersLeft:90,
                weight:10,
                percLeft: 0.0,
                temp: 30,
                beersToday:0,
                beersDaily: [
                    "12/13/2021":1,
                    "12/14/2021":0,
                    "12/15/2021":0,
                    "12/16/2021":10
                ],
                beersDailyArray: [3,4,5,6,7],
                beersThisWeek: 0,
                beersWeekly: [:],
                beersWeeklyArray: [0,0,0,0,0],
                beersThisMonth: 0,
                beersMonthly: [:],
                beersMonthlyArray:[0,0,0,0,0],
                firstNotificationSent: false,
                secondNotificationSent: false
            ),
            createdAt:0,
            potentialNewKeg: true
        )))
    }
}
