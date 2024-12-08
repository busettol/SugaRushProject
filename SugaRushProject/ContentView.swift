//
//  ContentView.swift
//  SugaRushProject
//
//  Created by Lucas Busetto on 2024-11-27.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView = 1
    var body: some View {
        TabView (selection: $selectedView){
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }.tag(0)
            
            MenuView()
                .tabItem {
                    Text("Menu")
                    Image(systemName: "menucard")
                }.tag(1)
            
            MenuView()
                .tabItem {
                    Text("Checkout")
                    Image(systemName: "cart")
                }.tag(2)

            MapsView()
                .tabItem {
                    Text("Maps")
                    Image(systemName: "map")
                }.tag(3)
            
            ProfileView()
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person.crop.circle")
                }.tag(4)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
