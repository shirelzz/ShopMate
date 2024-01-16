//
//  CustomDialog.swift
//  ShopMate
//
//  Created by שיראל זכריה on 15/01/2024.
//

import SwiftUI

struct CustomDialog: View {
    @Binding var isActive: Bool
    @Binding var item: ShoppingItem
    @State private var inputText = ""
    @State private var formattedText: AttributedString = AttributedString("")
    @State private var links: [URL] = []

    let title: String
    let buttonTitle: String
    @State private var offset: CGFloat = 1000

    var body: some View {

        ZStack {
            Color(.black)
                .opacity(0.4)
                .onTapGesture {
                    close()
                }

            VStack(spacing: 10)  {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                    .foregroundStyle(.gray)
                
                URLClickableTextView(text: $inputText)
                .onAppear {
                    if item.notes.isEmpty{
                        inputText = "Enter text"
                    }
                    else {
                        inputText = item.notes
                    }
                }

                Button {
                    action()
                    close()
                } label: {
                    
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .frame(height: 50)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(20) //30
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
//                    offset = UIScreen.main.bounds.height / 4
                    offset = 0
                }
            }

        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // For full-screen coverage
    }
    
    func action() {
        
    }

    func close() {
//        item.notes = inputText
        ShoppingList.shared.updateNotes(item: item, notes: inputText)
        print("--- on close")
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
}

