//
//  CoreDataStorageContext.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorageContext: StorageContext {
    static let shared = CoreDataStorageContext()
    
    private init() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(applicationWillTerminate(notification:)),
                                                   name: UIApplication.willTerminateNotification,
                                                   object: nil)
    } // Prevent clients from creating another instance.

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc func applicationWillTerminate(notification: Notification) {
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

