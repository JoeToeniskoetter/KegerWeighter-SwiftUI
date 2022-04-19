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
        VStack{
            HStack{
                    OnlineStateView(online: $keg.online)
                    Spacer()
                    if(keg.potentialNewKeg){
                        Image(systemName:"exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 30))
                    }
            }.frame(height:5)
            HStack{
                Spacer()
                KegPercentageCircle(progress: self.$keg.percLeft)
                    .frame(width: 100.0, height: 120.0)
                    .padding(20.0)
                Spacer()
                VStack(alignment:.leading){
                    Text(self.keg.beerType)
                        .font(.title).fontWeight(.bold)
                    Text(self.keg.location)
                }
                Spacer()
            }
        }
    }
}

struct OnlineStateView: View{
    @Binding var online: Bool
    
    var body: some View{
        if online {
            HStack{
                Image(systemName: "circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 15))
                Text("Connected")
                    .foregroundColor(.green)
                    .font(.system(size: 15))
            }
        }else{
            HStack{
                Image(systemName: "circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                Text("Disconnected")
                    .foregroundColor(.red)
                    .font(.system(size: 15))
            }
        }
    }
}


struct KegCardView_Previews: PreviewProvider {
    static var previews: some View {
        KegCardView(keg:
                        KegViewModel(keg: Keg(
            beerType: "Bud Select",
            online:true,
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
