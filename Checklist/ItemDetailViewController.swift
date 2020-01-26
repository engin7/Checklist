 //
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Engin KUK on 25.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import UIKit

 protocol ItemDetailViewControllerDelegate: class{
    //if the calling viewcontroller needs to access AddItemTableViewController, we're not creating anything here, just let communicate
    func itemDetailViewControllerDidCancel( controller: ItemDetailViewController)
    // will get back ChecklistItem here
    func itemDetailViewController( controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
     func itemDetailViewController( controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
 }
 
class ItemDetailViewController: UITableViewController {

    weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textfield: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
         delegate?.itemDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textfield.text {
            item.text = text
            delegate?.itemDetailViewController(controller: self, didFinishEditing: item)
        } else {
            if let item = todoList?.newTodo() {
        if let textFieldText = textfield.text {
            item.text = textFieldText
        }
        item.checked = false
        delegate?.itemDetailViewController(controller: self, didFinishAdding: item)
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if segue selected to edit item do inside closures
        if let item = itemToEdit {
            // change screen title
            title = "Edit Item"
            // info at textfield will be displayed as item chosen
            textfield.text = item.text
            addBarButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        textfield.delegate = self
    }
  
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil  // we cant select the row now, we just want to edit it
    }
}

 extension ItemDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return false
    }
    //avoid empty entries
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textfield.text,
            let stringRange = Range(range, in: oldText) else {
          return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
            return true
    }
 }

 
 
