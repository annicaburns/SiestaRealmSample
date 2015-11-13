//
//  Siesta+Realm.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/12/15.
//

import Siesta
import RealmSwift


extension _GitHubAPI {
    
    func configureTransformerPipeline() {

        configureTransformer("/users/*/repos") {
            Repository.parseItemList($0.content as NSJSONConvertible)
        }
        
        configureTransformer("/repos/*/*") {
            Repository.parseItemList($0.content as NSJSONConvertible)
        }
        
        configureTransformer("/users/*") {
            User.parseItemList($0.content as NSJSONConvertible)
        }
        
    }
    
    /// Resource convenience accessors
    func user() -> Resource {
        return resource("users").child(GitHubUsername)
    }
    func userRepos() -> Resource {
        return resource("users").child(GitHubUsername).child("repos")
    }
    func repo(fullname: String) -> Resource {
        return resource("repos").child(fullname)
    }

}

extension TypedContentAccessors {
    
    var userArray: [User] {return contentAsType(ifNone: [] as [User]) }
    
    var repositoryArray: [Repository] { return contentAsType(ifNone: [] as [Repository]) }
    
}
