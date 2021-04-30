//
//  PersistanceRealm.swift
//  HomeWork_14_1
//
//  Created by Vlad Ralovich on 8/18/20.
//

//import Foundation
import RealmSwift

class PersistanceRealm: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var size = ""
    @objc dynamic var colorName = ""
    @objc dynamic var count = 0
    @objc dynamic var idProduct = ""
    @objc dynamic var imageData = Data()
}

protocol MyRealmProtocol {
    func load()
    func addInRealm(item: PersistanceRealm, bool: Bool)
    var toDoListR: Results<PersistanceRealm> { get }
}

class MyRealm: MyRealmProtocol {
    private var realm: Realm!

    var toDoListR: Results<PersistanceRealm> {
        get { return realm.objects(PersistanceRealm.self)}
    }
    
    func load() {
        realm = try! Realm()
    }
    
    func addInRealm(item: PersistanceRealm, bool: Bool) {
        for i in toDoListR {
            if i.idProduct == item.idProduct {
                print("совпало idProduct === ", item.idProduct)
            }
        }
        try! self.realm.write {
            if bool { self.realm.add(item) } else { self.realm.delete(item)}
        }
    }
}
