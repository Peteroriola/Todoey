//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Oriola on 06/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    loadItems()
        tableView.separatorStyle = .none
        
        
        }

    override func viewWillAppear(_ animated: Bool) {
        if let colourHex  = selectedCategory?.colour {
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exit.")}
        
        navBar.barTintColor = UIColor(hexString: colourHex)
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColour
                
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                searchBar.barTintColor = navBarColour
            }
          
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    
    //MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                    cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
       
            
            
            //Ternary operator: -
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
    }
    
    
    //MARK:- Tableview Delegete Method
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                
                try realm.write {
                   // realm.delete(item)
                    
                item.done = !item.done
                }
            }catch {
                print("Error saving done property\(error)")
            }
        }
        tableView.reloadData()
        
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
                        newItem.dateCreated = Date()
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("item not deleted\(error)")
            }
        }
    }
    
}
//MARK:- Searchbar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
}
    
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchBar.text?.count == 0 {
          loadItems()
            
          DispatchQueue.main.async {
             searchBar.resignFirstResponder()
         }
     }
 }
    
}
