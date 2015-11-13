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
            let predicate : NSPredicate = NSPredicate(format:"siestaKey = %@", key)
            if modelMap.objectType == "Repository" {
                let itemList = realm.objects(Repository).filter(predicate)
                return Entity(content: itemList, contentType: "")
            } else if modelMap.objectType == "User" {
                let itemList = realm.objects(User).filter(predicate)
                return Entity(content: itemList, contentType: "")
            }
        }
        
        return nil
    }
    
    
    func writeEntity(entity: Entity, forKey key: String) {
        print("SiestaRealmCache writeEntity")
        
        let realm = try! Realm()
        realm.beginWrite()

        if entity.repositoryArray.count > 0 {
            let map = ModelMap(cacheKey: key, objectType: "Repository")
            realm.add(map, update: true)
            // persist all objects, adding the cacheKey
            for repo in entity.repositoryArray {
                repo.siestaKey = key
                realm.add(repo, update: true)
            }
        } else if entity.userArray.count > 0 {
            let map = ModelMap(cacheKey: key, objectType: "User")
            realm.add(map, update: true)
            // persist all objects, updating anything that has changed
            for user in entity.userArray {
                user.siestaKey = key
                realm.add(user, update: true)
            }
        }
        
        try! realm.commitWrite()

    }
    
}
