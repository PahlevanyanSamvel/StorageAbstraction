//
//  CoreDataStorageContext+Extension.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStorageContext {
    
    func create<T>(_ model: T.Type, completion: @escaping ((Any) -> Void)) throws where T : Storable {
        let managedContext = self.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: model),
                                                         into:self.persistentContainer.viewContext)
        managedContext.insert(object)
        completion(object)
    }
    
    func save(object: Storable) throws {
        let managedContext = self.persistentContainer.viewContext
        managedContext.insert(object as! NSManagedObject)
        try? managedContext.save()
    }
    
    func save(object: [Storable]) throws {
        let managedContext = self.persistentContainer.viewContext
        for obj in object {
            managedContext.insert(obj as! NSManagedObject)
        }
        try? managedContext.save()
    }
    
    func update(block: @escaping () -> ()) throws {
        // Nothing to do
    }
}

extension CoreDataStorageContext {
    
    func delete(object: Storable) throws {
        let managedContext = self.persistentContainer.viewContext
        managedContext.delete(object as! NSManagedObject)
        try managedContext.save()
    }
    
    func delete(object: [Storable]) throws {
        let managedContext = self.persistentContainer.viewContext
        for obj in object {
            managedContext.delete(obj as! NSManagedObject)
        }
        try managedContext.save()
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        let managedContext = self.persistentContainer.viewContext
        managedContext.delete(model as! T as! NSManagedObject)
        try managedContext.save()
    }
    
    func reset() throws {
        let managedContext = self.persistentContainer.viewContext
        managedContext.reset()
        try managedContext.save()
        
    }
}

extension CoreDataStorageContext {
    
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: [Sorted]? = nil, completion: (([T]) -> ())) {
        let objects = getObjects(model, predicate: predicate, sorted: sorted)
        
        var accumulate: [T] = [T]()
        for object in objects {
            accumulate.append(object as! T)
        }
        
        completion(accumulate)
    }
    
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: [Sorted]? = nil) -> [T] {
        let objects = getObjects(model, predicate: predicate, sorted: sorted)
        
        var accumulate: [T] = [T]()
        for object in objects {
            accumulate.append(object as! T)
        }
        
        return accumulate
    }
    
    fileprivate func getObjects<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: [Sorted]? = nil) -> [NSManagedObject] {
        let managedContext = self.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: model))
        request.predicate = predicate
        request.sortDescriptors = sorted?.map({NSSortDescriptor(key: $0.key, ascending: $0.asc)})
        
        var result:[Any] = []
        do {
            result = try managedContext.fetch(request)
        } catch {
            return []
        }
        return result.map({$0 as! NSManagedObject})
    }
    
}


extension NSManagedObject: Storable {
    
}
