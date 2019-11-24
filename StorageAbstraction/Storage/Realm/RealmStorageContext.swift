//
//  RealmStorageContext.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStorageContext: StorageContext {
    
    var realm: Realm?
    
    static let shared = RealmStorageContext()
    
    private init() {
        realm = try? Realm()
    }
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
        
        realm.refresh()
    }
    
}


