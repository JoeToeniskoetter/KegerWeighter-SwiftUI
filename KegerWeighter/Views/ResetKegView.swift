//
//  ResetKegView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/14/21.
//

import SwiftUI

struct ResetKegView: View {
    @StateObject var vm: KegViewModel
    @Binding var loading: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView{
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
                .padding()
            Text("Your KegerWeighter just showed a large change in weight. If this is a new keg, or your keg was moved around, we recommend you reset.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button {
                vm.reset(clearData: true, completion: { success in
                    if success {
                        print("reset keg")
                        self.presentationMode.wrappedValue.dismiss()
                    }else{
                        print("could not reset")
                    }
                })
            } label: {
                if self.loading{
                    ProgressView()
                }else{
                    Text("Reset")
                }
            }.buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.red))
                .padding()
            
            Button("Ignore"){
                vm.reset(clearData: false, completion: { success in
                    if(success){
                        print("keg reset")
                        self.presentationMode.wrappedValue.dismiss()
                    }else{
                        print("coult not reset")
                    }
                })
            }.buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.gray))
                .padding(.horizontal)
            }
        }
    }
    
    //struct ResetKegView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ResetKegView(reset: ()->Void)
    //    }
    //}
