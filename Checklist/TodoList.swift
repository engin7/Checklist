//
//  TodoList.swift
//  Checklist
//
//  Created by Engin KUK on 25.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistItem] = []
    private var mediumPriorityTodos: [ChecklistItem] = []
    private var lowPriorityTodos: [ChecklistItem] = []
    private var noPriorityTodos: [ChecklistItem] = []

    init() {
        
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        let row2Item = ChecklistItem()
        let row3Item = ChecklistItem()
        let row4Item = ChecklistItem()
        let row5Item = ChecklistItem()
        let row6Item = ChecklistItem()
        let row7Item = ChecklistItem()

        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        row2Item.text = "Code an app"
        row3Item.text = "Walk the dog"
        row4Item.text = "Study Chemistry"
        row5Item.text = "Study Algorithms"
        row6Item.text = "Skateboard"
        row7Item.text = "Swim"

        addTodo(row0Item, for: .medium)
        addTodo(row1Item, for: .low)
        addTodo(row2Item, for: .high)
        addTodo(row3Item, for: .no)
        addTodo(row4Item, for: .high)
        addTodo(row5Item, for: .no)
        addTodo(row6Item, for: .low)
        addTodo(row7Item, for: .high)

    }
    
    //convenience method to add
    func addTodo(_ item: ChecklistItem, for priority: Priority) {
        switch priority {
        case .high:
            return highPriorityTodos.append(item)
        case .medium:
           return mediumPriorityTodos.append(item)
        case .low:
           return lowPriorityTodos.append(item)
        case .no:
           return noPriorityTodos.append(item)
        }
    }
    
    //method to give list to people who access this class:
       
       func todoList(for priority: Priority) -> [ChecklistItem] {
         switch priority {
         case .high:
            return highPriorityTodos
         case .medium:
            return mediumPriorityTodos
         case .low:
            return lowPriorityTodos
         case .no:
            return noPriorityTodos
         }
       }
    
    // default priority will be mediumPriorityTodos
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.text = randomTitle()
        item.checked = true  //new items will be checked by default
        mediumPriorityTodos.append(item)
        return item
    }
    
    func move(item: ChecklistItem, to index: Int) {
//        guard let currentIndex = todos.firstIndex(of: item) else {
//            return
//        }
//        todos.remove(at: currentIndex)
//        todos.insert(item, at: index)
    }
      //new remove method
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int){
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }
    
    
    private func randomTitle() -> String {
        
        var titles = ["A", "B", "C", "D", "E"]
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
    
     
}
