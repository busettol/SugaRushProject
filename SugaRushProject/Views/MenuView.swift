//
//  MenuView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// Updated MenuItem struct to conform to Codable for Firebase
struct MenuItem: Identifiable, Codable {
    let id: String
    let imageName: String
    let name: String
    let price: Double
    let description: String
    let ingredients: [String]
    var userEmail: String? = nil
    
    // Initialize with a custom ID
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

// View Model to handle Firebase operations
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    private let db = Firestore.firestore()
    
    init() {
        deleteAllMenuItems()
        fetchMenuItems()
    }
    
    func deleteAllMenuItems() {
        db.collection("menuItems").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            for document in querySnapshot!.documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        print("Document successfully removed")
                    }
                }
            }
        }
    }
    
    func fetchMenuItems() {
        db.collection("menuItems").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching menu items: \(error.localizedDescription)")
                return
            }
            
            self.menuItems = querySnapshot?.documents.compactMap { document in
                do {
                    return try document.data(as: MenuItem.self)
                } catch {
                    print("Error decoding menu item: \(error)")
                    return nil
                }
            } ?? []
        }
    }
    
    func addMenuItem(_ item: MenuItem) {
        do {
            // Convert MenuItem to dictionary for Firestore
            let _ = try db.collection("menuItems").document(item.id).setData(from: item)
        } catch {
            print("Error adding menu item: \(error.localizedDescription)")
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
                    
                    Rectangle()
                        .fill(Color(red: 250/255, green: 160/255, blue: 160/255))
                        .frame(height: 100)
                }
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            // Optionally add initial menu items if the database is empty
            addInitialMenuItemsIfNeeded()
        }
    }
    
    private func addInitialMenuItemsIfNeeded() {
        let initialItems = [
            MenuItem(imageName: "spec0", name: "Classic Blueberry Muffin", price: 4.99,
                     description: "A soft, fluffy muffin bursting with fresh blueberries and a hint of vanilla",
                     ingredients: ["Flour", "Sugar", "Eggs", "Butter", "Blueberries", "Baking Powder", "Vanilla Extract"]),
            
            MenuItem(imageName: "spec1", name: "Butter Croissant", price: 7.50,
                     description: "Delicate, flaky French-style croissant with a golden, buttery exterior",
                     ingredients: ["Flour", "Butter", "Yeast", "Salt", "Milk", "Eggs"]),
            
            MenuItem(imageName: "spec2", name: "New York Cheesecake", price: 9.99,
                     description: "Rich and creamy classic cheesecake with a graham cracker crust",
                     ingredients: ["Cream Cheese", "Sugar", "Eggs", "Sour Cream", "Vanilla", "Graham Cracker Crust"]),
            
            MenuItem(imageName: "spec3", name: "Chocolate Eclair", price: 6.50,
                     description: "Delicate pastry filled with vanilla cream and topped with chocolate glaze",
                     ingredients: ["Choux Pastry", "Vanilla Cream", "Chocolate", "Eggs", "Butter", "Milk"]),
            
            MenuItem(imageName: "spec4", name: "Apple Danish", price: 5.50,
                     description: "Flaky pastry filled with cinnamon-spiced apple compote",
                     ingredients: ["Flour", "Butter", "Apples", "Cinnamon", "Sugar", "Yeast"])
        ]
        
        // Add each item to Firestore if it doesn't already exist
        let viewModel = MenuViewModel()
        initialItems.forEach { item in
            viewModel.addMenuItem(item)
        }
    }
}

#Preview {
    MenuView()
}
