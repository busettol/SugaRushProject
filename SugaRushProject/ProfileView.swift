//
//  ProfileView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI

struct ProfileView: View {
    @State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
    
    var body: some View {
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
                    Text("THIS IS WHERE YOU WRITE THE CODE, LUCAS? idk whos on this ngl but good luck fr ")
                }
                Spacer()
                
                Rectangle()
                    .fill(Color(red: 250/255, green: 160/255, blue: 160/255))
                    .frame(height: 100)
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    ProfileView()
}
