import XCTest
@testable import Schmooze

final class TrackerTests: XCTestCase {
    
    var subject: Tracker!
    
    override func setUp() {
        super.setUp()
        
        subject = Tracker()
    }
    
    func testRegisterResponse() {
        var numberOfRequests = 0
        subject.requests.bind { requests in
            numberOfRequests = 1
        }
        let req = subject.register(
            request: Request(
                url: "url",
                method: "get",
                data: nil,
                headers: nil,
                timeoutInterval: 1
            )
        )
        let data = Data()
        let response = Response(
            statusCode: 200,
            mimeType: nil,
            data: data,
            headers: [:]
        )
        subject.register(
            response: response,
            data: data,
            for: req
        )
        
        let request = subject.requests.value[0]
        
        XCTAssertEqual(request.response, response)
        XCTAssertEqual(request.response?.data, data)
        XCTAssertEqual(numberOfRequests, 1)
    }

    static var allTests = [
        ("testRegisterResponse", testRegisterResponse),
    ]
}
