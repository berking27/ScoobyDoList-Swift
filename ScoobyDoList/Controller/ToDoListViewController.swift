//
//  ViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 6.02.2023.
//

import UIKit

class ToDoListViewController: UITableViewController{
     
     
     var itemArray = [Item]()
     
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          print("File Path: \(dataFilePath!)")
          
          loadItems()
     }
     
     
     //MARK: - TableView Datasource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return itemArray.count
     }//It means how many cell you are going to use
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          
          let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
          //You create cell and identify its name which you gave in Main.storyboard
          let item = itemArray[indexPath.row]
          
          cell.textLabel?.text = item.title
          //You change Text label to items in array
          
          cell.accessoryType = item.done ? .checkmark : .none //Ternary Operator
          // value           = condition ?valueIfTrue : valueIfFalse
          
          
          return cell
          //You return to cell
     }
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done //It sets the opposite of what it is true->false
          
          saveItems()
          
          tableView.deselectRow(at: indexPath, animated: true)
          
     }//When you select table cell you're going to print it
     //MARK: - Add New Items
     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          var textField = UITextField()
          let alert = UIAlertController(title: "Add New Scooby Do List", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add Item", style: .default) { action in
               //What will happen once the user clicks the Add Item Button on our UIAlert
               
               var newItem = Item()
               newItem.title = textField.text!
               
               self.itemArray.append(newItem)
               self.saveItems()
               
          }
          
          alert.addTextField { (alertTextField) in
               alertTextField.placeholder = "Create new item"
               textField = alertTextField //alertTextField scope is just in this closure
          }
          
          alert.addAction(action)
          present(alert, animated: true,completion: nil)
     }
     //MARK: - Model Manupulation Methods
     
     func saveItems(){
          let encoder = PropertyListEncoder()
          
          do {
               let data = try encoder.encode(itemArray)
               try data.write(to: dataFilePath!)
          } catch {
               print("Error encoding item array \(error)")
          }
          
          self.tableView.reloadData() //It will update your Table Cells
          //After you click Add Item this line will execute too
          
     }
     
     func loadItems(){
          if let data = try? Data(contentsOf: dataFilePath!) {
               let decoder = PropertyListDecoder()
               do{
                    itemArray = try decoder.decode([Item].self, from: data)
               } catch {
                    print("Error decoding item array \(error)")
               }
          }
     }
}





