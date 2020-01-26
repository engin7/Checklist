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
    
    @IBAction func addItem(_ sender: Any) {

        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo() //im not interested in using item will just add it
        let indexPath = IndexPath (row: newRowIndex, section: 0)
        // insert method requires an array of indexpaths
         let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [ChecklistItem]() //create array of ChecklistItems
            for indexPath in selectedRows {
                items.append(todoList.todos[indexPath.row])
            }
            todoList.remove(items: items)
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
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return  //because there was intersepting between didselectrow and editing
        }
        // there might not be a cell at that point so use if let
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
               item.toggleChecked()
             configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            //remove highlighting
        }
    }
    
    //swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//     tableView.reloadData()   easier but no animation, just reload
    }
    // we change constraints priority from 1000 to 750 not to have error. Because when we delete row it changes spacing.
    
   //move items:
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
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
        } else if segue.identifier == "EditItemSegue" {
         if let addItemViewController = segue.destination as? ItemDetailViewController {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let item = todoList.todos[indexPath.row]
                addItemViewController.itemToEdit = item
                addItemViewController.delegate = self  
                }
            }
        }
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
        let rowIndex = todoList.todos.count-1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    } 
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
