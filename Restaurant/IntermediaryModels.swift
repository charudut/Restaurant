//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Charudut Shetty on 4/28/19.
//  Copyright © 2019 Charudut Shetty. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparatonTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
