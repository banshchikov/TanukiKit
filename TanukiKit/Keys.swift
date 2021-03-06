import Foundation
import RequestKit

// MARK: request

public extension TanukiKit {
    public func postPublicKey(_ session: RequestKitURLSession = URLSession.shared, publicKey: String, title: String, completion: @escaping (_ response:Response<String>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PublicKeyRouter.postPublicKey(publicKey, title, configuration)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let _ = json {
                    completion(Response.success(publicKey))
                }
            }
        }
    }
}

enum PublicKeyRouter: Router {
    case postPublicKey(String, String, Configuration)

    var configuration: Configuration {
        switch self {
        case .postPublicKey(_, _, let config): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postPublicKey:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postPublicKey:
            return .form
        }
    }

    var path: String {
        switch self {
        case .postPublicKey:
            return "user/keys"
        }
    }

    var params: [String: Any] {
        switch self {
        case .postPublicKey(let publicKey, let title, _):
            return ["title": title as AnyObject, "key": publicKey as AnyObject]
        }
    }
}
