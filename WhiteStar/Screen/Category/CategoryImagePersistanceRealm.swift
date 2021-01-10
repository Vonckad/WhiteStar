//
//  CategoryImagePersistanceRealm.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 1/10/21.
//

import Foundation
import RealmSwift

class CategoryImagePersistance: Object {
    
    @objc dynamic var imageData = Data()
}

class SaveCategoryImageController {
    
    let apiClient = ApiClientImpl()
    private var realm: Realm!
    
    var imageDataRealm: Results<CategoryImagePersistance> {
        get {
            return realm.objects(CategoryImagePersistance.self)
        }
    }
    
    func load(link: String) {
        
        realm = try! Realm()
        
        let imDa = CategoryImagePersistance()
        
        imDa.imageData = apiClient.getImageData(link: link)
        
        try! self.realm.write({
            self.realm.add(imDa)
            
        })
    }
}
