//
//  GitHubAPI.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import Siesta
import SwiftyJSON

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
// The only place I'm using SwiftyJSON is for the typed contect accessor below used by the GithubErrorMessageExtractor above. Remove it from future integrations
extension TypedContentAccessors {
    /**
     Adds a `.json` convenience property to resources that returns a SwiftyJSON `JSON` wrapper.
     If there is no data, then the property returns `JSON([:])`.
     
     Note that by default, Siesta parses data based on content type. This accessor is only a way
     of conveniently donwcasting and defaulting the data that Siesta has already parsed. (Parsing
     happens off the main thread in a GCD queue, never in response one of these content accessors.)
     To produce a custom data type that Siesta doesn’t already know how to parse as a Siesta
     resource’s content, you’ll need to add a custom `ResponseTransformer`.
     */
    var json: JSON {
        return JSON(contentAsType(ifNone: [:] as AnyObject))
    }
}

