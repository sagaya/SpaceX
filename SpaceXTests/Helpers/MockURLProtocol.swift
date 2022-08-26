//
//  MockURLProtocol.swift
//  SpaceXTests
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import Foundation

public final class MockURLProtocol: URLProtocol {
  private(set) var activeTask: URLSessionTask?
  enum ResponseType {
    case error(Int, Data?)
    case success(Data)
  }
  static var responseType: ResponseType!
  private lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  public override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  public override func startLoading() {
    activeTask = session.dataTask(with: request)
    activeTask?.cancel() // We don’t want to make a network request, we want to return our stubbed data ASAP
  }
  
  public override func stopLoading() {
    activeTask?.cancel()
  }
}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    switch MockURLProtocol.responseType {
    case .error(let code, let data)?:
      let httpResponse = HTTPURLResponse(
        url: self.request.url!,
        statusCode: code,
        httpVersion: "HTTP/1.1",
        headerFields: [:])
      client?.urlProtocol(self, didReceive: httpResponse!, cacheStoragePolicy: .notAllowed)
      if let data = data {
        client?.urlProtocol(self, didLoad: data)
      }
    case .success(let response)?:
      let headers = ["Accept": "application/json", "ContentType": "application/json"]
      let httpResponse = HTTPURLResponse(
        url: self.request.url!,
        statusCode: 200,
        httpVersion: "HTTP/1.1",
        headerFields: headers)
      client?.urlProtocol(self, didReceive: httpResponse!, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: response)
    default:
      break
    }
    client?.urlProtocolDidFinishLoading(self)
  }
}

extension MockURLProtocol {
  public static func responseWithFailure(status: Int = 400, object: Data? = nil) {
    MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(status, object)
  }
  
  public static func responseWithData(object: Data) {
    MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(object)
  }
}
