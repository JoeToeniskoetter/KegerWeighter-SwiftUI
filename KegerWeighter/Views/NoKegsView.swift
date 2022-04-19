//
//  NoKegsView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/16/21.
//

import SwiftUI

struct NoKegsView: View {
    var body: some View {
        VStack{
            Image("main_logo_transparent")
                .renderingMode(.original)
                .resizable()
                .frame(width:150, height:150)
                .opacity(0.3)
            Text("No Kegs. Add one here")
                .font(.body)
                .foregroundColor(Color.gray)
        }
    }
}

struct NoKegsView_Previews: PreviewProvider {
    static var previews: some View {
        NoKegsView()
    }
}
