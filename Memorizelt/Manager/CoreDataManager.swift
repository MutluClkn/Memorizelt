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
    
    func fetchFlashcards() -> [Flashcard] {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching flashcards: \(error)")
            return []
        }
    }
    
    func addFlashcard(question: String, answer: String, category: String) {
        let context = persistentContainer.viewContext
        let flashcard = Flashcard(context: context)
        flashcard.id = UUID()
        flashcard.question = question
        flashcard.answer = answer
        flashcard.category = category
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
    
    private func saveContext() {
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
