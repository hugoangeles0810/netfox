//
//  NFXCoreDataController.swift
//  netfox
//
//  Created by Hugo Ángeles Chávez on 8/15/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation
import CoreData

class NFXCoreDataController {
    
    static let sharedInstance = NFXCoreDataController(modelName: "Netfox")
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        let bundle = Bundle(for: NFXCoreDataController.self)
        let url = bundle.url(forResource: modelName, withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: url!)
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model!)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
}
