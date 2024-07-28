//
//  Texts.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 28.07.2024.
//

import Foundation

struct Texts {
    
    struct PrototypeTexts {
        static let dashboardTitle = "Pending Studies"
        static let dashboardInfo = "You have 3 cards to study today"
        static let pendingCategories = "English, Deneme, Math"
        
        static let reviewedCardText = "2 cards reviewed"
        static let totalCardText = "30 cards"
    }
    
    struct TabBar {
        static let houseIcon = "house"
        static let homeTitle = "Home"
        
        static let lanyardcardIcon = "lanyardcard"
        static let deckTitle = "Decks"
    }
    
    struct HomeScreen {
        static let plusIcon = "plus"
        static let calendarIcon = "calendar"
        
        static let tableViewTitle = "Pending Cards"
        static let navigationTitle = "Dashboard"
    }
    
    struct AddNewCardScreen {
        static let closeIcon = "xmark"
        
        static let categoryTitle = "Category"
        static let questionTitle = "Question"
        static let answerTitle = "Answer"
        
        static let saveButtonTitle = "Save"
        
        static let alertTitle = "Card Added Successfully"
        static let alertMessage = "Your new card has been added to the deck. Keep up the good work!"
    }
    
    struct CardScreen {
        static let flipButtonIcon = "arrow.2.circlepath"
        
        static let againButtonTitle = "Again"
        static let hardButtonTitle = "Hard"
        static let goodButtonTitle = "Good"
        
        static let infoIcon = "info.circle"
        
        static let alerTitle = "Button Instructions"
        static let alertMessage = """
\nAgain: Press if you couldn't answer the question.\n\n
Hard: Press if the question was difficult to answer.\n\n
Good: Press if you answered the question correctly.\n\n
"""
    }
    
    struct EditFlashcarScreen {
        static let alertTitle = "Flashcard Updated"
        static let alertMessage = "Your changes have been saved."
    }
    
}
