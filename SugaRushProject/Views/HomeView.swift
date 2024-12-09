//
//  HomeView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI

struct Special: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let price: Double
}

struct HomeView: View {
    @State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
    
    //HARDCODED FOR NOW
    let specials = [
            Special(imageName: "spec0", name: "Muffins", price: 4.99),
            Special(imageName: "spec1", name: "Croissant", price: 7.50),
            Special(imageName: "spec2", name: "Cheesecake", price: 9.99)
        ]
    
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
                }.frame(height: 119)
                .background(Color(red: 176/255, green: 61/255, blue: 155/255))
                
                VStack{
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                    Text("~ TODAY'S SPECIALS ~")
                        .font(.title)
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(specials) { special in
                                HStack {
                                    Image(special.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                    
                                    VStack(alignment: .leading) {
                                        Text(special.name)
                                            .font(.headline)
                                        Text("$\(String(format: "%.2f", special.price))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
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
    HomeView()
}
