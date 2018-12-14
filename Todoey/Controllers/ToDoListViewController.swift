//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Oriola on 06/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
   
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    loadItems()
        
        }

    
    //MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //Ternary operator: -
            cell.accessoryType = item.done ? .checkmark : .none
            
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
    }
    
    
    //MARK:- Tableview Delegete Method
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
       // toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
        //saveItems()
        
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
          //what will happen once the use clicks the Add item button on the UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.item.append(newItem)
                    }
                    
                } catch {
                    print("Error saving new items\(error)")
                }            }
            self.tableView.reloadData()
          
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
          
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Model Manupulation Methods
    
    
    func loadItems() {
        toDoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
    
    
}

//MARK:- Searchbar Methods

//extension ToDoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 //       let request : NSFetchRequest<Item> = Item.fetchRequest()
        
 //      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
 //       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
  //      loadItems(with: request, predicate: predicate )
    
//}
    
  //  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  //      if searchBar.text?.count == 0 {
  //          loadItems()
            
  //          DispatchQueue.main.async {
   //             searchBar.resignFirstResponder()
   //         }
   //     }
   // }
    
}
