//
//  CoreDataManager.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 18/02/2022.
//

import Foundation
import CoreData
class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDBHomeWork")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("something went wrog")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
