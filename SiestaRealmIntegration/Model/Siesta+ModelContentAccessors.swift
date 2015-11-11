//
//  Siesta+ModelContentAccessors.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import Siesta

extension TypedContentAccessors {
    
    var repositoryArray: [Repository] { return contentAsType(ifNone: [] as [Repository]) }
//    var challenge: SingleChallenge { return contentAsType(ifNone: SingleChallenge()) }
    
}