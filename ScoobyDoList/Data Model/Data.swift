//
//  Data.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 12.02.2023.
//

import Foundation
import RealmSwift

class Data : Object { //Object -> Realm Class
     @objc dynamic var name : String = "" //while app running you can make changes
     @objc dynamic var age : Int = 0
     
}
