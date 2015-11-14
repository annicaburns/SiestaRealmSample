//
//  Repo.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/11/15.
//

import RealmSwift

class Repo: Object {
    
    dynamic var name = ""
    dynamic var full_name = ""
    dynamic var created_at = ""
    dynamic var updated_at = ""
    dynamic var subscribers_count = 0
    dynamic var stargazers_count = 0
    dynamic var owner:Owner? = Owner()
    dynamic var siestaKey = ""
    
    override static func primaryKey() -> String? {
        return "full_name"
    }
    
}

extension Repo {
    
    var createdDate:NSDate? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiDateFormatter = appDelegate.rfc3339DateFormatter
        
        return apiDateFormatter.dateFromString(self.created_at)!
    }
    
    var updatedDate:NSDate? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiDateFormatter = appDelegate.rfc3339DateFormatter

        return apiDateFormatter.dateFromString(self.updated_at)!
    }
    
    class func parseItemList(fromJSON:AnyObject) -> [Repo] {
        var list = [Repo]()
        
        if let jsonArray = fromJSON as? NSArray {
            for itemDictionary in jsonArray {
                let item = Repo(value: itemDictionary)
                list.append(item)
            }
        } else if let jsonDictionary = fromJSON as? NSDictionary {
            list.append(Repo(value: jsonDictionary))
        }
        
        return list
    }
    
}