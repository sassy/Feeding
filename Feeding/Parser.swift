//
//  Parser.swift
//  Feeding
//
//  Created by Satoshi Watanabe on 2020/05/27.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import Foundation
import Combine

enum Mode {
    case unkown
    case atom
    case atomEntry
    case rss2
    case rss1
}

class Parser: NSObject, XMLParserDelegate {
    var feed: Feed
    var entry: Entry = Entry()
    var elementName: String?
    private let xmlPublisher: PassthroughSubject<Feed, Error>
    var mode: Mode = .unkown

    override init() {
        xmlPublisher = PassthroughSubject<Feed, Error>()
        feed = Feed()
        super.init()
    }

    func publish() -> AnyPublisher<Feed, Error> {
        return xmlPublisher.eraseToAnyPublisher()
    }

    func parse(_ data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        xmlPublisher.send(self.feed)
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        self.elementName = elementName
        switch mode {
        case .unkown:
            setMode(elementName)
        case .atom:
            if elementName == "entry" {
                mode = .atomEntry
                entry = Entry()
            }
        case .atomEntry:
            if elementName == "link" {
                entry.link = attributeDict["href"]
            }
        case .rss2: break
        case .rss1: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if mode == .atomEntry && elementName == "entry" {
            mode = .atom
            feed.entry.append(self.entry)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch mode {
        case .unkown: break
        case .atom:
            setFeedData(string)
        case .atomEntry:
            setFeedEntryData(string)
        case .rss2: break
        case .rss1: break
        }

    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {

    }
}

extension Parser {
    private func setMode(_ element: String) {
        switch element {
        case "feed":
            mode = .atom
        default: break
        }
    }

    private func setFeedData(_ string: String) {
        if self.elementName == "title" {
            feed.title = string
        } else if self.elementName == "id" {
            feed.id = string
        } else if self.elementName == "date" {
            let formatter = DateFormatter()
            formatter.dateFormat = " yyyy-MM-dd'T'HH:mm:ss'Z'"
            feed.updated = formatter.date(from: string)
        }
    }

    private func setFeedEntryData(_ string: String) {
        if self.elementName == "title" {
            entry.title = string
        } else if self.elementName == "summary" {
            entry.summary = string
        } else if self.elementName == "updated" {
            let formatter = DateFormatter()
            formatter.dateFormat = " yyyy-MM-dd'T'HH:mm:ss'Z'"
            entry.updated = formatter.date(from: string)
        } else if self.elementName == "content" {
            entry.content = string
        }
    }
}
