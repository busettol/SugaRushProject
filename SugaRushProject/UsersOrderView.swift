//
//  UsersOrderView.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-10.
//

import SwiftUI

struct UsersOrderView: View {
	private var ordervm: OrderViewModel = OrderViewModel()
	@State private var orderList: [Order] = []
	@State private var isFilter : Bool = false
	@State private var email : String = ""

	var body: some View {
		VStack {
			List {
				ForEach(orderList) { order in
					Section(header: Text("Order by \(order.person)")) {
						ForEach(order.dessertOrder, id: \.self) { dessert in
							
							if(isFilter && order.person == self.email){
								HStack {
									Text("\(dessert.quantity)x \(dessert.name)")
								}
							}else{
								HStack {
									Text("\(dessert.quantity)x \(dessert.name)")
								}
							}
						}
					}
				}
			}

			Button("See your orders"){
				isFilter = isFilter ? false : true
			}
		}
		.onAppear {
			Task {
				self.orderList = await ordervm.retrieveDataFromFirestore()

				if let email = ordervm.getSignedInUserEmail() {
					self.email = email
					print("Signed-in user's email: \(email)")
				} else {
					print("No user is signed in.")
				}
			}
		}
	}
}

#Preview {
	UsersOrderView()
}

