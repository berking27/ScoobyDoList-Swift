//
//  CategoryViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 11.02.2023.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
     
     let realm = try! Realm()
     
     var categories : Results<Category>? //Better for User Experience and Safer!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
          loadCategories()
          
          tableView.separatorStyle = .none
          
          tableView.rowHeight = 80.0
          
     }
     
     
     
     //MARK: - TableView DataSource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return categories?.count ?? 1 //if it is not nil return categories.count if not return 1
          //this syntax called Nil Coalescing Operator
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
          
          cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
          
          cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
          
          //print(categories?[indexPath.row].colour)
          //#745EC4 Purple
          //#9AACD6 Light Blue
          return cell
          
     }
     
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          performSegue(withIdentifier: K.goItemCellIdentifier, sender: self)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let destinationVC = segue.destination as! ToDoListViewController
          
          if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedCategory = categories?[indexPath.row]
          }
          
     }
     //MARK: - Data Manupulation Methods
     //save data / load data CRUD
     func save(category : Category){
          do {
               try realm.write{
                    realm.add(category)
               }
          } catch {
               print("Error saving context \(error)")
          }
          self.tableView.reloadData()
     }
     
     func loadCategories(){
          categories = realm.objects(Category.self)
          tableView.reloadData()
     }
     
     //MARK: - Delete Data From Swipe
     override func updateModel(at indexPath: IndexPath) {
          
          super.updateModel(at: indexPath) //You can reach super class method 
          
          if let categoryForDeletion = categories?[indexPath.row] {
               do{
                    try realm.write{
                         realm.delete(categoryForDeletion)
                    }
               } catch{
                    print("Error deleting done status \(error)")
               }
          } //You can Delete by using this method
     }
     
     //MARK: - Add New Categories
     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          var textField = UITextField()
          let alert = UIAlertController(title: "Add New Scooby Category", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add", style: .default) { (action) in
               //What will happen once the user clicks the Add Item Button on our UIAlert
               let newCategory = Category()
               newCategory.name = textField.text!
               newCategory.colour = UIColor.randomFlat().hexValue()
               
               self.save(category: newCategory)
          }
          
          alert.addAction(action)
          alert.addTextField { (field) in
               textField.placeholder = "Create New Category"
               textField = field
          }
          present(alert,animated: true,completion: nil)
          
     }
     
}

