//
//  OrderViewModel.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-09.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
//display orders


//create orders

class OrderViewModel {
	private let db = Firestore.firestore()

	func pushDataToFirestore(dessertList: [Dessert], person: String, extraInfo: String) {
		let order = Order(dessertOrder: dessertList, person: person, extraInformation: extraInfo)

		// Convert Order to a dictionary
		let orderDict: [String: Any] = [
			"id": order.id.uuidString,
			"date": order.date,
			"dessertOrder": order.dessertOrder.map { dessert in
				return [
					"name": dessert.name,
					"description": dessert.description,
					"price": dessert.price,
					"quantity": dessert.quantity
				]
			},
			"person": order.person,
			"extraInformation": order.extraInformation
		]

		db.collection("orders").addDocument(data: orderDict) { error in
			if let error = error {
				print("Error adding document: \(error)")
			} else {
				print("Document added successfully!")
			}
		}
	}

	func retrieveDataFromFirestore(completion: @escaping ([Order]?) -> Void) {
		db.collection("orders").getDocuments { (querySnapshot, error) in
			if let error = error {
				print("Error getting documents: \(error)")
				completion(nil)
				return
			}

			guard let documents = querySnapshot?.documents else {
				print("No documents found")
				completion(nil)
				return
			}

			var retrievedOrders: [Order] = []

			for document in documents {
				let data = document.data()

				guard let personName = data["person"] as? String,
					  let extraInfo = data["extraInformation"] as? String,
					  let dessertData = data["dessertOrder"] as? [[String: Any]] else {
					print("Could not parse order data")
					continue
				}

				let desserts = dessertData.compactMap { dessertDict -> Dessert? in
					guard let name = dessertDict["name"] as? String,
						  let description = dessertDict["description"] as? String,
						  let price = dessertDict["price"] as? Int,
						  let quantity = dessertDict["quantity"] as? Int else {
						return nil
					}

					return Dessert(name: name, description: description, price: price, quantity: quantity)
				}

				let order = Order(dessertOrder: desserts, person: personName, extraInformation: extraInfo)
				retrievedOrders.append(order)
			}

			completion(retrievedOrders)
		}
	}
}
