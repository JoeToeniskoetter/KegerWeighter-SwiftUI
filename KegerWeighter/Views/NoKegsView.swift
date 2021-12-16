//
//  NoKegsView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/16/21.
//

import SwiftUI

struct NoKegsView: View {
    var body: some View {
        NavigationView{
        VStack{
            Text("No Kegs. Add one here")
                .font(.title)
            Image("main_logo_transparent")
                .renderingMode(.original)
                .resizable()
                .frame(width:150, height:150)
            
        }
        }
    }
}

struct NoKegsView_Previews: PreviewProvider {
    static var previews: some View {
        NoKegsView()
    }
}
