//
//  Category.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 12.02.2023.
//

import Foundation
import RealmSwift

class Category : Object{
     @objc dynamic var name : String = ""
     @objc dynamic var colour : String = ""
     let items = List<Item>()
}
