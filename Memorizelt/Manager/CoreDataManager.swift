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
            if let error {
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
        flashcard.dueDate = Date()
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
    
    // Spaced Repetition Algorithm
    func updateFlashcardAfterReview(flashcard: Flashcard, correct: Bool) {
        var interval = flashcard.interval
        var easeFactor = flashcard.easeFactor
        
        if correct {
            // User answered correctly, increase interval
            interval = Int64(Double(interval) * easeFactor)
            easeFactor += 0.05
        } else {
            // User answered incorrectly, reset interval
            interval = 1
            easeFactor = max(1.3, easeFactor - 0.2)
        }
        
        flashcard.interval = max(1, interval)
        flashcard.easeFactor = max(1.3, easeFactor)
        flashcard.dueDate = Calendar.current.date(byAdding: .day, value: Int(interval), to: Date())
        
        saveContext()
    }
    
    // Fetch Flashcards Due for Review
    func fetchDueFlashcards() -> [Flashcard] {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        let predicate = NSPredicate(format: "dueDate <= %@", Date() as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching due flashcards: \(error)")
            return []
        }
    }
}






/*

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Flashcard")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
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
    
    
    func addFlashcard(question: String, answer: String, category: String) {
        let context = persistentContainer.viewContext
        let flashcard = Flashcard(context: context)
        flashcard.id = UUID()
        flashcard.question = question
        flashcard.answer = answer
        flashcard.category = category
        flashcard.creationDate = Date()
        saveContext()
    }
    
    func updateFlashcard(flashcard: Flashcard, question: String, answer: String, category: String?) {
        flashcard.question = question
        flashcard.answer = answer
        flashcard.category = category
        saveContext()
    }
    
    func deleteFlashcard(flashcard: Flashcard) {
        let context = persistentContainer.viewContext
        context.delete(flashcard)
        saveContext()
    }
    
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
}
*/
