//
//  Order.swift
//  Restaurant
//
//  Created by Charudut Shetty on 4/28/19.
//  Copyright © 2019 Charudut Shetty. All rights reserved.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
