//
//  InfoOverlay.swift
//  ShopMate
//
//  Created by שיראל זכריה on 15/01/2024.
//
import SwiftUI

struct InfoOverlayView: View {
    @Binding var isPresented: Bool
//    @Binding var notes: String
    @State var notes: String = ""
    let item: ShoppingItem
    let width: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background tap area to dismiss
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 10) {
                // Title with item name
                Text(item.name)
                    .font(.headline)
                    .padding(.top)

                // Text field for notes
                TextField("Notes", text: $notes)
                    .padding()

                // Save button
                Button("Save") {
                    ShoppingList.shared.updateNotes(item: item, notes: notes)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .offset(x: 10, y: 10)
            .onAppear {
                notes = item.notes
            }

            // Arrow pointing to button
            Image(systemName: "arrow.down.circle")
                .foregroundColor(.white)
                .background(Color.black)
                .clipShape(Circle())
                .offset(x: 10, y: 10)
        }
    }
}


//#Preview {
//    InfoOverlay()
//}
