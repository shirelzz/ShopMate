//
//  FavoritesView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI

struct FavoritesView: View {
    
    var favoriteItems: [ShoppingItem] = ShoppingList.shared.getFavorites()
    @State private var isInfoOpen = false
    @State private var addedToFavorites = true
    @State private var inputText = ""

    var body: some View {
        
        let width = UIScreen.main.bounds.width - 32
        ZStack(alignment: .topTrailing) {
            
            VStack (alignment: .leading, spacing: 10) {
                
                VStack{
                    
                    Image("yellowHearts")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.top)
                        .opacity(0.4)
                        .frame(height: 20)
                    
                    HStack {
                        
                        //                            Spacer()
                        
                        Text(" Favorites")
                            .font(.largeTitle)
                            .bold()
                        //                                .padding(.leading)
                        
                        Spacer(minLength: 10)
                        
                    }
                    .padding(.top, 45)
                    
                }
                
                List {

                    ForEach(favoriteItems) { item in
                        
                        HStack {
                            
                            Text(item.name)
                            
                            Spacer()
                            
                            Text(item.quantity.description)
                            Text("isInfoOpen: \(isInfoOpen.description)")

                            Button {
                                isInfoOpen.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .popover(isPresented: $isInfoOpen, attachmentAnchor: .rect(.bounds), arrowEdge: .top) { //
                                VStack {
                                    // Text input field
                                    TextField("Enter text", text: $inputText)
                                        .padding()
                                    
                                    // Close button
                                    Button("Save") {
                                        ShoppingList.shared.updateNotes(item: item, notes: inputText)
                                        inputText = ""
                                        //                                    isInfoOpen.toggle()
                                    }
                                    .padding()
                                    .buttonStyle(.borderedProminent)
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .frame(width: width, height: 100)
                                .padding()
                                
                            }
                            .onDisappear(perform: {
                                isInfoOpen.toggle()
                            })
                        }
                        .contextMenu(ContextMenu(menuItems: {
                            
                            Button {
                                addedToFavorites.toggle()
                                ShoppingList.shared.updateIsHearted(item: item, isHearted: addedToFavorites)
                            } label: {
                                Text(addedToFavorites ? "Remove from favorites" : "Add to favorites")
                            }
                            
                        }))
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
}
