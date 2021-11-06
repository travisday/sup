//
//  SearchBar.swift
//  KeepFit
//
//  Created by following the tutorial at: https://www.appcoda.com/swiftui-search-bar/
//
//

import SwiftUI

// I followed/edited a tutorial to get this search bar - I'm not sure if that's allowed

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditingSearch = false
 
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8) // Height of bar
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        // X button to clear search
                        if isEditingSearch {
                            Button(action: { self.text = "" }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10) // Width of bar
                .onTapGesture {
                    self.isEditingSearch = true
                }
        }
    }
    
   
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

