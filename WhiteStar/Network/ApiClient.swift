//
//  AlamofireLoader.swift
//  HomeWork_12_Carthage
//
//  Created by Vlad Ralovich on 6/18/20.
//  Copyright © 2020 Vonkad. All rights reserved.
//

import Foundation
import UIKit

enum ApiError: Error {
    case noData
}

protocol ApiClient {
    func getCategory(onResult: @escaping (Result<[Category], Error>) -> Void)
    func getProduct(id: String, onResult: @escaping (Result<[Product], Error>) -> Void)
    func getImage(link: String, imageV: UIImageView) -> Void
    func getImageData(link: String) -> Data
}

class ApiClientImpl: ApiClient {

    func getCategory(onResult: @escaping (Result<[Category], Error>) -> Void) {
        
        let session = URLSession.shared
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in

            guard let data = data else {
                onResult(.failure(ApiError.noData))
                return
            }

            do {
                let categoryResponse = try JSONDecoder().decode(RootModel.self, from: data)
                onResult(.success(categoryResponse.arrayCategory))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func getProduct(id: String, onResult: @escaping (Result<[Product], Error>) -> Void) {

        let session = URLSession.shared
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)")!
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in

            guard let data = data else {
                onResult(.failure(ApiError.noData))
                return
            }

            do {
                let productResponse = try JSONDecoder().decode(RootProduct.self, from: data)
                onResult(.success(productResponse.arrayProduct))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
        
    }
    
    func getImage(link: String, imageV: UIImageView) {
        
        guard let imageURL = URL(string: "https://blackstarwear.ru/\(link)" ) else { return }
                
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
        
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                        imageV.image = image
                    }
            }
    }
    
    func getImageData(link: String) -> Data {
        
        var result = Data()
        if let imageURL = URL(string: "https://blackstarwear.ru/\(link)" ) {
//            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    result = imageData
                    print("result === ", result)
                }
//            }
        }
        print("Return result === ", result)

        return result
    }
}
