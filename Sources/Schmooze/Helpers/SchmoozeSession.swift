import Foundation


public class SchmoozeSession: URLSession {
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let req = Tracker.default.register(request: request)
        return super.dataTask(with: request) { data, response, error in
            if let httpResponse = response?.asHTTPURLResponse() {
                Tracker.default.register(
                    response: httpResponse.schmoozify(),
                    data: data,
                    for: req
                )
            } else {
                Tracker.default.register(
                    response: Response(
                        statusCode: nil,
                        mimeType: response?.mimeType,
                        data: data,
                        headers: [:]
                    ),
                    data: data,
                    for: req
                )
            }
            completionHandler(data, response, error)
        }
    }
    
}
