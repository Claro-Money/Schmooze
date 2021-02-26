import Foundation


/// Tracker class
public class Tracker {
    
    public static let `default` = Tracker()
    
    public var requests: Observable<[Request]> = Observable([])
    
    /// Register request
    /// - Parameter request: HTTPURLRequest (see URLRequest.
    /// - Returns: Request
    @discardableResult public func register(request: RequestSchmoozifiable) -> Request {
        let request = request.schmoozify()
        requests.value.append(request)
        return request
    }
    
    
    /// Register response for a previously created Request
    /// - Parameters:
    ///   - response: Response
    ///   - data: Data (optional)
    ///   - request: Original Request
    public func register(response: ResponseSchmoozifiable, data: Data? = nil, for request: Request) {
        var response = response.schmoozify()
        response.data = data
        request.response = response
    }
    
    
    /// Handles Response registration from a DataTask output
    /// - Parameters:
    ///   - data: Data (optional)
    ///   - response: URLResponse (optional)
    ///   - error: Error (optional)
    ///   - request: Original Request
    public func handle(data: Data?, response: URLResponse?, error: Error?, for request: Request) {
        guard let response = response?.asHTTPURLResponse() else {
            if let error = error {
                Tracker.default.register(response: error.schmoozify(), for: request)
            }
            return
        }
        Tracker.default.register(response: response, data: data, for: request)
    }
    
}
