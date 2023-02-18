//
//  ViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 6.02.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
     
     
     var toDoItems : Results<Item>?
     let realm = try! Realm()
     
     var selectedCategory : Category? {
          didSet{
               loadItems()
               tableView.rowHeight = 80.0
          }//when selected Category gets its value, inside curly braces will be done
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
          tableView.separatorStyle = .none
          
          viewWillAppear(true)
          
    
     }
     //NSAttributedString.Key
//     override func viewWillAppear(_ animated: Bool) {
//          if let colourHex = selectedCategory?.colour {
//               guard let navBar = navigationController?.navigationBar else{fatalError("Navigation Controller does not exist")}
//               navBar.backgroundColor = UIColor(hexString: colourHex)
//          }
//     }

     //MARK: - TableView Datasource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return toDoItems?.count ?? 1
     }//It means how many cell you are going to use
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
          //You create cell and identify its name which you gave in Main.storyboard
          if let item = toDoItems?[indexPath.row]{
               
               cell.textLabel?.text = item.title
               //You change Text label to items in array
               
               if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(toDoItems!.count))){
                    cell.backgroundColor = colour
                    cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
               }
               
               
               cell.accessoryType = item.done ? .checkmark : .none //Ternary Operator
               // value           = condition ?valueIfTrue : valueIfFalse
          } else{
               cell.textLabel?.text = "No Items Added"
          }
          return cell
          //You return to cell
     }
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          if let item = toDoItems?[indexPath.row] {
               do{
                    try realm.write{
                         item.done = !item.done
                    }
               } catch{
                    print("Error saving done status \(error)")
               }
          }
          tableView.reloadData()

          //toDoItems[indexPath.row].done = !itemArray[indexPath.row].done
          //It sets the opposite of what it is true->false
          
          //          saveItems()
          
          tableView.deselectRow(at: indexPath, animated: true)
          
     }
     
     //MARK: - Add New Items
     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          var textField = UITextField()
          let alert = UIAlertController(title: "Add New Scooby Do List", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add Item", style: .default) { action in
               //What will happen once the user clicks the Add Item Button on our UIAlert
               
               if let currentCategory = self.selectedCategory {
                    do{
                         try self.realm.write {
                              let newItem = Item()
                              newItem.title = textField.text!
                              newItem.dateCreated = Date() //get date as current date
                              currentCategory.items.append(newItem)
                         }
                    }catch{
                         print("Error Saving new items, \(error)")
                    }
               }
               self.tableView.reloadData()
          }
          
          alert.addTextField { (alertTextField) in
               alertTextField.placeholder = "Create new item"
               textField = alertTextField //alertTextField scope is just in this closure
          }
          
          alert.addAction(action)
          present(alert, animated: true,completion: nil)
     }
     //MARK: - Model Manupulation Methods
     
     func loadItems(){ //Read Data in CRUD
          toDoItems = selectedCategory?.items.sorted(byKeyPath: "title",  ascending: true)
          
          tableView.reloadData()
     }
     
     override func updateModel(at indexPath: IndexPath) {
          
          if let item = toDoItems?[indexPath.row] {
               do{
                    try realm.write{
                         realm.delete(item)
                    }
               } catch{
                    print("Error deleting done status \(error)")
               }
          } //You can Delete by using this method
     }
}
//MARK: - SearchBar Methods

extension ToDoListViewController : UISearchBarDelegate{
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          
          toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: false)
          
          tableView.reloadData()
     }
     //https://academy.realm.io/posts/nspredicate-cheatsheet/ NSPredicate Cheat Sheet
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchBar.text?.count == 0{
               loadItems()
               
               DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    //No more editing ->no longer keyboard
                    //Using DispatchQueue assings project into diffrent threads
               }
               
          }
          
          
     }
     
}

