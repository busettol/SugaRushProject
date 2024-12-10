//
//  MenuViewModel.swift
//  SugaRushProject
//
//  Created by user269354 on 12/10/24.
//

import Foundation
import FirebaseFirestore

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchMenuItems()
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
