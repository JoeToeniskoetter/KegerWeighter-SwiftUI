//
//  AuthView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 11/30/21.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var signIn: Bool = true
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing:20){
                    VStack{
                        Image("main_logo_transparent")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width:100, height:100)
                        Text("KegerWeighter")
                            .font(.title)
                    }
                    Spacer()
                    HStack(alignment: .top){
                        
                        Text(self.signIn ? "Sign In" : "Sign Up")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        
                    }
                    VStack{
                        Group{
                            TextField("Email", text: self.$authViewModel.email)
                            SecureField("Password", text: self.$authViewModel.password)
                        }
                        .frame(height:30)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        
                        Group{
                            Button(self.signIn ? "Login with Email" : "Sign Up"){
                                print("Sigining In")
                                self.signIn ?  self.authViewModel.signInWithEmail()
                                : self.authViewModel.signUpWithEmail()
                            }.buttonStyle(MainButtonStyle(backgroundColor: Color.blue))
                                .alert(isPresented: self.$authViewModel.authError, content: {
                                    Alert(
                                        title: Text("Login Failed"),
                                        message: Text(self.authViewModel.errorMessage),
                                        dismissButton: .destructive(Text("OK"), action: {
                                            self.authViewModel.dismiessError()
                                        })
                                    )
                                })
                            
                            AppleSignInButton().onTapGesture {
                                self.authViewModel.handleAppleSignIn()
                            }
                            .frame(height:50)
                            .shadow(color: Color.gray, radius: 1.0, y: 1.0)
                            
                            Button(action: {
                                self.authViewModel.handleGoogleSignIn()
                                
                            }) {
                                HStack{
                                    Image("google_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:25, height:25)
                                    Text("Sign in with Google").foregroundColor(Color.black)
                                }
                            }.buttonStyle(MainButtonStyle(backgroundColor: Color.white))
                            
                            Button(self.signIn ? "Need an account?" : "Go To Sign In"){
                                withAnimation{
                                    self.signIn.toggle()
                                }
                            }
                            Spacer()
                        }.padding(.horizontal,10)
                    }
                }.padding()
            }.background(
                Image("svg_icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width:1000)
                    .clipped()
                    .rotationEffect(.degrees(15))
                    .opacity(0.08)
            )
        }
    }
}

struct AppleSignInButton: UIViewRepresentable {
    
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> UIViewType {
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct MainButtonStyle: ButtonStyle {
    var backgroundColor:Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth:.infinity)
            .frame(height:50)
            .background(self.backgroundColor)
            .foregroundColor(Color.white)
            .cornerRadius(8.0)
            .shadow(color: Color.gray, radius: 1.0, y: 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
