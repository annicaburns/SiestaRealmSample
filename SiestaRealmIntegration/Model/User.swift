//
//  User.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/11/15.
//

import RealmSwift
import Siesta

class User: Object {
    
    dynamic var login = ""
    dynamic var name = ""
    dynamic var siestaKey = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
}

extension User {
    
    class func parseItemList(fromJSON:NSJSONConvertible) -> [User] {
        var list = [User]()
        
        if let jsonArray = fromJSON as? NSArray {
            for itemDictionary in jsonArray {
                let item = User(value: itemDictionary)
                list.append(item)
            }
        } else if let jsonDictionary = fromJSON as? NSDictionary {
            list.append(User(value: jsonDictionary))
        }
        
        return list
    }
    
}