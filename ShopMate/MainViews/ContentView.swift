//
//  ContentView.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var shoppingList = ShoppingList.shared
    @State private var newItemName = ""
    @State private var newItemQuantity = ""
    @State private var isNameValid = true
    @State private var isInfoOverlayPresented = false
    
    @State private var inputText = ""
    @State private var selectedItem: ShoppingItem = ShoppingItem()
    @State private var selectedItem2Fav: ShoppingItem = ShoppingItem()
    @State private var selectedItem2Delete: ShoppingItem = ShoppingItem()
    @State private var addedToFavorites = false
    @State private var addFavoritesItemsPressed = false
    
    @State private var updatefavorites = false

    @State private var flag = false
    @State private var selectedItem2Check: ShoppingItem = ShoppingItem()

    @State private var items: [ShoppingItem] = []
    
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width - 32
        
        NavigationStack{
                        
            ZStack(alignment: .topTrailing) {
               
                //                AppOpenAdView(adUnitID: "ca-app-pub-3940256099942544/5575463023")
                // test:  ca-app-pub-3940256099942544/5575463023
                
                VStack (alignment: .leading, spacing: 10) {
                    
                    VStack{
                        
                        Image("aesthticYellow")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.top)
                            .opacity(0.3)
                            .frame(height: 20)
                        
                        HStack {
                            
                            Spacer(minLength: 10)
                            
                            Button(action: {
                                addFavoritesItemsPressed.toggle()
                                
                            }, label: {
                                Image(systemName: addFavoritesItemsPressed ? "heart.circle.fill" : "heart.circle")
                                    .foregroundColor(addFavoritesItemsPressed ? .accentColor : .black)
                                    .font(.system(size: 36))
//                                    .padding()
                            })
                            .onChange(of: addFavoritesItemsPressed) {
                                if addFavoritesItemsPressed {
                                    items = shoppingList.shoppingItems + shoppingList.getFavorites()
                                    items = Array(Set(items))
                                }
                                else {
                                    items = shoppingList.shoppingItems
                                }
                            }
                            .buttonStyle(.borderless)
                            .padding()
                                                        
                        }
//                        .padding(.top, 45)
                        
                    }
                }
            }

            //        }
            
            List {

                
                Section(header: Text("Add New Item")) {
                    HStack {
                        TextField("Name", text: $newItemName)
                            .onChange(of: newItemName) { _ in
                                validateName()
                            }
                        
                        TextField("Quantity", text: $newItemQuantity)
                            .keyboardType(.numberPad)
                        
                        Button(action: {
                            
                            let newItem = ShoppingItem(
                                
                                shoppingItemID: UUID().uuidString,
                                name: newItemName,
                                quantity: (Int)(newItemQuantity) ?? 0,
                                isChecked: false,
                                notes: "",
                                isHearted: false
                            )
                            
                            ShoppingList.shared.addItem(item: newItem)
                            
                            newItemName = ""
                            newItemQuantity = ""
                            
                        }, label: {
                            Text("Add")
                                .buttonBorderShape(.roundedRectangle)
                        })
                        .disabled(!isNameValid)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                Section(header: Text("Shopping List")) {
                    
                    ForEach(items) { item in
                        
                        HStack {
                            
                            Button {
                                selectedItem2Check = item
//                                selectedItem.isChecked.toggle()
                                flag = shoppingList.toggleCheck(item: selectedItem2Check)
                            } label: {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isChecked ? .accentColor : .black)
                            }
                            
//                            Button {
//                                selectedItem2Check.isChecked.toggle()
//                                selectedItem2Check = item
//
//                            } label: {
//                                Image(systemName: selectedItem2Check.isChecked ? "checkmark.circle.fill" : "circle")
//                                    .foregroundColor(selectedItem2Check.isChecked ? .accentColor : .black)
//                            }
//                            .onChange(of: selectedItem2Check.isChecked) {
//                                shoppingList.toggleCheck(item: item)
//                            }
//                            .buttonStyle(.bordered)

                            
                            Text(item.name)
                            
                            if item.isHearted {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 12))
                            }
                            
                            Spacer()
                            
                            
                            TextField("Quantity", text: Binding(
                                get: {
                                    item.quantity.description
                                },
                                set: { newValue in
                                    if let newQuantity = Int(newValue) {
                                        ShoppingList.shared.updateQuantity(item: item, newQuantity: newQuantity)
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .frame(width: width/6)
                            
                            // Inside ForEach loop
                            Button {
                                isInfoOverlayPresented = true
                                selectedItem = item
                                
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .buttonStyle(.borderless)
//                            .buttonStyle(.bordered)
//                            .buttonBorderShape(.circle)
//                            .cornerRadius(10)
                            
                        }
                        .contextMenu(ContextMenu(menuItems: {

                            
                            Button {
                                selectedItem2Fav = item
                                ShoppingList.shared.updateIsHearted(item: selectedItem2Fav)
                                updatefavorites.toggle()
                            } label: {
                                Text(item.isHearted ? "Remove from favorites" : "Add to favorites")
                            }
                            
                            Button {
                                selectedItem2Delete = item
                                ShoppingList.shared.deleteItem(item: selectedItem2Delete)
                            } label: {
                                Text("Delete")
                                    .foregroundColor(.red)
                            }
                            
                        }))
                                                
                    }
                    
                }
                
            }
            .overlay(content: {
                if isInfoOverlayPresented {
                    CustomDialog(isActive: $isInfoOverlayPresented, item: $selectedItem, title: "Details", buttonTitle: "Save")
                }
            })
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu {
                        
                        HStack {
                            NavigationLink(destination: FavoritesView()) {
                                Label("Favorites", systemImage: "heart")
                            }
                        }
                        
                        HStack {
                            NavigationLink(destination: SettingsView()) {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .font(.system(size: 22))
                            .shadow(color: .black.opacity(0.3) ,radius: 6)
                            
                    }
                }
            }
            .onAppear {
                items = shoppingList.shoppingItems
            }
//            .onChange(of: shoppingList.shoppingItems, {
//                
//                if addFavoritesItemsPressed {
//                    items = shoppingList.shoppingItems + shoppingList.getFavorites()
//                    items = Array(Set(items))
//                }
//                else {
//                    items = shoppingList.shoppingItems
//                }
//            })
//            .onChange(of: updatefavorites, {
//                items = shoppingList.shoppingItems
//            })
            .navigationTitle("Hello")
            
            AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                .frame(height: 50)
                .background(Color.white)
            
            // here
        }
        
        
    }
    
    private func validateName() {
        isNameValid = newItemName != ""
    }
}

#Preview {
    ContentView()
}
