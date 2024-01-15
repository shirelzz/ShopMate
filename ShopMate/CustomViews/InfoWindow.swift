//
//  InfoWindow.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI

struct InfoWindow: View {
    @Binding var isPresented: Bool
    @State private var text = ""

    var body: some View {
        VStack {
            // Text input field
            TextField("Enter text here", text: $text)

            // Display the entered text
            Text(text)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .overlay(
            Button(action: { isPresented = false }) {
                EmptyView()
            }
            .contentShape(Rectangle())
        )
    }
}

//#Preview {
//    InfoWindow()
//}
