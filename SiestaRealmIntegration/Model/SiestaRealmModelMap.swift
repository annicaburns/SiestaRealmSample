//
//  SiestaRealmModelMap.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/11/15.
//

import RealmSwift

class ModelMap: Object {
    
    dynamic var cacheKey:String = ""
    dynamic var objectType:String = ""
    dynamic var item: AnyObject = Placeholder()
    
    override static func primaryKey() -> String? {
        return "cacheKey"
    }
    
    convenience init(cacheKey key: String, objectType type: String, item: AnyObject) {
        self.init()
        self.cacheKey = key
        self.objectType = type
        self.item = item
    }
    
}

class Placeholder:Object {
    
}
