//
//  MapsView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI
import _MapKit_SwiftUI

struct MapsView: View {
    @State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
	@StateObject private var viewModel = MapViewModel()


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
				VStack {
					Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: [viewModel.destination]) { place in
						MapAnnotation(coordinate: place.coordinate){
							VStack{
								Image(systemName : "mappin.circle.fill")
									.resizable()
									.foregroundColor(.blue)
									.frame(width:50, height: 50)
								Text(place.name)
									.font(.caption)
									.padding(4)
									.background(Color.white.opacity(0.6))
									.cornerRadius(5)
							}.onTapGesture {

							}
						}
					}
					.edgesIgnoringSafeArea(.all)


					Button(action: {
						viewModel.openInMaps()
					}) {
						Text("Get Directions")
							.font(.headline)
							.foregroundColor(.white)
							.padding()
							.background(Color.blue)
							.cornerRadius(8)
					}
					.padding()
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
    MapsView()
}
