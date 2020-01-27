//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Engin KUK on 25.01.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import Foundation

    //NSObject adds ability to compare items
class ChecklistItem: NSObject {
    
    @objc var text = ""
    var checked = false
    
    func toggleChecked(){        
        checked = !checked
    }
}
