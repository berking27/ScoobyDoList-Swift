//
//  AppDelegate.swift
//  ScoobyDoList
//
//  Created by Berkin Koca on 6.02.2023.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
     
     
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
          print(Realm.Configuration.defaultConfiguration.fileURL)
          
          do{
               let realm = try Realm()
               
          } catch{
               print("Error initialising new realm, \(error)")
          }
          
          
          return true
     }
     
     func applicationWillTerminate(_ application: UIApplication) {
          
          print("applicationWillTerminate")
          saveContext()
     }
     
     // MARK: UISceneSession Lifecycle
     
     func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
          return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
     }
     
     // MARK: - Core Data stack
     
     lazy var persistentContainer: NSPersistentContainer = {
          
          let container = NSPersistentContainer(name: "DataModel")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
               }
          })
          return container
     }()//From CoreDataTest AppDelegate.swift file
     
     // MARK: - Core Data Saving support
     
     func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
               do {
                    try context.save()
               } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
          }
     }//From CoreDataTest AppDelegate.swift file
}

