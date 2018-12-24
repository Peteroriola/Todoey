//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Peter Oriola on 10/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {

    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    
  
        override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
            //tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
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
    
    //MARK:- DELETE DATE FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
     
        if let categoryForDeletion = self.categories?[indexPath.row] {
         do {
             try self.realm.write {
               self.realm.delete(categoryForDeletion)
    }
     }catch {
       print("item not deleted\(error)")
}
        
    }
    }
    
    

    //mark:- Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
   
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
        let newCategory = Category()
        newCategory.name = textField.text!
        newCategory.colour = UIColor.randomFlat.hexValue()
        
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


