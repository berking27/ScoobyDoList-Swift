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
     
     var selectedCategory : Category? {
          didSet{
               loadItems()
          }//when selected Category gets its value, inside curly braces will be done
     }
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
          
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
          
          //          context.delete(itemArray[indexPath.row]) //You should call first
          //          itemArray.remove(at: indexPath.row)
          //Delete Codelines are above
          
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
               newItem.parentCategory = self.selectedCategory
               
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
     
     func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){ //Read Data in CRUD
          
          let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
          
          if let addtionalPredicate = predicate{
               request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
          }else {
               request.predicate = categoryPredicate
          }
          
          //We have external/internal parameter also at the and we add Default parameter by = Item.fetchRequest()
          do {
               itemArray = try context.fetch(request)
          } catch {
               print("Error fetching data from context \(error)")
          }
          tableView.reloadData()
     }
}
//MARK: - SearchBar Methods
extension ToDoListViewController : UISearchBarDelegate{
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          let request : NSFetchRequest<Item> = Item.fetchRequest()
          let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
          //https://academy.realm.io/posts/nspredicate-cheatsheet/ NSPredicate Cheat Sheet
          
          request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
          //Results come back
          
          loadItems(with: request, predicate: predicate)
          
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchBar.text?.count == 0{
               loadItems()
               
               DispatchQueue.main.async {
                    searchBar.resignFirstResponder() //No more editing ->no longer keyboard
                    //Using DispatchQueue assings project into diffrent threads
               }
               
          }
          
          
     }
     
     
     
}

