//
//  ResetPasswordView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 1/3/22.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModal = AuthViewModel()
    @State private var email:String = ""
    @State private var emailSent: Bool = false
    
    var body: some View {
        VStack{
            HStack{
            Text("Email")
                .font(.title2)
                .bold()
                .foregroundColor(.gray)
                Spacer()
            }.padding()
            HStack{
                TextField("Example@example.com", text:self.$email)
                    .frame(height:30)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .keyboardType(.emailAddress)
            }
            Button{
                if(self.emailSent){
                    self.emailSent = false
                    self.email = ""
                }else{
                    self.viewModal.resetPasswordEmail(email: self.email, completion: {result in
                        withAnimation{
                            self.emailSent = true
                        }
                    })
                }
            }label:{
                if !emailSent{
                    Text("Send Email")
                }else if self.viewModal.loading {
                    ProgressView()
                }else{
                    Text("Email Sent")
                }

            }
            .buttonStyle(MainButtonStyle(backgroundColor: self.emailSent ? .green : .blue))
            .padding()
            Spacer()
        }.padding()
        .navigationTitle("Reset Password")
        
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
