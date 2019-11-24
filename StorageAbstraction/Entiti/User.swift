//
//  RealmUser.swift
//  StorageAbstraction
//
//  Created by Samvel on 10/28/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import RealmSwift

class RealmUser: Object, UserData {
    
    @objc dynamic var firstName:String!
    @objc dynamic var lastName:String!
    @objc dynamic var createdDate:Date!
    // etc.
    @objc dynamic var id: String!
    override class func primaryKey() -> String? { return "id"}
    
    var fullName: String {return firstName + " " + lastName}
    
}









