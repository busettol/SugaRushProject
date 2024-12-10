//
//  Order.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-09.
//

import Foundation

struct Order : Codable {
	let id = UUID()
	let date : Date = Date()

	var dessertOrder : [Dessert]
	let person : String
	let extraInformation : String
}
