 //
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Engin KUK on 25.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import UIKit

 protocol AddItemViewControllerDelegate: class{
    //if the calling viewcontroller needs to access AddItemTableViewController, we're not creating anything here, just let communicate
    func addItemViewControllerDidCancel( controller: AddItemTableViewController)
    // will get back ChecklistItem here
    func addItemViewController( controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
 }
 
class AddItemTableViewController: UITableViewController {

    weak var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textfield: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done(_ sender: Any) {        navigationController?.popViewController(animated: true)
        let item = ChecklistItem()
        if let textFieldText = textfield.text {
            item.text = textFieldText
        }
        item.checked = false
        delegate?.addItemViewController(controller: self, didFinishAdding: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

 extension AddItemTableViewController: UITextFieldDelegate {
    
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

 
 
