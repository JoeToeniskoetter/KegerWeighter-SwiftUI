//
//  SplashScreenView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/9/21.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack(alignment:.center){
            Image("main_logo")
                .frame(width:200, height:200)
                
        }.ignoresSafeArea(edges: .top)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
