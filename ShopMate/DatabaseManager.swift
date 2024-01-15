//
//  DatabaseManager.swift
//  My Orders
//
//  Created by שיראל זכריה on 19/12/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
//
import Firebase
import Combine

class DatabaseManager {
    
    static var shared = DatabaseManager()
    
    private var databaseRef = Database.database().reference()
    
    // MARK: - Reading data
    
    func fetchShoppingItems(path: String, completion: @escaping ([ShoppingItem]) -> ()) {
      
        let shoppingItemsRef = databaseRef.child(path)
        
        shoppingItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let value = snapshot.value as? [String: Any] else {
                print("No shoppingItems data found")
                completion([])
                return
            }
            
            var shoppingItems = [ShoppingItem]()
            for (_, itemData) in value {
                guard let shoppingItemDict = itemData as? [String: Any],
                      let shoppingItemID = shoppingItemDict["shoppingItemID"] as? String,
                      let name = shoppingItemDict["name"] as? String,
                      let quantity = shoppingItemDict["quantity"] as? Int,
                      let isChecked = shoppingItemDict["isChecked"] as? Bool,
                      let notes = shoppingItemDict["notes"] as? String,
                      let isHearted = shoppingItemDict["isHearted"] as? Bool
                else {
                    print("shoppingItem else called")
                    continue
                }
                
                let shoppingItem = ShoppingItem(
                    shoppingItemID: shoppingItemID,
                    name:  name,
                    quantity: quantity,
                    isChecked: isChecked,
                    notes: notes,
                    isHearted: isHearted
                )
                
                shoppingItems.append(shoppingItem)
            }
            completion(shoppingItems)
        })
    }
                                            
    // MARK: - Writing data
    
    func saveItem(_ item: ShoppingItem, path: String) {
        let itemRef = databaseRef.child(path).child(item.id)
        itemRef.setValue(item.dictionaryRepresentation())
        print("---> saved item")

    }
    
    // MARK: - Deleting data
    
    func deleteItem(itemID: String, path: String) {
        let itemRef = databaseRef.child(path).child(itemID)
        itemRef.removeValue()
    }

    
    // MARK: - Updating data
    
    func updateItemInDB(_ item: ShoppingItem, path: String, completion: @escaping (Bool) -> Void) {
        let itemRef = databaseRef.child(path)
        itemRef.updateChildValues(item.dictionaryRepresentation()) { error, _ in
            completion(error == nil)
        }
    }
    
    // MARK: - Helper Functions
    
    func convertStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    func convertStringToDateAndTime(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //HH:mm
        return dateFormatter.date(from: dateString)
    }

}
