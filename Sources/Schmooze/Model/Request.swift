import Foundation


public protocol RequestSchmoozifiable {
    
    func schmoozify() -> Request
    
}


public class Request: Encodable {
    
    public let timestamp: Date = Date()
    public let url: String?
    public let method: String?
    public let data: Data?
    public let headers: [String: String]?
    public let timeoutInterval: TimeInterval
    
    public var response: Response? = nil
    
    public init(url: String?, method: String?, data: Data? = nil, headers: [String: String]? = nil, timeoutInterval: TimeInterval) {
        self.url = url
        self.method = method
        self.data = data
        self.headers = headers
        self.timeoutInterval = timeoutInterval
    }
    
}

extension Request {
    
    public func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter.string(from: timestamp)
    }
    
    public func timeIntervalString() -> String? {
        guard let responseTimestamp = response?.timestamp else {
            return nil
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full // or .short or .abbreviated
        formatter.allowedUnits = [.second, .minute, .hour]
        let from = timestamp.timeIntervalSince1970
        let to = responseTimestamp.timeIntervalSince1970
        let delta = to - from
        if delta < 1 {
            let ms = Int((delta.truncatingRemainder(dividingBy: 1)) * 1000)
            return "\(ms)ms"
        } else if delta < 60 {
            let time = NSInteger(delta)
            let ms = Int((delta.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            return "\(seconds).\(ms)sec"
        }

        return "\(formatter.string(from: timestamp, to: responseTimestamp) ?? "")"
    }
    
}

#if !os(macOS)

import UIKit

extension Request {
    
    public var colorStatus: UIColor {
        guard let response = response else {
            return UIColor(hex: "#F3BB44FF")!
        }
        switch true {
        case (response.statusCode ?? 0) > 0:
            return UIColor(hex: "#4F9950FF")!
        case response.errorDescription != nil:
            return UIColor(hex: "#D74024FF")!
        default:
            return .gray
        }
    }
    
    public var methodColor: UIColor {
        let def = UIColor.darkGray
        guard let method = method else {
            return def
        }
        switch true {
        case method == "GET":
            return UIColor(hex: "#4F9950FF")!
        case method == "POST":
            return UIColor(hex: "#F3BB44FF")!
        case method == "DELETE":
            return UIColor(hex: "#D74024FF")!
        case method == "PATCH":
            return def
        case method == "PUT":
            return UIColor(hex: "#3879E7FF")!
        case method == "DELETE":
            return UIColor(hex: "#D74024FF")!
        default:
            return def
        }
    }
    
}

#endif

extension Request: Equatable {
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
        lhs.url == rhs.url &&
        lhs.method == rhs.method &&
        lhs.data == rhs.data &&
        lhs.headers == rhs.headers &&
        lhs.timeoutInterval == rhs.timeoutInterval &&
        lhs.response == rhs.response
    }
    
}


extension Request: RequestSchmoozifiable {
    
    public func schmoozify() -> Request {
        return self
    }
    
}


extension URLRequest: RequestSchmoozifiable {
    
    public func schmoozify() -> Request {
        return Request(
            url: url?.absoluteString,
            method: httpMethod,
            data: httpBody,
            headers: allHTTPHeaderFields,
            timeoutInterval: timeoutInterval
        )
    }
    
}
