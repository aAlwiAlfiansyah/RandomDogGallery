//
//  DogAPIServicesTests.swift
//  Random Dog GalleryTests
//
//  Created by Alwi Alfiansyah Ramdan on 10/06/25.
//

import XCTest
import Quick
import Nimble
@testable import Random_Dog_Gallery

class MockURLProtocol: URLProtocol {
  static var mockResponses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]
  
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
    if let url = request.url,
       let mockResponse = MockURLProtocol.mockResponses[url] {
      if let responseError = mockResponse.error {
        client?.urlProtocol(self, didFailWithError: responseError)
        client?.urlProtocolDidFinishLoading(self)
        return
      }
      
      if let responseData = mockResponse.data {
        client?.urlProtocol(self, didLoad: responseData)
      }
      
      if let response = mockResponse.response {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      
      client?.urlProtocolDidFinishLoading(self)
    }
  }

  override func stopLoading() {}
}

final class DogAPIServicesTests: AsyncSpec {
  override class func spec() {
    describe("DogAPIServices") {
      var urlSession: URLSession!
      var sut: DogAPIServices!
      
      beforeEach {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        sut = DogAPIServices(urlSession: urlSession)
        MockURLProtocol.reset()
      }
      
      describe("fetchDogImages") {
        context("when the request is successful") {
          it("should return correct dog images") {
            let count = 3
            let url = URL(string: "\(DogAPIServices.DOG_API_LIST_URL)\(count)")!
            
            let responseJSON = """
            {
              "message": [
                "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg",
                "https://images.dog.ceo/breeds/hound-basset/n02088238_13005.jpg",
                "https://images.dog.ceo/breeds/hound-blood/n02088466_10303.jpg"
              ],
              "status": "success"
            }
            """
            
            let responseData = responseJSON.data(using: .utf8)!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            MockURLProtocol.mockResponses[url] = (data: responseData, response: response, error: nil)
            
            let result = try await sut.fetchDogImages(count: count)
            expect(result.count).to(equal(3))
            expect(result[0].imageUrl).to(equal("https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg"))
            expect(result[1].imageUrl).to(equal("https://images.dog.ceo/breeds/hound-basset/n02088238_13005.jpg"))
            expect(result[2].imageUrl).to(equal("https://images.dog.ceo/breeds/hound-blood/n02088466_10303.jpg"))
          }
        }
        
        context("when the request fails") {
          it("should throw responseError") {
            let count = 3
            let url = URL(string: "\(DogAPIServices.DOG_API_LIST_URL)\(count)")!
            
            MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: NSError(domain: "test", code: -1))
            
            await expecta(try await sut.fetchDogImages(count: count)).to(throwError(DogAPIServicesError.responseError))
          }
        }
        
        context("when the response cannot be decoded") {
          it("should throw decodingError") {
            let count = 3
            let url = URL(string: "\(DogAPIServices.DOG_API_LIST_URL)\(count)")!
            
            let invalidJSON = "{ invalid json }"
            let responseData = invalidJSON.data(using: .utf8)!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            MockURLProtocol.mockResponses[url] = (data: responseData, response: response, error: nil)
            
            await expecta(try await sut.fetchDogImages(count: count)).to(throwError(DogAPIServicesError.decodingError))
          }
        }
      }
    }
  }
}
