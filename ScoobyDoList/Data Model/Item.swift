//
//  Item.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 12.02.2023.
//

import Foundation
import RealmSwift

class Item : Object{
     @objc dynamic var title : String = ""
     @objc dynamic var done : Bool = false
     @objc dynamic var dateCreated : Date?
     var parentCategory = LinkingObjects(fromType: Category.self, property : "items")//Relation that each item has parent category
}
