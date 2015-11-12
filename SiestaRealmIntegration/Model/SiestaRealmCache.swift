//
//  SiestaRealmCache.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/11/15.
//


import Siesta
import RealmSwift

class SiestaRealmCache: EntityCache {
    func readEntity(forKey key: String) -> Entity? {
        print("SiestaRealmCache readEntity")
        
        let realm = try! Realm()
        
        if let modelMap = realm.objectForPrimaryKey(ModelMap.self, key: key) {
            if modelMap.item is Placeholder {
                if modelMap.objectType == "Repository" {
                    let itemList = realm.objects(Repository)
                    return Entity(content: itemList, contentType: "")
                } else if modelMap.objectType == "User" {
                    let itemList = realm.objects(User)
                    return Entity(content: itemList, contentType: "")
                }
            } else {
                return Entity(content: [modelMap.item], contentType: "")
            }
        }
        
        return nil
    }
    
    
    func writeEntity(entity: Entity, forKey key: String) {
        print("SiestaRealmCache writeEntity")
        
        let realm = try! Realm()
        
        if entity.repositoryArray.count > 0 {
            let item:AnyObject = entity.repositoryArray.count == 1 ? entity.repositoryArray.first! : Placeholder()
            realm.beginWrite()
            // add a map record that indicates if we should pull the single included item, or that we should pull all persisted items
            let map = ModelMap(cacheKey: key, objectType: "Repository", item: item)
            realm.add(map, update: true)
            // persist all objects, updating anything that has changed
            for repo in entity.repositoryArray {
                realm.add(repo, update: true)
            }
            try! realm.commitWrite()
        } else if entity.userArray.count > 0 {
            let item:AnyObject = entity.userArray.count == 1 ? entity.userArray.first! : Placeholder()
            realm.beginWrite()
            // add a map record that indicates if we should pull the single included item, or that we should pull all persisted items
            let map = ModelMap(cacheKey: key, objectType: "User", item: item)
            realm.add(map, update: true)
            // persist all objects, updating anything that has changed
            for user in entity.userArray {
                realm.add(user, update: true)
            }
            try! realm.commitWrite()
        }
    }
    
    
}
