//
//  AddKegFormView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/3/21.
//

import SwiftUI

struct AddKegFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = AddKegViewModel()
    private let userNotifications = UserNotificationService()
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New keg info")) {
                    TextField("KegerWeighterID", text: self.$viewModel.kegerWeighterId)
                        TextField("Beer Type", text: self.$viewModel.beerType)
                    TextField("Location", text: self.$viewModel.location)
                    Picker(selection: self.$viewModel.kegSize, label: Text("Keg Size")){
                        ForEach(KegSize.allCases) { size in
                            Text(size.rawValue.capitalized).tag(size)
                        }
                    }
                    
                }
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn:
                            self.$viewModel.notificationsEnabled.animation()) {
                        Text("Notify Me When This Keg is Low")
                    }
                }
                if self.viewModel.notificationsEnabled {
                    Section(header: Text("First Notification %")){
                        TextField("First Notification", text: self.$viewModel.firstNotification)
                            .padding()
                            .keyboardType(.decimalPad)
                        
                    }
                    Section(header: Text("Second Notification %")){
                        TextField("Second Notification", text: self.$viewModel.secondNotification)
                            .padding()
                            .keyboardType(.decimalPad)
                        
                    }
                }
                
            }.navigationBarTitle("New Keg")
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }.alert(isPresented: self.$viewModel.errorAddingKeg) {
                            Alert(title: Text("Error Adding Keg"), message: Text(self.viewModel.errorMessage), dismissButton: .default(Text("Try Again"), action:{
                                self.viewModel.errorAddingKeg = false
                                self.viewModel.errorMessage = ""
                            })
                            )
                        }
                    }

                    ToolbarItem(placement: .navigationBarLeading) {
                        if self.viewModel.loading{
                            ProgressView()
                        }else{
                            Button("Add") {
                                self.viewModel.addKeg(completion: { result in
                                    
                                    if result{
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                })
                            }.disabled(self.viewModel.isFormValid())
                        }
                    }
                }
        }
    }
}


struct AddKegFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddKegFormView()
    }
}
