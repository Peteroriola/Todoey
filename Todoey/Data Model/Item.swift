//
//  Item.swift
//  Todoey
//
//  Created by Peter Oriola on 13/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
}
