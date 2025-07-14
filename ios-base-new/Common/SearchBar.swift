//
//  SearchBar.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 29/6/25.
//

import SwiftUI

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    let searchTextPlaceholder: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField(searchTextPlaceholder, text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.primary)

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    SearchBar()
//}
