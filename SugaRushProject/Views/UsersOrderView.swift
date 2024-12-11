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


			if(orderList.count < 1){
				Text("Empty for now...")
			}
			else{
			List {
				ForEach(orderList) { order in

					


					Section{
						if(order.person == "User"){
							Text("This is a test dummy.")
						}
						
					ForEach(order.dessertOrder, id: \.self) { dessert in
							VStack{
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

						if(isFilter){
							VStack{
								Text("\(order.person)")
								Text("\(order.extraInformation)")
								Text("\(order.date)")

							}
						}
					}


				}
			}
		}

			Button("See your orders"){
				isFilter = isFilter ? false : true
			}
			Button("Clear orders"){
				ordervm.clearDatabase()
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
					DispatchQueue.main.async{
						//NotificationAlert.show(title: "Alert", message: "You're not signed in.")
					}
				}
			}
		}
	}
}

#Preview {
	UsersOrderView()
}

