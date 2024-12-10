//
//  AccountCreation.swift
//  SugaRushProject
//
//  Created by Lucas Busetto on 2024-12-09.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AccountCreation: View {
    @State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
    
    @State var email : String = ""
    @State var password : String = ""
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""


    @State var userIsLoggedIn = false
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(colors: [col1, col2], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        VStack {
                            Spacer()
                            Image("image0")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 49)
                                .padding()
                        }
                        Spacer()
                    }.frame(height: 125)
                        .background(Color(red: 176/255, green: 61/255, blue: 155/255))
                    
                    Spacer()
                    VStack{
                        Text("Welcome to SugaRush").font(.largeTitle)
                        Spacer()
                        Text("Create your account").bold()
                        
                        TextField("Enter Email", text: $email)
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.black)
                        
                        SecureField("Enter Password", text: $password)
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.black)
                        
                        
                        Button {
                            register()
                        } label: {
                            Text("Create Account")
                                .bold()
                                .frame(width: 200, height: 40)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(red: 176/255, green: 61/255, blue: 155/255))
                                )
                        }
                        .offset(y: 70)
                        Spacer()
                        
                        NavigationLink{
                            SignInView()
                                .navigationBarBackButtonHidden(true)
                        }label:{
                            Text("Already have an account? Sign in")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 350, height: 400)
                    Spacer()
                    
                }.ignoresSafeArea()
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){result, error in if error != nil{
            self.alertTitle = "Sign Up Failed"
            self.alertMessage = error!.localizedDescription
            print(error!.localizedDescription)
        }else{
            self.alertTitle = "Success"
            self.alertMessage = "Account created successfully"
        }
            self.showAlert = true
        }
    }
}
    
#Preview{
    AccountCreation()
}

