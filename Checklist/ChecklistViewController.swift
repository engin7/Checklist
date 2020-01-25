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
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = todoList.todos[indexPath.row].text
            }
        configureCheckmark(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // there might not be a cell at that point so use if let
        if let cell = tableView.cellForRow(at: indexPath){
             configureCheckmark(for: cell, at: indexPath)
                tableView.deselectRow(at: indexPath, animated: true) //remove highlighting
        }
    }
    
       func configureCheckmark (for cell: UITableViewCell, at indexPath: IndexPath) {
        let isChecked = todoList.todos[indexPath.row].checked
                   if isChecked {
                           cell.accessoryType = .none
                       } else {
                           cell.accessoryType = .checkmark
                 }
                    todoList.todos[indexPath.row].checked = !isChecked
            }
    }
