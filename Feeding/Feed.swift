//
//  feed.swift
//  Feeding
//
//  Created by Satoshi Watanabe on 2020/05/27.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import Foundation

public struct Entry: Hashable {
    public var title: String? = ""
    public var link: String? = ""
    public var summary: String? = ""
    public var updated: Date? = Date()
    public var content: String?  = ""
}

public struct Feed: Hashable {
    public var title: String? = ""
    public var id: String? = ""
    public var updated: Date? = Date()
    public var entry: [Entry] = []
}
