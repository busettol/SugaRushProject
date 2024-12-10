//
//  MenuView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// Updated MenuItem struct to match Firebase document structure
struct MenuItem: Identifiable, Codable {
    let id: String
    let imageName: String
    let name: String
    let price: Double
    let description: String
    let ingredients: [String]
    var userEmail: String? = nil
    
    // Initializer to handle decoding from Firestore
    init(id: String = UUID().uuidString, imageName: String, name: String, price: Double, description: String, ingredients: [String], userEmail: String? = nil) {
        self.id = id
        self.imageName = imageName
        self.name = name
        self.price = price
        self.description = description
        self.ingredients = ingredients
        self.userEmail = userEmail
    }
}

// View Model to handle Firebase interactions
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchMenuItems()
    }
    
    func fetchMenuItems() {
        db.collection("menuItems").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching menu items: \(error.localizedDescription)")
                return
            }
            
            self.menuItems = querySnapshot?.documents.compactMap { document in
                let data = document.data()
                return MenuItem(
                    id: document.documentID,
                    imageName: data["imageName"] as? String ?? "placeholder",
                    name: data["name"] as? String ?? "Unknown Item",
                    price: data["price"] as? Double ?? 0.0,
                    description: data["description"] as? String ?? "",
                    ingredients: data["ingredients"] as? [String] ?? []
                )
            } ?? []
            
            print("Fetched \(self.menuItems.count) menu items")
        }
    }
}

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var col1 = Color(red: 255/255, green: 136/255, blue: 233/255)
    @State private var col2 = Color(red: 249/255, green: 195/255, blue: 195/255)
    
    var body: some View {
        NavigationView {
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
                    
                    Text("OUR MENU")
                        .font(.title)
                        .padding()
                    
                    if viewModel.menuItems.isEmpty {
                        Text("No menu items found")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.menuItems) { item in
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
                    }
                    
                    Rectangle()
                        .fill(Color(red: 250/255, green: 160/255, blue: 160/255))
                        .frame(height: 100)
                }
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MenuView()
}
