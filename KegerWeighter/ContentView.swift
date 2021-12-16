//
//  ContentView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import SwiftUI
import FirebaseMessaging
import FirebaseFirestore
import Resolver

struct ContentView: View {
    
    @ObservedObject var sessionStore: SessionStore = Resolver.resolve()
    @Environment(\.scenePhase) private var scenePhase
    @State var showSplashScreen: Bool = true
    
    var body: some View {
        
        Group{
            
            if showSplashScreen {
                SplashScreenView()
            }else{
                if sessionStore.user == nil{
                    AuthView().transition(AnyTransition.move(edge: .leading).animation(.spring()))
                }else{
                    DashboardView().transition(AnyTransition.move(edge: .leading).animation(.spring()))
                }
            }
        } .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation{
                    self.showSplashScreen = false
                }
            })
        })
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
