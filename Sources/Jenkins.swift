/*
 * Jenkins Swift Client
 */

public enum JenkinsError: Error, CustomStringConvertible {
    case InvalidJenkinsHost
    case UnknownError
    
    init(error: APIError) {
        switch error {
        case .InvalidHost:
            self = .InvalidJenkinsHost
        default:
            self = .UnknownError
        }
    }
    
    public var description: String {
        switch self {
        case .InvalidJenkinsHost:   return "Couldn't connect to Jenkins Host"
        case .UnknownError:         return "Unknown error"
        }
    }
}

public enum Transport: CustomStringConvertible {
    case HTTP
    case HTTPS
    
    public var description: String {
        switch self {
        case .HTTP:     return "http"
        case .HTTPS:    return "https"
        }
    }
}

public final class Jenkins {
    private(set) var jobs: [Job] = []
    private(set) var client: APIClient?
    
    var jenkinsURL: String {
        guard let url = self.client?.baseURL else {
            return ""
        }
        return url.absoluteString
    }
    
    var jobURL: String {
        guard let url = self.client?.baseURL,
            let path = self.client?.path else {
                return ""
        }
        return url.appendingPathComponent(path).absoluteString
    }

    public init(host: String, port: Int, user: String, token: String, path: String, transport: Transport = .HTTP) throws {
        do {
            self.client = try APIClient(host: host, port: port, path: path, user: user, token: token)
        } catch let error as APIError {
            throw JenkinsError(error: error)
        }
    }
}

extension Jenkins : CustomStringConvertible {
    public var description: String {
        return "Jenkins \(client!.user) @ \(client!.host):\(client!.port)"
    }
}
