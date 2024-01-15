//
//  ShoppingList.swift
//  My Orders
//
//  Created by שיראל זכריה on 12/01/2024.
//

import Foundation
import FirebaseAuth

struct ShoppingItem: Codable, Identifiable, Hashable {
    
    var id: String { shoppingItemID }
    var shoppingItemID: String
    var name: String
    var quantity: Int
    var isChecked: Bool
    var notes: String
    var isHearted: Bool
    
    init() {
        self.shoppingItemID = ""
        self.name = ""
        self.quantity = 0
        self.isChecked = false
        self.notes = ""
        self.isHearted = false

    }
    
    init(shoppingItemID: String, name: String, quantity: Int, isChecked: Bool, notes: String, isHearted: Bool) {
        self.shoppingItemID = shoppingItemID
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
        self.notes = notes
        self.isHearted = isHearted

    }
    
    func dictionaryRepresentation() -> [String: Any] {

        let ShoppingItemDict: [String: Any] = [
            
            "shoppingItemID": shoppingItemID,
            "name": name,
            "quantity": quantity,
            "isChecked": isChecked,
            "notes": notes,
            "isHearted": isHearted

        ]
        return ShoppingItemDict
    }
    
    init?(dictionary: [String: Any]) {
        
        guard let shoppingItemID = dictionary["shoppingItemID"] as? String,
              let name = dictionary["name"] as? String,
              let quantity = dictionary["quantity"] as? Int,
              let isChecked = dictionary["isChecked"] as? Bool,
              let notes = dictionary["notes"] as? String,
              let isHearted = dictionary["isHearted"] as? Bool
        else {
            return nil
        }
        self.shoppingItemID = shoppingItemID
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
        self.notes = notes
        self.isHearted = isHearted
    }
}

class ShoppingList: ObservableObject {
    
    static var shared = ShoppingList()
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var favShoppingItems: [ShoppingItem] = []
    private var isUserSignedIn = Auth.auth().currentUser != nil
    var timer: Timer?

    init() {
        if isUserSignedIn{
            fetchShoppingItems()
        }
        else {
            loadShoppingItemsFromUD()
            loadFavShoppingItemsFromUD()
        }
    }
    
    func fetchShoppingItems() {
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            print("Current UserID: \(userID)")
            let path = "users/\(userID)/shoppingList"

            DatabaseManager.shared.fetchShoppingItems(path: path, completion: { fetchedShoppingItems in

                DispatchQueue.main.async {
                    self.shoppingItems = fetchedShoppingItems
                    print("Success fetching shoppingItems")
                }


            })
            
            let favPath = "users/\(userID)/favShoppingList"

            DatabaseManager.shared.fetchShoppingItems(path: favPath, completion: { fetchedFavShoppingItems in

                DispatchQueue.main.async {
                    self.favShoppingItems = fetchedFavShoppingItems
                    print("Success fetching fav shoppingItems")
                }

            })
        }
    }
    
    func saveItem2DB(_ item: ShoppingItem) {
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let path = "users/\(userID)/shoppingList"
            DatabaseManager.shared.saveItem(item, path: path)
        }
    }
    
    func deleteItemFromDB(itemID: String) {
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let path = "users/\(userID)/shoppingList"
            DatabaseManager.shared.deleteItem(itemID: itemID, path: path)
        }
    }
    
    func deleteFavItemFromDB(itemID: String) {
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let path = "users/\(userID)/favShoppingList"
            DatabaseManager.shared.deleteItem(itemID: itemID, path: path)
        }
    }
    
    func addItem(item: ShoppingItem) {
        shoppingItems.append(item)
        if isUserSignedIn{
            saveItem2DB(item)
        }
        else{
            saveItems2UD()
            saveFavItems2UD()
        }
    }
    
    private func saveItems2UD() {
        if let encodedData = try? JSONEncoder().encode(Array(shoppingItems)) {
            UserDefaults.standard.set(encodedData, forKey: "shoppingItems")
            print("success decoding shopping items! save")
        }
        else{
            print("Error decoding shopping items save")
        }
    }
    
    private func saveFavItems2UD() {
        if let encodedData = try? JSONEncoder().encode(Array(favShoppingItems)) {
            UserDefaults.standard.set(encodedData, forKey: "favShoppingItems")
            print("success decoding fav shopping items! save")
        }
        else{
            print("Error decoding fav shopping items save")
        }
    }
    
    // load items from UserDefaults
    func loadShoppingItemsFromUD() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingItems"),
           let decodedItems = try? JSONDecoder().decode([ShoppingItem].self, from: savedData) {
            shoppingItems = decodedItems
            print("success decoding shoppingItems! load")
        }
        else{
            print("Error decoding shoppingItems load")
        }
    }
    
    func loadFavShoppingItemsFromUD() {
        if let savedData = UserDefaults.standard.data(forKey: "favShoppingItems"),
           let decodedItems = try? JSONDecoder().decode([ShoppingItem].self, from: savedData) {
            favShoppingItems = decodedItems
            print("success decoding fav shoppingItems! load")
        }
        else{
            print("Error decoding fav shoppingItems load")
        }
    }
    
//    func toggleCheck(item: ShoppingItem) {
//        if let index = shoppingItems.firstIndex(where: { $0.id == item.id }) {
//            shoppingItems[index].isChecked.toggle()
//            print("--->Item checked: \(shoppingItems[index].isChecked)")
//            updateIsChecked(item: item, newState: shoppingItems[index].isChecked)
//        }
//        
//        if item.isChecked {
//            timer?.invalidate()
//            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
//                self?.deleteItem(item: item)
//            }
//            print("--->Timer started")
//        }
//        
//    }
    
    func toggleCheck(item: ShoppingItem) -> Bool {
        var isChecked = false
        if let index = shoppingItems.firstIndex(where: { $0.id == item.id }) {
            shoppingItems[index].isChecked.toggle()
            isChecked = shoppingItems[index].isChecked
            updateIsChecked(item: item, newState: shoppingItems[index].isChecked)
        }
        
//        updateIsChecked(item: item, newState: item.isChecked)
        print("---> item isChecked: \(item.isChecked.description)")

        if isChecked { //
            // Invalidate any existing timer to avoid multiple deletions
            timer?.invalidate()

            // Create a new timer to delete the item after 5 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
                // Use a strong reference to self within the closure
                guard let self = self else { return }
                self.deleteItem(item: item)
                self.timer = nil  // Clear the timer reference
            }
        } else {
            // If the item is unchecked, invalidate the timer to prevent deletion
            timer?.invalidate()
            timer = nil  // Clear the timer reference
        }
        
        return isChecked
    }
    
    func deleteItem(item: ShoppingItem) {
//        if let index = shoppingItems.firstIndex(of: item) {
        if let index = shoppingItems.firstIndex(where: { $0.id == item.id && $0.isChecked }) {
            print("--->Deleting item: \(item.name)")

            shoppingItems.remove(at: index)
            if isUserSignedIn{
                deleteItemFromDB(itemID: item.shoppingItemID)
            }
            else{
                saveItems2UD()
            }
            
            // If the item is removed, cancel the timer
            timer?.invalidate()
        }
    }
    
    func removeFavItem(item: ShoppingItem) {
        if let index = favShoppingItems.firstIndex(where: { $0.id == item.id}) {
            print("---> Deleting fav item: \(item.name)")

            favShoppingItems.remove(at: index)
            if isUserSignedIn{
                deleteFavItemFromDB(itemID: item.shoppingItemID)
            }
            else{
                saveFavItems2UD()
            }
        }
    }
    
    func updateIsChecked(item: ShoppingItem, newState: Bool) {
        if let index = shoppingItems.firstIndex(of: item) {
            shoppingItems[index].isChecked = newState
            
            updateItem(index: index)

        }
    }
    
    func updateNotes(item: ShoppingItem, notes: String) {
        if let index = shoppingItems.firstIndex(of: item) {
            shoppingItems[index].notes = notes
            
            updateItem(index: index)

        }
    }
    
    func updateIsHearted(item: ShoppingItem) {
        if let index = shoppingItems.firstIndex(of: item) {
            shoppingItems[index].isHearted.toggle()
            
            if shoppingItems[index].isHearted {
                updateItem(index: index)
            }
            else {
                removeFavItem(item: item)
            }

        }
        
        if !favShoppingItems.contains(item){
            
            if let currentUser = Auth.auth().currentUser {
                let userID = currentUser.uid
                let path = "users/\(userID)/favShoppingList"
                DatabaseManager.shared.saveItem(item, path: path)
            }
        }
    }
    
    func updateQuantity(item: ShoppingItem, newQuantity: Int) {
        if let index = shoppingItems.firstIndex(of: item) {
            shoppingItems[index].quantity = newQuantity
            
            updateItem(index: index)
        }
    }
    
    private func updateItem(index: Array<ShoppingItem>.Index) {
        if isUserSignedIn {
            if let currentUser = Auth.auth().currentUser {
                let userID = currentUser.uid
                
                var folder = ""
                
                if shoppingItems[index].isHearted {
                    folder = "favShoppingList"
                    let favPath = "users/\(userID)/\(folder)/\(shoppingItems[index].shoppingItemID)"
                    DatabaseManager.shared.updateItemInDB(shoppingItems[index], path: favPath) { success in
                        if !success {
                            print("updating in the database failed (update fav shopping item)")
                        }
                    }
                }
                else {
                    folder = "shoppingList"
                }
                
                let path = "users/\(userID)/shoppingList/\(shoppingItems[index].shoppingItemID)"
                DatabaseManager.shared.updateItemInDB(shoppingItems[index], path: path) { success in
                    if !success {
                        print("updating in the database failed (update shopping item)")
                    }
                }
            }
        } else {
            saveItems2UD()
        }
    }
    
    func getFavorites() -> [ShoppingItem] {
        fetchShoppingItems()
        return favShoppingItems
    }
}

