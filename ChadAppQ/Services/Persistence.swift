//
//  Persistence.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    // Initialising class variables
    init() {
        container = NSPersistentContainer(name: "ChadAppQ")
        context = container.viewContext
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // Common saving process
    func save() {
        do {
            try context.save()
        } catch {
            print("Save Error")
        }
    }
    
    // Adding a row in the entity
    func saveQuestion(que: String, id: UUID, parent: UUID?) {
        let question = Questions(context: self.context)
        question.id = id
        question.parent = parent
        question.que = que
        question.created = Date()
        save()
    }
}
