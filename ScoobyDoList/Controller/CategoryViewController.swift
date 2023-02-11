//
//  CategoryViewController.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 11.02.2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
     
     var categories = [Category]()
     
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
     override func viewDidLoad() {
          super.viewDidLoad()
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
          loadCategories()
          
     }
     
     
     //MARK: - TableView DataSource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return categories.count
     }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier , for: indexPath)
          
          let category = categories[indexPath.row]
          
          cell.textLabel?.text = category.name
          
          return cell
          
     }
     //MARK: - Add New Categories
     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          var textField = UITextField()
          let alert = UIAlertController(title: "Add New Scooby Category", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add", style: .default) { (action) in
               //What will happen once the user clicks the Add Item Button on our UIAlert
               let newCategory = Category(context: self.context)
               newCategory.name = textField.text!
               
               self.categories.append(newCategory)
               //Save Categories
               do {
                    try self.context.save()
               }catch{
                    print("Error saving context \(error)")
               }
               self.tableView.reloadData()
          }
          
          alert.addAction(action)
          alert.addTextField { (field) in
               textField.placeholder = "Create New Category"
               textField = field
          }
          present(alert,animated: true,completion: nil)
          
     }
     //MARK: - Data Manupulation Methods
     //save data / load data CRUD
     func SaveCategories(){
          do {
               
               try context.save()
          } catch {
               print("Error saving context \(error)")
          }
          
          self.tableView.reloadData()
     }
     
     func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
          do{
               categories = try context.fetch(request)
          }catch {
               print("Error Fetching data from context \(error)")
               tableView.reloadData()
          }
     }
     
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          performSegue(withIdentifier: K.goItemCellIdentifier, sender: self)
     }
}
