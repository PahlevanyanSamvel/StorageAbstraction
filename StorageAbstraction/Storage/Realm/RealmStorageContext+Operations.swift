//
//  RealmStorageContext+Operations.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import Foundation
import RealmSwift

extension Object: Storable {}

extension RealmStorageContext {
    
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((Any) -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let date = Date()
            let newObject = realm.create(model as! Object.Type, value: ["createdDate": Date(),"id": "\(date.timeIntervalSince1970)"], update: .modified) as! T
            completion(newObject)
        }
    }
    
    func save(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            let obj = (object as! Object)
            realm.add(obj, update: .modified)
        }
    }
    
    func save(object: [Storable]) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let objs = (object as! [Object])
            realm.add(objs, update: .modified)
        }
    }
    
    
    func update(block: @escaping () -> Void) throws {
        try self.safeWrite {
            block()
        }
    }
}

extension RealmStorageContext {
    
    func delete(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.delete(object as! Object)
        }
    }
    
    func delete(object: [Storable]) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.delete(object as! [Object])
        }
    }
    
    
    func deleteAll<T : Storable>(_ model: T.Type) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let objects = realm.objects(model as! Object.Type)
            
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    func reset() throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.deleteAll()
        }
    }
}

extension RealmStorageContext {

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
    
    fileprivate func getObjects<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: [Sorted]? = nil) -> [Object] {
        guard var objects = self.realm?.objects(model as! Object.Type) else {return []}
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted = sorted {
            let sortDescriptor = sorted.map({SortDescriptor(keyPath: $0.key, ascending: $0.asc)})
            objects = objects.sorted(by: sortDescriptor)
        }
        
        return Array(objects)
    }
    
}

