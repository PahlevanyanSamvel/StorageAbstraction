//
//  CoreDataUser+CoreDataProperties.swift
//  StorageAbstraction
//
//  Created by Samvel on 11/24/19.
//  Copyright © 2019 Samo. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreDataUser: UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataUser> {
        return NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var createdDate: Date?

    var fullName: String {return (firstName ?? "") + " " + (lastName ?? "")}

}
