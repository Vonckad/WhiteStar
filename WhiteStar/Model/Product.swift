//
//  Product.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 11/12/20.
//

import Foundation

struct RootProduct: Decodable {

    var arrayProduct: [Product]
    
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

            var tempArray = [Product]()

            for key in container.allKeys {

                var decodedObjectInt = try container.decode(Product.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                decodedObjectInt.idProduct = key.stringValue
                tempArray.append(decodedObjectInt)
            }
        arrayProduct = tempArray
        }
}

struct Product: Decodable {
    var idProduct: String?
    let name: String
    let mainImage: String
    let oldPrice: String?
    let price: String
    let description: String
    let colorName: String
    let productImages: [ProductImages]
    let offers: [Offers]?
}

struct ProductImages: Decodable {
    let imageURL: String
}
struct Offers: Decodable {
    let size: String
}

