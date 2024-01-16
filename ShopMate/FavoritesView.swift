//
//  FavoritesView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject private var shoppingList = ShoppingList.shared
//    @State private var favoriteItems: [ShoppingItem] = ShoppingList.shared.getFavorites()
    @State private var isInfoOpen = false
    @State private var addedToFavorites = true
    @State private var inputText = ""
    @State private var selectedItem: ShoppingItem = ShoppingItem()
    @State private var selectedItem2Fav: ShoppingItem = ShoppingItem()

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
                    
                }
                
                List {
                    
                    if currentFavShoppingItems.isEmpty {
                        
                        Text("No favorite items yet")
                    }
                    else {
                        
                        ForEach(currentFavShoppingItems) { item in
                            
                            HStack {
                                
                                Text(item.name)
                                
                                Spacer()
                                
                                //                            Text(item.quantity.description)
                                
                                Button {
                                    isInfoOpen = true
                                    selectedItem = item
                                    
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                                .buttonStyle(.borderless)
                                
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                
                                Button {
                                    selectedItem2Fav = item
                                    if selectedItem2Fav.isHearted {
                                        shoppingList.updateIsHearted(item: selectedItem2Fav)
                                        
                                    }
                                } label: {
                                    Text(item.isHearted ? "Remove from favorites" : "Add to favorites")
                                        .foregroundStyle(item.isHearted ? .red : .black)
                                }
                                
                            }))
                        }
                    }
                }
                .overlay(content: {
                    if isInfoOpen {
                        CustomDialog(isActive: $isInfoOpen, item: $selectedItem, title: "Details", buttonTitle: "Save")
                    }
                })
//                .onChange(of: ShoppingList.shared.getFavorites()) {
//                    favoriteItems = ShoppingList.shared.getFavorites()
//                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    var currentFavShoppingItems: [ShoppingItem] {
        return shoppingList.getFavorites()
    }
}

#Preview {
    FavoritesView()
}
