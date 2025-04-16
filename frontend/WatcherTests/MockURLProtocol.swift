import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponses = [URL: (data: Data, response: HTTPURLResponse, error: Error?)]()
    
    static func registerMockResponse(for url: URL, data: Data, statusCode: Int = 200, error: Error? = nil) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        mockResponses[url] = (data, response, error)
    }
    
    static func reset() {
        mockResponses = [:]
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let (data, response, error) = MockURLProtocol.mockResponses[url] {
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            }
        } else {
            let notFoundResponse = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: notFoundResponse, cacheStoragePolicy: .notAllowed)
            let errorData = Data("Not found".utf8)
            client?.urlProtocol(self, didLoad: errorData)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    

    override func stopLoading() {

    }
}
