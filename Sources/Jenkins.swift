/*
 * Jenkins Swift Client
 */

public struct Jenkins {
    let host: String
    let port: Int
    let token: String

    public init(host: String, port: Int, token: String) {
        self.host = host
        self.port = port
        self.token = token
    }
    
    public func getToken() -> String {
        return token
    }
}

extension Jenkins : CustomStringConvertible {
    public var description: String {
        return "Jenkins @ \(host):\(port)"
    }
}
