//
//  ModelCreationVC.swift
//  StorageAbstraction
//
//  Created by Samvel on 11/24/19.
//  Copyright © 2019 Samo. All rights reserved.
//

import UIKit

class ModelCreationVC: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var currentStorageType = StorageManager.currentStorageType
    var storageContext: StorageContext!
    var data:[Storable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch currentStorageType {
        case .realm:
            storageContext = RealmStorageContext.shared
        case .coreData:
            storageContext = CoreDataStorageContext.shared
        }
        tableView.keyboardDismissMode = .onDrag
        refreshList()
    }
    
    @IBAction func createBtn(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName  = lastNameTextField.text,  !lastName.isEmpty else {return}
        
        createNewUser(firstName: firstName, lastName: lastName)
        refreshList()
        clearFields()
    }
    
    func clearFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    func refreshList() {
        let sort = [Sorted(key: "createdDate", asc: false)]
        data = currentStorageType == .realm ? storageContext.fetch(RealmUser.self, sorted: sort)
                                            : storageContext.fetch(CoreDataUser.self, sorted: sort)
        tableView.reloadData()
        
    }
    
    func createNewUser(firstName:String, lastName: String) {

        switch StorageManager.currentStorageType {
        case .realm:
            try? storageContext.create(RealmUser.self, completion: { (user) in
                guard let user = user as? RealmUser else {return}
                user.firstName = firstName
                user.lastName = lastName
                try? self.storageContext.save(object: user)
            })
        case .coreData:
            try? storageContext.create(CoreDataUser.self, completion: { (user) in
                guard let user = user as? CoreDataUser else {return}
                user.firstName = firstName
                user.lastName = lastName
                user.createdDate = Date()
                try? self.storageContext.save(object: user)
            })

        }
        
    }
    
}

extension ModelCreationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = data[indexPath.row] as! UserData
        
        cell.textLabel?.text = user.fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [.init(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            try? self.storageContext.delete(object: self.data[indexPath.row])
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        })]
    }
    
}
