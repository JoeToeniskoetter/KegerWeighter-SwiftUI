//
//  AddKegFloatingButton.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/3/21.
//

import SwiftUI

struct AddKegFloatingButton: View {
    @State private var showFullScreenModal:Bool = false
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showFullScreenModal.toggle()
                }, label: {
                    HStack{
                        Group{
                            Image(systemName: "plus")
                                .font(Font.title.weight(.bold))
                            Text("Add a Keg")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color.white)
                        .font(.title3)
                        
                    }.frame(height:30)
                        .padding()
                }).buttonStyle(FloatingButtonStyle())
                    .sheet(isPresented:$showFullScreenModal) {
                    } content: {
                        AddKegFormView()
                    }
                
            }
        }
    }
}

struct FloatingButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(38.5)
            .padding()
            .shadow(color: Color.blue.opacity(0.3),
                    radius: 3,
                    x: 5,
                    y: 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

//struct AddKegFloatingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddKegFloatingButton(stopAnimation: true)
//    }
//}


extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
