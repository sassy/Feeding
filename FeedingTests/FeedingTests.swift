//
//  FeedingTests.swift
//  FeedingTests
//
//  Created by Satoshi Watanabe on 2020/05/26.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import XCTest
import Combine
@testable import Feeding

class FeedingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFeeding() throws {
        let exp = expectation(description: "fail")
        var cancellables = Set<AnyCancellable>()

        Feeding(string: "https://www.blogger.com/feeds/1131534638298698079/posts/default")?.parse().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finish")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { data in
            print(data)
            exp.fulfill()
        }).store(in: &cancellables)

        wait(for: [exp], timeout: 10.0)
    }
}
