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
    
//    @State private var newQuantity = ""
    @State private var addedToFavorites = false
    
    enum PopoverState {
        case closed
        case opened(item: ShoppingItem)
    }
    @State private var popoverState: PopoverState = .closed
    
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
                            .opacity(0.4)
                            .frame(height: 20)
                        
                        HStack {
                            
//                            Spacer()
                            
                            Text("   Hello User")
                                .font(.largeTitle)
                                .bold()
//                                .padding(.leading)
                            
                            Spacer(minLength: 10)
                            
                        }
                        .padding(.top, 45)
                        
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
                        })
                        .disabled(!isNameValid)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                Section(header: Text("Shopping List")) {
                    
                    ForEach(shoppingList.shoppingItems) { item in

                        HStack {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isChecked ? .accentColor : .black)
                                .onTapGesture {
                                    shoppingList.toggleCheck(item: item)
                                    
                                }
                            
                            Text(item.name)

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
                            .frame(width: width/5)
                            
                            // Inside ForEach loop
                            Button {
                                isInfoOverlayPresented = true
                                selectedItem = item

                            } label: {
                                Image(systemName: "info.circle")
                            }
//                            .sheet(isPresented: $isInfoOverlayPresented, content: {
//                                InfoOverlayView(isPresented: $isInfoOverlayPresented, item: item, width: width)
//                                    .frame(height: 100)
//                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .background(.white)
                           
                           



//                            Button {
//                                isInfoOpen = true
//                            } label: {
//                                Image(systemName: "info.circle")
//                            }

//                            .popover(isPresented: $isInfoOpen, attachmentAnchor: .rect(.bounds), arrowEdge: .top) { //
//                                VStack {
//                                    // Text input field
//                                    TextField("Enter text", text: $inputText)
//                                        .padding()
//                                    
//                                    // Close button
//                                    Button("Save") {
//                                        ShoppingList.shared.updateNotes(item: item, notes: inputText)
//                                        isInfoOpen.toggle()
//                                    }
//                                    .padding()
//                                    .buttonStyle(.borderedProminent)
//                                }
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .frame(width: width, height: 100)
//                                .padding()
//                                
//                            }
//                            .buttonStyle(.bordered)
//                            .buttonBorderShape(.circle)

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
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu {
                        
                        HStack {
                            NavigationLink(destination: FavoritesView()) {
                                Label("Favorites", systemImage: "heart")
                            }
                        }
                        
//                        HStack {
//                            NavigationLink(destination: SettingsView()) {
//                                Label("Settings", systemImage: "gear")
//                            }
//                        }
                        
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
            
        }
        
        if isInfoOverlayPresented {
            CustomDialog(isActive: $isInfoOverlayPresented, item: $selectedItem, title: "Details", buttonTitle: "Save")            
        }
    }
    
    private func validateName() {
        isNameValid = newItemName != ""
    }
}

#Preview {
    ContentView()
}
