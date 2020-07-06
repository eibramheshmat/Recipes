//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import XCTest
@testable import Recipes

class RecipesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAPIRequestSuccessful() {
        let expectatin = XCTestExpectation(description: "Request recipes list from DB")
        let url = URL(string: "\(Constants.baseUrl)?app_id=\(Constants.app_id)&app_key=\(Constants.app_key)&q=rice&from=0&to=10")
        let task = URLSession.shared.dataTask(with: url!){(_, response, _) in
            if let responseHTTP = response as? HTTPURLResponse{
                XCTAssertEqual(responseHTTP.statusCode, 200)
                expectatin.fulfill()
            }
        }
        task.resume()
        wait(for: [expectatin], timeout: 10.0)/// to wait while response back
    }

}
