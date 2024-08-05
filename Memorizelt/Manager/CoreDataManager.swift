//
//  CoreDataManager.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Flashcard")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    // Fetch Flashcards Grouped by Category
    func fetchFlashcardsGroupedByCategory() -> [String: [Flashcard]] {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        var flashcardsByCategory = [String: [Flashcard]]()
        
        do {
            let flashcards = try persistentContainer.viewContext.fetch(fetchRequest)
            for flashcard in flashcards {
                if let category = flashcard.category {
                    if flashcardsByCategory[category] != nil {
                        flashcardsByCategory[category]?.append(flashcard)
                    } else {
                        flashcardsByCategory[category] = [flashcard]
                    }
                }
            }
        } catch {
            print("Error fetching flashcards: \(error)")
        }
        
        return flashcardsByCategory
    }
    
    
    // Fetch Flashcards for Home Screen
    func fetchFlashcardsForHome() -> [Flashcard] {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isNew == YES"),
            NSPredicate(format: "nextReviewDate <= %@", Date() as NSDate)
        ])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching flashcards: \(error)")
            return []
        }
    }
    
    
    // Add Flashcard
    func addFlashcard(question: String, answer: String, category: String) {
        let context = persistentContainer.viewContext
        let flashcard = Flashcard(context: context)
        flashcard.id = UUID()
        flashcard.question = question
        flashcard.answer = answer
        flashcard.category = category
        flashcard.creationDate = Date()
        flashcard.interval = 1
        flashcard.easeFactor = 2.5
        flashcard.lastReviewedDate = Date()
        flashcard.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        flashcard.isReviewed = false
        flashcard.isNew = true
        saveContext()
    }
    
    // Update Flashcard
    func updateFlashcard(flashcard: Flashcard, question: String, answer: String, category: String?) {
        flashcard.question = question
        flashcard.answer = answer
        flashcard.category = category
        saveContext()
    }
    
    // Delete Flashcard
    func deleteFlashcard(flashcard: Flashcard) {
        let context = persistentContainer.viewContext
        context.delete(flashcard)
        saveContext()
    }
    
    // Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
    // Update Flashcard after Review
    func updateFlashcardAfterReview(flashcard: Flashcard, correct: Bool) {
        var interval = flashcard.interval
        var easeFactor = flashcard.easeFactor
        
        if correct {
            interval = Int64(Double(interval) * easeFactor)
            easeFactor += 0.05
        } else {
            interval = 1
            easeFactor = max(1.3, easeFactor - 0.2)
        }
        
        flashcard.interval = max(1, interval)
        flashcard.easeFactor = max(1.3, easeFactor)
        flashcard.lastReviewedDate = Date()
        flashcard.nextReviewDate = Calendar.current.date(byAdding: .day, value: Int(interval), to: Date())
        flashcard.isReviewed = true
        flashcard.isNew = false
        
        saveContext()
    }
    
    // Fetch Flashcards Due for Review
    func fetchDueFlashcards() -> [Flashcard] {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        let predicate = NSPredicate(format: "nextReviewDate <= %@", Date() as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching due flashcards: \(error)")
            return []
        }
    }
    
    // Check if a Flashcard Exists with the Given Question and Category
    func doesFlashcardExist(question: String, category: String) -> Bool {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        let questionPredicate = NSPredicate(format: "question == %@", question)
        let categoryPredicate = NSPredicate(format: "category == %@", category)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [questionPredicate, categoryPredicate])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let matchingFlashcards = try persistentContainer.viewContext.fetch(fetchRequest)
            return !matchingFlashcards.isEmpty
        } catch {
            print("Error checking if flashcard exists: \(error)")
            return false
        }
    }
}
