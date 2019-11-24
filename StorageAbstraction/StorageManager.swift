//
//  StorageManager.swift
//  StorageAbstraction
//
//  Created by Samvel on 9/12/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import Foundation

enum StorageType:Int {
    case realm = 0
    case coreData = 1
}

class StorageManager {
    
    static var currentStorageType: StorageType {
        get {
            return StorageType(rawValue: UserDefaults.standard.integer(forKey: "StorageType")) ?? .realm
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "StorageType")
            UserDefaults.standard.synchronize()
        }
    }
    
}
