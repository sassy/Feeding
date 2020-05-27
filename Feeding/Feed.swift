//
//  feed.swift
//  Feeding
//
//  Created by Satoshi Watanabe on 2020/05/27.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import Foundation

public struct Entry {
    var title: String?
    var link: String?
    var summary: String?
    var updated: Date?
    var content: String?
}

public struct Feed {
    var title: String?
    var id: String?
    var updated: Date?
    var entry: [Entry] = []
}
