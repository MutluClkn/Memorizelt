//
//  Texts.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 28.07.2024.
//

import Foundation

struct Texts {
    
    struct PrototypeTexts {
        static let dashboardInfo = "You have 3 cards to study today"
        static let pendingCategories = "English, Deneme, Math"
        
        static let reviewedCardText = "0 cards reviewed"
        static let totalCardText = "30 cards"
        
        static let backButtonText = "Back"
    }
    
    struct TabBar {
        static let houseIcon = "house"
        static let homeTitle = "Home"
        
        static let lanyardcardIcon = "lanyardcard"
        static let deckTitle = "Decks"
    }
    
    struct HomeScreen {
        static let title = "Dashboard"
        
        static let dashboardTitle = "Pending Studies"
        
        static let plusIcon = "plus"
        static let calendarIcon = "calendar"
        
        static let tableViewTitle = "Pending Cards"
        static let navigationTitle = "Dashboard"
    }
    
    struct AddNewCardScreen {
        static let closeIcon = "xmark"
        static let title = "Add Flashcard"
        
        static let categoryTitle = "Category"
        static let questionTitle = "Question"
        static let answerTitle = "Answer"
        
        static let saveButtonTitle = "Save"
        
        static let alertTitle = "Card Added Successfully"
        static let alertMessage = "Your new card has been added to the deck. Keep up the good work!"
        
        static let duplicateAlerTitle = "Duplicate"
        static let duplicateAlertMessage = "A flashcard with this question already exists in the selected category."
        
        static let unsavedChangesAlertTitle = "Unsaved Changes"
        static let unsavedChangesAlertMessage = "You have unsaved changes. Do you really want to close?"
    }
    
    struct DeckScreen {
        static let title = "Decks"
    }
    
    struct EditDeckScreen {
        static let backIcon = "chevron.backward"
    }
    
    struct EditFlashcardScreen {
        static let backIcon = "chevron.backward"
        
        static let alertTitle = "Flashcard Updated"
        static let alertMessage = "Your changes have been saved."
    }
    
    struct CardScreen {
        static let flipButtonIcon = "arrow.2.circlepath"
        
        static let againButtonTitle = "Again"
        static let hardButtonTitle = "Hard"
        static let goodButtonTitle = "Good"
        
        static let infoIcon = "info.circle"
        
        static let alerTitle = "Card Interaction Instructions"
        static let alertMessage = """
\nSlide Right: If you can answer the question, slide the card to the right.\n\n
Slide Left: If you cannot answer the question or find it difficult, slide the card to the left.\n\nFlip Card: Tap the "Flip Card" button to see the answer on the other side.\n\n
"""
    }
}
