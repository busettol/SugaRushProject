//
//  CheckoutView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI

struct CheckoutView: View {
	@State var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
	@State var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
	@State var speechController = SpeechRecognizerController()
	@State var extraInfo: String = ""
	var ordervm = OrderViewModel()
	@State var isListening: Bool = false

	// Hardcoded dessert list
	@State private var desserts = [
		Dessert(name: "Muffins", description: "Delicious freshly baked muffins", price: 4, quantity: 0),
		Dessert(name: "Croissant", description: "Flaky, buttery croissants", price: 7, quantity: 0),
		Dessert(name: "Cheesecake", description: "Rich and creamy cheesecake", price: 10, quantity: 0)
	]

	var body: some View {
		ZStack {
			LinearGradient(colors: [col1, col2], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
			VStack {
				HStack {
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
				}
				.frame(height: 125)
				.background(Color(red: 176/255, green: 61/255, blue: 155/255))

				Spacer()
				VStack {
					Text("Leave a note")
						.font(.headline)
						.foregroundColor(.white)
						.padding(.top, 20)
						.padding(.horizontal)
					// TextEditor for extraInfo
					ZStack(alignment: .topLeading) {

						// TextEditor for user input
						TextEditor(text: $extraInfo)
							.frame(height: 200)  // Adjust height for larger size
							.padding(8)  // Match padding with placeholder
							.background(Color.white.opacity(0.7))  // Background color for visibility
							.cornerRadius(10)
							.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))  // Optional border

						if extraInfo.isEmpty {
							Text("Add allergies, accommodations, time preference, etc.")
								.foregroundColor(.gray)
								.padding(8) // Adjust padding to align with TextEditor
						}
					}

					Button(action: {
						extraInfo = ""
						if isListening {
							print("[Button Action] Stopping listening...")
							speechController.stopListening()
							extraInfo = speechController.transcribedText.isEmpty ? "Start speaking..." : speechController.transcribedText
						} else {
							print("[Button Action] Starting listening...")
							speechController.startListening()
						}
						isListening.toggle()
					}) {
						Text(isListening ? "Stop Listening" : "Start Listening")
							.font(.headline)
							.padding()
							.frame(maxWidth: .infinity)
							.background(isListening ? Color.red : Color.blue)
							.foregroundColor(.white)
							.cornerRadius(10)
					}
					.padding()

					// Dessert List
					VStack {
						ForEach($desserts, id: \.name) { $dessert in
							HStack {
								VStack(alignment: .leading) {
									Text(dessert.name)
										.font(.headline)
									Text(dessert.description)
										.font(.subheadline)
								}
								Spacer()
								HStack {
									Button(action: {
										if dessert.quantity > 0 {
											dessert.quantity -= 1
										}
									}) {
										Text("-")
											.font(.title)
											.foregroundColor(.white)
											.frame(width: 40, height: 40)
											.background(Color.red)
											.clipShape(Circle())
									}
									Text("\(dessert.quantity)")
										.font(.title2)
									Button(action: {
										dessert.quantity += 1
									}) {
										Text("+")
											.font(.title)
											.foregroundColor(.white)
											.frame(width: 40, height: 40)
											.background(Color.green)
											.clipShape(Circle())
									}
								}
							}
							.padding()
							.background(Color.white.opacity(0.7))
							.cornerRadius(10)
							.shadow(radius: 5)
						}
					}

					// Checkout Button
					Button(action: {

						var quantity = 0

						for(dessert) in desserts{
							quantity += dessert.quantity
						}

						if(quantity < 1){
							NotificationAlert.show(title: "Empty cart", message: "Please have atleast one dessert before you check out.")
							return
						}

						if let email = ordervm.getSignedInUserEmail(){
							ordervm.pushDataToFirestore(dessertList: desserts, person: email, extraInfo: extraInfo)

						}else{
							NotificationAlert.show(title: "Sign in first", message: "Please sign in first before you create an order")
							ordervm.pushDataToFirestore(dessertList: desserts, person: "User", extraInfo: extraInfo)

						}

						// Trigger pushDataToFirestore with desserts and extraInfo
					}) {
						Text("Checkout")
							.font(.headline)
							.padding()
							.frame(maxWidth: .infinity)
							.background(Color.purple)
							.foregroundColor(.white)
							.cornerRadius(10)
					}
					.padding()
				}

				Spacer()

				Rectangle()
					.fill(Color(red: 250/255, green: 160/255, blue: 160/255))
					.frame(height: 100)
			}
			.ignoresSafeArea()
		}
	}
}

#Preview {
	CheckoutView()
}
