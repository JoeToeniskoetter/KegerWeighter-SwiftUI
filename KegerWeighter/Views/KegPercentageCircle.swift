//
//  KegPercentageCircle.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/2/21.
//

import SwiftUI

struct KegPercentageCircle: View {
    @Binding var progress: Float
    
    
    func computeColor(prog:Float) -> Color{
        
        if (prog >= 0.50) {
            return Color.green
        }
        
        if(prog < 0.50 && prog > 0.30){
            return Color.orange
        }
        
        return Color.red
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color.gray.opacity(0.5))
                Circle()
                .trim(from: CGFloat(0.0), to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(self.computeColor(prog: self.progress))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.title2)
                .bold()
        }
    }
}

//struct KegPercentageCircle_Previews: PreviewProvider {
//    static var previews: some View {
//        @State private var progress:Float = 0.28
//        KegPercentageCircle(progress: progress)
//    }
//}
