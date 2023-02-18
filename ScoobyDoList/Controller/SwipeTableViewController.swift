//
//  SwipeViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 14.02.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController , SwipeTableViewCellDelegate{
     
     var cell : UITableViewCell?
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          
     }
     //TableView Datasource Methods
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! SwipeTableViewCell
          
          cell.delegate = self
          
          return cell
          
     }
     
     
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
          
          guard orientation == .right else { return nil }
          
          let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               // handle action by updating model with deletion
               print("Delete Cell")
               
               self.updateModel(at: indexPath)
               
               
               
          }
          // customize the action appearance
          deleteAction.image = UIImage(named: "delete-icon")
          
          return [deleteAction]
     }
     
     func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
          var options = SwipeTableOptions()
          options.expansionStyle = .destructive
          return options
     }
     
     func updateModel(at indexPath: IndexPath){
          //Update our data model
          print("Item Deleted from super class")
     }
     
     
}
