//
//  CoordinateTest.swift
//  CoordinateTest
//
//  Created by Алексей on 16.05.2022.
//

import XCTest


class NetworkManagerTest: XCTestCase {
    var sut: URLSession!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testApiCallCompletes() throws {
      // given
      let urlString = "https://waadsu.com/api/russia.geo.json"
      let url = URL(string: urlString)!
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?

      // when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)

      // then
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidApiCallGetsHTTPStatusCode200() throws {
      // given
      let urlString = "https://waadsu.com/api/russia.geo.json"
      let url = URL(string: urlString)!
      // 1
      let promise = expectation(description: "Status code: 200")

      // when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        // then
        if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
                // 2
                promise.fulfill()
            } else {
                XCTFail("Status code: \(statusCode)")
            }
        }
      }
      dataTask.resume()
      // 3
      wait(for: [promise], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
