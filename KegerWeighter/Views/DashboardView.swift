//
//  DashboardView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import SwiftUI
import Resolver

//var ks:[Keg] = [
//    Keg(beerType: "test", location: "test", kegSize: "1/2 Barrell", firstNotificationPerc: 50, secondNotificationPerc: 25, subscribed: false, data: KegData(percLeft: 0.50, beersLeft: 80))
//]

struct DashboardView: View {
    //    @ObservedObject var kegRepository: FirestoreKegRepository = Resolver.resolve()
    @StateObject var dashboardViewModel = DashboardViewModel()
    @State private var showActionSheet = false
    @StateObject var authViewModel = AuthViewModel()
    @State private var animateButton:Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                
                VStack{
                    if(dashboardViewModel.kegViewModels.count < 1){
                        NoKegsView()
                    }else{
                        List(dashboardViewModel.kegViewModels){keg in
                            NavigationLink(destination: KegDetailView(keg:keg)){
                                KegCardView(keg:keg)
                            }
                            .foregroundColor(.primary)
                            .padding(.top, 10)
                            
                        }
                    }
                    
                }.navigationTitle("My Kegs")
                    .toolbar {
                        NavigationLink(destination: SettingsView()){
                            Image(systemName:"gear")
                        }
                    }
                
                if self.dashboardViewModel.kegViewModels.count > 0{
                    AddKegFloatingButton()
                }else{
                    AddKegFloatingButton().scaleEffect(animateButton ? 1.08 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                self.animateButton.toggle()
                            }
                        }
                }
                
            }
        }.onAppear(perform: {
            self.dashboardViewModel.fetchKegs()
        })
    }
}



extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
