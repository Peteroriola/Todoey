//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Peter Oriola on 10/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    
  
        override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
        
    }

    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added yet"
        
        return cell

    }
     //MARK:- TableView Delegates Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    
    
    }
    
    
    
    //MARK:- TableView Manupulation
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category \(error)")
        }
       tableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
         tableView.reloadData()
    }
    
    
    //mark:- Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
   
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
        let newCategory = Category()
        newCategory.name = textField.text!
        
        
        self.save(category: newCategory)
    }
    
    alert.addAction(action)
        alert.addTextField { (field) in
          textField = field
            textField.placeholder = "Add New Category"
        }
    
        present(alert, animated: true, completion: nil)
        
   
    

 }
    
}
