//
//  ParserTest.swift
//  FeedingTests
//
//  Created by Satoshi Watanabe on 2020/05/27.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import XCTest
import Combine
@testable import Feeding

class ParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParse() throws {
        let exp = expectation(description: "fail")
        var cancellables = Set<AnyCancellable>()

        let testData = "<feed><title>test</title></feed>"
        let parser = Parser()
        let observed = parser.publish()
        _ = observed
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                XCTAssertEqual(data.title, "test")
                exp.fulfill()
            }).store(in: &cancellables)
        parser.parse(testData.data(using: .utf8)!)

        wait(for: [exp], timeout: 10.0)
    }

}
