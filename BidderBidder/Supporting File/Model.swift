//
//  Model.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/11.
//

import UIKit
// Model file that holds logic for categories and feed
struct Tag {
    let name: String

    // Load data(Normally from database or so)
    static func load() -> [Tag] {
        var tags: [Tag] = []
        let names: [String] = ["Design", "Research", "Beauty", "Travel", "Makeup"]
        for name in names {
            tags.append(Tag(name: name))
        }
        tags.shuffle()
        return tags
    }
}
