//
//  Siesta+ModelContentAccessors.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import Siesta
import RealmSwift

extension TypedContentAccessors {
    
    var repositoryArray: [Repository] { return contentAsType(ifNone: [] as [Repository]) }
    
}