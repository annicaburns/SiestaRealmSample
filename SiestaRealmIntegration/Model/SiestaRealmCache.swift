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
            if let item = modelMap.item {
                return Entity(content: [item], contentType: "")
            } else if modelMap.cacheKey != nil && modelMap.objectType != nil {
                let items = realm.objects(Repository)
                var respositories = [Repository]()
                for repo in items {
                    respositories.append(repo)
                }
                return Entity(content: respositories, contentType: "")
            }
        }
        
        return nil
    }
    
    
    func writeEntity(entity: Entity, forKey key: String) {
        print("SiestaRealmCache writeEntity")
        
        let realm = try! Realm()
        if let items:[Repository] = entity.repositoryArray {
            let item:Repository? = items.count == 1 ? items.first : nil
            realm.beginWrite()
            // add a map record that indicates if we should pull the single included item, or that we should pull all persisted items
            let map = ModelMap(cacheKey: key, objectType: "Repository", item: item)
            realm.add(map, update: true)
            // persist all challenges, updating anything that has changed
            for item:Object in items {
                realm.add(item, update: true)
            }
            try! realm.commitWrite()
        }
    }
    
    
}
