//
//  File.swift
//  Checklist
//
//  Created by Engin KUK on 22.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    
    //this method takes an index number and returns priority. cast a number into an enumaration
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    
    @IBAction func addItem(_ sender: Any) {

        let newRowIndex = todoList.todoList(for: .medium).count
        _ = todoList.newTodo() //im not interested in using item will just add it
        let indexPath = IndexPath (row: newRowIndex, section: 0)
        // insert method requires an array of indexpaths
         let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
             for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section){
                    let todos = todoList.todoList(for: priority)
                    //make sure you're not out of bounds
                    let rowToDelete = indexPath.row > todos.count-1 ? todos.count-1 : indexPath.row
                    let item = todos[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
             }
             tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        todoList = TodoList()
        
        super.init(coder: aDecoder )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        //by default tableView doesnt allow you to choose multiple rows
        tableView.allowsMultipleSelectionDuringEditing = true
       
    }
    // enable editing mode:
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
     
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
            return 0
    }
      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
       // let item = todoList.todos[indexPath.row] since we're switching to new model:
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    //disable all segues during editing mode
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return  //because there was intersepting between didselectrow and editing
        }
        // there might not be a cell at that point so use if let
        if let cell = tableView.cellForRow(at: indexPath){
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todoList.todoList(for: priority)
                let item = items[indexPath.row]
                   item.toggleChecked()
                 configureCheckmark(for: cell, with: item)
                    tableView.deselectRow(at: indexPath, animated: true)
                //remove highlighting
            }
            
        }
    }
    
    //swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row)
         let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        }
     }
    // we change constraints priority from 1000 to 750 not to have error. Because when we delete row it changes spacing.
    
   //move items:
   
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
        let destPriority = priorityForSectionIndex(destinationIndexPath.section){
            
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at:sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
            
        }
        
        
        tableView.reloadData()
    }
    
    
    
    // By subclassing Tableview cells we dont need to worry about tags change
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        //instead of indexpath its a shortcut to use with item:ChecklistItem  because indexpath simply getting ChecklistItem inside the function. Define it use in all functions.
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
       func configureCheckmark (for cell: UITableViewCell, with item: ChecklistItem) {
                  
        guard let checkmarkCell = cell as? ChecklistTableViewCell  else {
                            return
                        }
                if item.checked {
                    checkmarkCell.checkmarkLabel.text = "√"
                } else {
                    checkmarkCell.checkmarkLabel.text = ""
                 }
         
            }
    
    // if segue happens do this...
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
       // get destination ViewController
            if let addItemViewController = segue.destination as? ItemDetailViewController  {
            addItemViewController.delegate = self
            addItemViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue"  {
         if let addItemViewController = segue.destination as? ItemDetailViewController {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let priority = priorityForSectionIndex(indexPath.section)
            {
                let item = todoList.todoList(for: priority)[indexPath.row]
                addItemViewController.itemToEdit = item
                addItemViewController.delegate = self  
                }
            }
        }
    }
    
    //Section methods for TableView below:
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
      
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        //we already have the item inside the array so use -1 we deleted previouse append because our model was not in sync.
        // we are also creating a new item in TodoList. 
        let rowIndex = todoList.todoList(for: .medium).count-1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    } 
     
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        //findout what priority this checklist located in by looping throug
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            //see if that item in the list if so return
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
             switch priority {
            case .high:
               title = "High Priority Todos"
            case .medium:
               title = "Medium Priority Todos"
            case .low:
               title = "Low Priority Todos"
            case .no:
               title = "No Priority Todos"
            }
        }
    return title
}
}
