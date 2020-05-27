//
//  Feeding.swift
//  Feeding
//
//  Created by Satoshi Watanabe on 2020/05/26.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import Foundation
import Combine

enum NetworkError: Error {
    case unknown
}

public class Feeding {
    private var url: URL
    private var cancellables = Set<AnyCancellable>()

    init(url: URL) {
        self.url = url
    }

    convenience init?(string: String) {
        guard let url: URL = URL(string: string) else {
            return nil
        }
        self.init(url: url)
    }

    func parse() -> AnyPublisher<Feed, Error> {
        let parser = Parser()
        let publish = parser.publish()
        print(self.url)
        _ = URLSession.shared.dataTaskPublisher(for: self.url)
            .print("network")
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode
                    else {
                        throw NetworkError.unknown
                }
                return data
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { data in
                parser.parse(data)
            }).store(in: &cancellables)

        return publish
    }
}
