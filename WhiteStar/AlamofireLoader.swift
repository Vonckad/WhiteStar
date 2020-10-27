//
//  AlamofireLoader.swift
//  HomeWork_12_Carthage
//
//  Created by Vlad Ralovich on 6/18/20.
//  Copyright © 2020 Vonkad. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireLoader {
    
    func loadCategory(completion: @escaping (ModelCategory) -> Void) {
        Alamofire.request("https://blackstarshop.ru/index.php?route=api/v1/categories").responseJSON { response in
            
            var json: ModelCategory?
            do {
                json = try JSONDecoder().decode(ModelCategory.self, from: response.data!)
            }
            catch {
                print("error2 === ", error)
            }
            
            guard let result = json else {
                return
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

