//
//  Repository.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/11/15.
//

import RealmSwift
import Siesta

class Repository: Object {
    
    dynamic var name = ""
    dynamic var full_name = ""
    dynamic var created_at = ""
    dynamic var updated_at = ""
    dynamic var watchers = 0
    
    override static func primaryKey() -> String? {
        return "full_name"
    }
    
}

extension Repository {
    
    class func parseItemList(fromJSON:NSJSONConvertible) -> [Repository] {
        var list = [Repository]()
        
        if let jsonArray = fromJSON as? NSArray {
            for itemDictionary in jsonArray {
                let item = Repository(value: itemDictionary)
                list.append(item)
            }
        } else if let jsonDictionary = fromJSON as? NSDictionary {
            list.append(Repository(value: jsonDictionary))
        }
        
        return list
    }
}