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
    
    required init?(coder aDecoder: NSCoder) {
       
        todoList = TodoList()
        
        super.init(coder: aDecoder )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        // there might not be a cell at that point so use if let
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true) //remove highlighting
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        //instead of indexpath its a shortcut to use with item:ChecklistItem  because indexpath simply getting ChecklistItem inside the function. Define it use in all functions.
        if let label = cell.viewWithTag(1000) as? UILabel {
        label.text = item.text
        }
    }
    
       func configureCheckmark (for cell: UITableViewCell, with item: ChecklistItem) {
                    if item.checked {
                           cell.accessoryType = .none
                       } else {
                           cell.accessoryType = .checkmark
                 }
                    item.toggleChecked() //put toggle func to Model instead of Controller
            }
    }
 
