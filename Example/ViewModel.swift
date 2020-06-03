//
//  ViewModel.swift
//  Example
//
//  Created by Satoshi Watanabe on 2020/05/28.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import Foundation
import Combine
import Feeding

class ViewModel: ObservableObject {
    @Published var entries: [Entry]
    var cancellables = Set<AnyCancellable>()

    init() {
        entries = []
    }

    func fetch() {
        Feeding(string: "https://www.blogger.com/feeds/1131534638298698079/posts/default")?
            .parse()
            .print()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                DispatchQueue.main.sync {
                    self.entries = data.entry
                }
            }).store(in: &cancellables)
    }
}
