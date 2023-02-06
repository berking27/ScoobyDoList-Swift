//
//  ViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 6.02.2023.
//

import UIKit

class ToDoListViewController: UITableViewController {
     
     
     var itemArray = ["Find Mike","Buy Eggos","Destroy Demogorgon"]
     
     let defaults = UserDefaults.standard
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          
          if let items =  defaults.array(forKey: K.ItemForKey) as? [String] {
               itemArray = items
          }
          
     }
     
     //MARK: - TableView Datasource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return itemArray.count
     }//It means how many cell you are going to use
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
          //You create cell and identify its name which you gave in Main.storyboard
          
          cell.textLabel?.text = itemArray[indexPath.row]
          //You change Text label to items in array
          
          return cell
          //You return to cell
     }
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print(itemArray[indexPath.row])
          
          
          if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
               tableView.cellForRow(at: indexPath)?.accessoryType = .none
          }else{
               tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
          }//You are add/remove chechmarks by clicking
          
          tableView.deselectRow(at: indexPath, animated: true)
          
     }//When you select table cell you're going to print it
     //MARK: - Add New Items
     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          var textField = UITextField()
          let alert = UIAlertController(title: "Add New Scooby Do List", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add Item", style: .default) { action in
               //What will happen once the user clicks the Add Item Button on our UIAlert
               
               self.itemArray.append(textField.text!)
               self.defaults.set(self.itemArray, forKey: K.ItemForKey)
               self.tableView.reloadData() //It will update your Table Cells
               //After you click Add Item this line will execute too
          }
          
          alert.addTextField { (alertTextField) in
               alertTextField.placeholder = "Create new item"
               textField = alertTextField //alertTextField scope is just in this closure
          }
          
          alert.addAction(action)
          present(alert, animated: true,completion: nil)
     }
}



