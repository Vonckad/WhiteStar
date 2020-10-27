//
//  Model.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 10/19/20.
//

import Foundation
import RealmSwift

//@objcMembers class ModelCategory: Object, Codable {
//
//}

struct ModelCategory: Decodable {
    
    var main: Category
    
    enum MyCodingKeys: String, CodingKey {
        case main = "67"
    }
    
    init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MyCodingKeys.self)
    
        self.main = try! container.decode(Category.self, forKey: .main)
        
    }
}

struct Category: Codable {
    var name: String
    var sortOrder: String
//    var image: UIImage
    var subcategories: [CategoryArray]
}

struct CategoryArray: Codable {
    var name: String
}


