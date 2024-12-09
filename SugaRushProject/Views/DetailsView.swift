//
//  DetailsView.swift
//  SugaRushProject
//
//  Created by user269354 on 12/7/24.
//

import SwiftUI

struct DetailsView: View {
    let item: MenuItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 136/255, blue: 233/255).opacity(0.3).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        Spacer()
                    }
                    .padding()
                    
                    // Item Image
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(15)
                    
                    // Item Details
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("$\(String(format: "%.2f", item.price))")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(item.description)
                            .font(.body)
                        
                        // Ingredients
                        Text("Ingredients:")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            ForEach(item.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Text("•")
                                    Text(ingredient)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(15)
                }
                .padding()
            }
        }
    }
}


