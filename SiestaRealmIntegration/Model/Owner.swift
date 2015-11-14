//
//  Owner.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/13/15.
//

import RealmSwift

class Owner: Object {
    
    dynamic var login = ""
    dynamic var siestaKey = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
}

extension Owner {
    
    class func parseItemList(fromJSON:AnyObject) -> [Owner] {
        var list = [Owner]()
        
        if let jsonArray = fromJSON as? NSArray {
            for itemDictionary in jsonArray {
                let item = Owner(value: itemDictionary)
                list.append(item)
            }
        } else if let jsonDictionary = fromJSON as? NSDictionary {
            list.append(Owner(value: jsonDictionary))
        }
        
        return list
    }
    
}