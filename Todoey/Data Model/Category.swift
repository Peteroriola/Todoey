//
//  Category.swift
//  Todoey
//
//  Created by Peter Oriola on 13/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let item = List<Item>()
    
}
