//
//  ContentView.swift
//  SugaRushProject
//
//  Created by Lucas Busetto on 2024-11-27.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView = 0
	@State var speechController = SpeechRecognizerController()
	@State var mapsViewModel = MapViewModel()

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
            
            CheckoutView()
                .tabItem {
                    Text("Checkout")
                    Image(systemName: "cart")
                }.tag(2)

            MapsView()
                .tabItem {
                    Text("Maps")
                    Image(systemName: "map")
                }.tag(3)

			UsersOrderView()
				.tabItem {
					Text("Orders")
					Image(systemName: "list.bullet")
				}.tag(3)

            AccountCreation()
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person.crop.circle")
                }.tag(4)
        }
		.onAppear {
			print("[ContentView] Requesting permission on appear...")
			speechController.requestSpeechRecognitionPermission { authorized in
				if !authorized {
					print("[ContentView] Speech recognition not authorized.")
				}
			}

			mapsViewModel.checkLocationAuthorization()

		}
	}
}

#Preview {
    ContentView()
}
