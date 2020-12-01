//
//  PersistanceRealm.swift
//  HomeWork_14_1
//
//  Created by Vlad Ralovich on 8/18/20.
//

import Foundation
import RealmSwift


class PersistanceRealm: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var size = ""
    @objc dynamic var colorName = ""

    @objc dynamic var imageData = Data()
}

