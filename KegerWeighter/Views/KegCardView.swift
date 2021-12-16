//
//  KegCardView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/6/21.
//

import SwiftUI

struct KegCardView: View {
      @StateObject var keg: KegViewModel
    
    var body: some View {
        HStack(alignment: .center){
            KegPercentageCircle(progress: self.$keg.percLeft)
                .frame(width: 100.0, height: 120.0)
                .padding(20.0)
            VStack(alignment:.leading){
                Text(self.keg.beerType)
                    .font(.title).fontWeight(.bold)
                Text(self.keg.location)
            }
        }
    }
}

//struct KegCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KegCardView(progress: .constant(0.25))
//    }
//}
