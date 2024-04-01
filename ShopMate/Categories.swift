//
//  Categories.swift
//  ShopMate
//
//  Created by שיראל זכריה on 31/03/2024.
//

import Foundation

let categories = [
    "dairy": ["milk", "cheese", "yogurt", "butter", "heavy cream", "eggs", "sour cream",
              "whipped cream", "cream cheese", "buttermilk", "cottage cheese", "margarine", "condensed milk"],
    
    "meats": ["chicken", "beef", "pork", "sausage", "bacon", "lamb", "turkey",
              "ham", "veal", "duck", "venison", "rabbit", "quail", "goose"],
    
    "fish": ["salmon", "tuna", "trout", "cod", "sardines", "halibut", "mackerel",
             "tilapia", "catfish", "swordfish", "anchovies", "haddock",
             "perch", "crab"],
    
    "vegetables": ["carrots", "lettuce", "tomatoes", "cucumbers", "onions", "ginger",
                   "chilli peppers", "potatoes", "broccoli", "spinach", "zucchini",
                   "sweet potatoes", "celery", "bell peppers", "mushrooms", "asparagus",
                   "green beans", "cauliflower", "artichokes", "radishes", "kale"],
    
    "fruit": ["apples", "bananas", "oranges", "strawberries", "grapes",
              "pineapple", "watermelon", "lemons", "kiwi", "peaches", "plums",
              "nectarines", "cherries", "blueberries", "raspberries", "mangoes",
              "papayas", "figs", "dates", "passion fruit"],
    
    "spices": ["cumin", "salt", "black pepper", "paprika", "chilli flakes", "cinnamon",
               "garlic powder", "oregano", "thyme", "nutmeg", "coriander"],
    
    "pharm": ["lotion", "soap", "shampoo", "conditioner", "toothbrush", "toothpaste",
              "dental floss", "vitamins", "pain reliever", "band-aids", "allergy medication",
              "antibacterial wipes", "hand sanitizer", "cotton balls", "mouthwash",
              "sunscreen"],
    
    "baking": ["aluminum foil", "flour", "sugar", "baking powder", "yeast", "vanilla extract",
               "chocolate chips", "cake mix", "cocoa powder", "baking soda", "food coloring"],
    
    "cleaning": ["paper towels", "laundry detergent", "trash bags", "dish soap", "glass cleaner",
                 "surface cleaner", "broom", "mop", "cleaning gloves", "scrub brushes",
                 "sponges", "disinfectant spray", "vacuum cleaner", "carpet cleaner"],
    
    "household": ["batteries", "light bulbs", "extension cords", "tape measure", "screwdriver set",
             "duct tape", "matches", "fire extinguisher", "smoke detectors", "flashlights",
             "hammer", "pliers", "safety goggles"],
    
    "office": ["printer paper", "pens", "notebooks", "stapler", "paper clips", "pencils",
               "scissors", "sticky notes", "ink", "folders", "calculator", "whiteboard",
               "binder clips", "rubber bands"],
    
    "pet": ["dog food", "cat litter", "pet toys", "leash", "pet shampoo", "pet treats",
            "pet beds", "pet brush", "collar",],
    
    "alcohol": ["beer", "wine", "vodka"],

    "baby": ["diapers", "baby wipes", "baby food", "baby lotion", "teething toys"],

    "canned & packaged": ["coconut milk", "condensed tomato", "crushed tomatoes"],

    "other": ["backpack", "umbrella", "ziplock bags", "bug spray"]
]




func getCategory(for item: String) -> String {
    for (category, items) in categories {
        if items.contains(item.lowercased()) {
            return category
        }
    }
    return "other" // No category found for the item
}
