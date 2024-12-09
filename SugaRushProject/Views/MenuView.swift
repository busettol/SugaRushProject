//
//  MenuView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let price: Double
    let description: String
    let ingredients: [String]
}

struct MenuView: View {
    @State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
    
    let menuItems = [
        MenuItem(imageName: "spec0", name: "Muffins", price: 4.99, description: "Write some stuff here", ingredients: ["idk", "sugar?"]),
        MenuItem(imageName: "spec1", name: "Croissant", price: 7.50, description: "Write some stuff here", ingredients: ["idk", "sugar?"]),
        MenuItem(imageName: "spec2", name: "Cheesecake", price: 9.99, description: "Write some stuff here", ingredients: ["idk", "sugar?"])
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
                }.frame(height: 125)
                .background(Color(red: 176/255, green: 61/255, blue: 155/255))
                
                Text("OUR MENU")
                        .font(.title)
                        .padding()
                                    
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(menuItems) { item in
                            NavigationLink(destination: DetailsView(item: item)) {
                                HStack {
                                    Image(item.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text("$\(String(format: "%.2f", item.price))")
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
                    }
                    .padding()
                }
                
                Rectangle()
                    .fill(Color(red: 250/255, green: 160/255, blue: 160/255))
                    .frame(height: 100)
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    MenuView()
}
