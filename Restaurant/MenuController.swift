//
//  MenuController.swift
//  Restaurant
//
//  Created by Charudut Shetty on 4/28/19.
//  Copyright © 2019 Charudut Shetty. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
    
    static let shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    let baseURL = URL(string: "http://localhost:8090")!
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                JSONSerialization.jsonObject(with: data) as? [String:Any],
                let categories = jsonDictionary["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
                print("hello")
            }
            
        }
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: [Int]] = ["menuIds":menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try?
                    jsonDecoder.decode(PreparatonTime.self, from: data) {
                        completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage (data: data){
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    
}


