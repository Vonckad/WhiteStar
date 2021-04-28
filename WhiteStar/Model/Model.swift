//
//  Model.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 10/19/20.
//

import Foundation

struct RootModel: Decodable {

    var arrayCategory: [Category]
    
    private struct DynamicCodingKeys: CodingKey {
       
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

            var tempArray = [Category]()

            for key in container.allKeys {

                let decodedObjectInt = try container.decode(Category.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                tempArray.append(decodedObjectInt)
            }
        arrayCategory = tempArray
        }
}

struct Category: Decodable {
    let name: String
    let iconImage: String
    let subcategories: [CategoryArray]?
}

struct CategoryArray: Decodable {
    let id: NumerableString?
    let iconImage: String
    let name: String
    
    enum NumerableString: Codable {
        case string(String)
        case int(Int)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            if let x = try? container.decode(Int.self) {
                self = .int(x)
                return
            }
            throw DecodingError.typeMismatch(NumerableString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for NumerableString"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let x):
                try container.encode(x)
            case .int(let x):
                try container.encode(x)
            }
        }
        
        func getStringValue() -> String {
            switch self {
            case .string(let x):
                return x
            case .int(let x):
                return String(x)
            }
        }
    }
}
