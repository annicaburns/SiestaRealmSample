//
//  GitHubAPI.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import Siesta

let GitHubAPI = _GitHubAPI()

// Supply any GitHub username here
let GitHubUsername = "bustoutsolutions"

class _GitHubAPI: Service {
    
    private init() {
        super.init(base: "https://api.github.com")
        
        #if DEBUG
            Siesta.enabledLogCategories = LogCategory.common
        #endif
        
        /// Configure the service
        configure {
            $0.config.headers["Authorization"] = self.basicAuthHeader
            $0.config.responseTransformers.add(GithubErrorMessageExtractor())
//            $0.config.persistentCache = SiestaRealmCache()
        }
        
        /// Configure the ResponseTransformers that parse JSON content into our models
        self.configureTransformerPipeline()
        
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

