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
        let task = URLSession.shared.dataTask(with: self.url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data")
                return
            }

            if response.statusCode == 200 {
                parser.parse(data)
            } else {
                print(response.statusCode)
            }
        }
        task.resume()

        return publish
    }
}
