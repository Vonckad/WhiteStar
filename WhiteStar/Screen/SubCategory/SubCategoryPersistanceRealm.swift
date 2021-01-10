//
//  SubCategoryPersistanceRealm.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 1/10/21.
//

import Foundation
import RealmSwift

class SubCategoryImagePersistance: Object {
    
    @objc dynamic var imageData = Data()
}

class SaveSubCategoryImageController {
    
    let apiClient = ApiClientImpl()
    private var realm: Realm!
    
    var imageDataRealm: Results<SubCategoryImagePersistance> {
        get {
            return realm.objects(SubCategoryImagePersistance.self)
        }
    }
    
    func load(link: String) {
        
        realm = try! Realm()
        
        let imDa = SubCategoryImagePersistance()
        
        imDa.imageData = apiClient.getImageData(link: link)
        
        try! self.realm.write({
            self.realm.add(imDa)
            
        })
    }
}
