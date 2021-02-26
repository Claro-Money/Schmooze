import Foundation


public protocol ResponseSchmoozifiable {
    
    func schmoozify() -> Response
    
}


public struct Response: Equatable, Encodable {
    
    public let timestamp: Date = Date()
    public let statusCode: Int?
    public let mimeType: String?
    public var data: Data?
    public let headers: [String: String]
    public let errorDescription: String?
    
    public init(statusCode: Int?, mimeType: String?, data: Data? = nil, headers: [String: String] = [:], errorDescription: String? = nil) {
        self.statusCode = statusCode
        self.mimeType = mimeType
        self.data = data
        self.headers = headers
        self.errorDescription = errorDescription
    }
    
}


extension Response {
    
    /// Returns formatted date for  Request
    /// - Returns: String date
    public func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter.string(from: timestamp)
    }
    
}


extension Response: ResponseSchmoozifiable {
    
    public func schmoozify() -> Response {
        return self
    }
    
}


extension URLResponse {
    
    
    /// Convert URLRequest to HTTPURLRequest if possible
    /// - Returns: HTTPURLResponse?
    public func asHTTPURLResponse() -> HTTPURLResponse? {
        guard let httpResponse = self as? HTTPURLResponse else {
            return nil
        }
        return httpResponse
    }
    
}


extension HTTPURLResponse: ResponseSchmoozifiable {
    
    public func schmoozify() -> Response {
        let headers = allHeaderFields.reduce([String : String]()) { (dict, header) -> [String: String] in
            var dict = dict
            dict["\(header.key)"] = "\(header.value)"
            return dict
        }
        return Response(
            statusCode: statusCode,
            mimeType: mimeType,
            data: nil,
            headers: headers
        )
    }
    
}

extension Error {
    
    public func schmoozify() -> Response {
        return Response(
            statusCode: nil,
            mimeType: nil,
            data: nil,
            headers: [:],
            errorDescription: localizedDescription
        )
    }
    
}
