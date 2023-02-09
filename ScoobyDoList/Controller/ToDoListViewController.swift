//
//  ViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 6.02.2023.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
     
     
     var itemArray = [Item]()
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
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
               
               let newItem = Item(context: self.context)
               newItem.title = textField.text!
               newItem.done = false
               
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
          
          do {
               
               try context.save()
          } catch {
               print("Error saving context \(error)")
          }
          
          self.tableView.reloadData() //It will update your Table Cells
          //After you click Add Item this line will execute too
          
     }
     
     func loadItems(){ //Read Data in CRUD
          let request : NSFetchRequest<Item> = Item.fetchRequest()//NSFetchRequest in Item data type
          do {
               itemArray = try context.fetch(request)
          } catch {
               print("Error fetching data from context \(error)")
          }
     }
}



