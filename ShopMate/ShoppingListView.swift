//
//  ShoppingListView.swift
//  My Orders
//
//  Created by שיראל זכריה on 12/01/2024.
//

import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var shoppingList: ShoppingList
    @State private var newItemName = ""
    @State private var newItemQuantity = ""
    @State private var isNameValid = true
    @State private var isQuantityValid = true

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Item")) {
                    HStack {
                        TextField("Name", text: $newItemName)
                            .onChange(of: newItemName) { oldValue, newValue in
                                    validateName()
                            }
                        TextField("Quantity", text: $newItemQuantity)
                            .keyboardType(.numberPad)
                            .onChange(of: newItemQuantity) { oldValue, newValue in
                                validateQuantity()
                            }
                        
                        Button(action: {
                            
                            let newItem = ShoppingItem(
                                
                                shoppingItemID: UUID().uuidString,
                                name: newItemName,
                                quantity: (Double)(newItemQuantity) ?? 0,
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
                            Text("Quantity: \(item.quantity)")
                        }
                    }
                }
            }
            .navigationTitle("Shopping List")
        }
    }
    
    private func validateName() {
        isNameValid = newItemName != ""
    }
    
    private func validateQuantity() {
        isQuantityValid = Double(newItemQuantity) ?? 0 > 0
    }

}

