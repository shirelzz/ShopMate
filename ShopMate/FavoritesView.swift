//
//  FavoritesView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI

struct FavoritesView: View {
    
    @State private var favoriteItems: [ShoppingItem] = ShoppingList.shared.getFavorites()
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
                    
//                    HStack {
//                        
//                        //                            Spacer()
//                        
//                        Text(" Favorites")
//                            .font(.largeTitle)
//                            .bold()
//                        //                                .padding(.leading)
//                        
//                        Spacer(minLength: 10)
//                        
//                    }
//                    .padding(.top, 45)
                    
                }
                
                List {

                    ForEach(favoriteItems) { item in
                        
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
                                    ShoppingList.shared.updateIsHearted(item: selectedItem2Fav)

                                }
                            } label: {
                                Text(item.isHearted ? "Remove from favorites" : "Add to favorites")
                            }
                            
                        }))
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
}

#Preview {
    FavoritesView()
}
