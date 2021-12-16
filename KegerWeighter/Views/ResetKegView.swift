//
//  ResetKegView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/14/21.
//

import SwiftUI

struct ResetKegView: View {
    var body: some View {
            ScrollView{
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                    .padding()
                Text("Your KegerWeighter just showed a large change in weight. If this is a new keg, we recommend you reset.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
                Button("Reset"){
                    print("Something")
                }.buttonStyle(RoundedRectangleButtonStyle())
                    .padding()
            }
    }
}

struct ResetKegView_Previews: PreviewProvider {
    static var previews: some View {
        ResetKegView()
    }
}
