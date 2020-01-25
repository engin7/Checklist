 //
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Engin KUK on 25.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    
    @IBOutlet weak var textfield: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {        navigationController?.popViewController(animated: true)
        
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
    
 }

 
 
