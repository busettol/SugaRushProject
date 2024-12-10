//
//  Order.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-09.
//

import Foundation

struct Order : Codable, Identifiable, Hashable {
	let id = UUID()
	let date : Date = Date()

	var dessertOrder : [Dessert]
	let person : String
	let extraInformation : String

	static func == (lhs: Order, rhs: Order) -> Bool {
			return lhs.id == rhs.id
	}
}
