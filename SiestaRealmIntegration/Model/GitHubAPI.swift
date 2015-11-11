//
//  GitHubAPI.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import Siesta

let GitHubAPI = _GitHubAPI()

// Supply any GitHub username here
let GitHubUsername = "p"

class _GitHubAPI: Service {
    
    private init() {
        super.init(base: "https://api.github.com")
        
        #if DEBUG
            Siesta.enabledLogCategories = LogCategory.common
        #endif
        
        configure {
            $0.config.headers["Authorization"] = self.basicAuthHeader
            $0.config.responseTransformers.add(GithubErrorMessageExtractor())
        }
        
//        configure("/Challenge/*")    {
//            $0.config.responseTransformers.add(ChallengeListTransformer())
//            $0.config.persistentCache = SiestaRealmChallengeCache()
//        }
        
    }
    
    
    private var basicAuthHeader: String? {
        let env = NSProcessInfo.processInfo().environment
        if let username = env["GITHUB_USER"],
            let password = env["GITHUB_PASS"],
            let auth = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding) {
                return "Basic \(auth.base64EncodedStringWithOptions([]))"
        } else {
            return nil
        }
    }
    
    // Resource convenience accessors
    
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

private struct GithubErrorMessageExtractor: ResponseTransformer {
    func process(response: Response) -> Response {
        switch response {
        case .Success:
            return response
            
        case .Failure(var error):
            error.userMessage = error.json["message"].string ?? error.userMessage
            return .Failure(error)
        }
    }
}

/// Parses JSON content into our models

//public func ChallengeListTransformer(transformErrors: Bool = false) -> ResponseTransformer {
//    //    print("ChallengeListTransformer starting")
//    return ResponseContentTransformer(transformErrors: transformErrors)
//        {
//            (content: NSJSONConvertible, entity: Entity) throws -> [SingleChallenge] in
//            
//            //            print("ChallengeListTransformer running")
//            
//            let itemJSON = JSON(content)
//            return SingleChallenge.parseChallengeList(itemJSON)
//    }
//}

