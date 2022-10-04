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
        var tags: [Tag] = ["Design", "Research", "Beauty", "Travel", "Makeup"].map { name in
            Tag(name: name)
        }
        let randTags = tags.shuffled()
        return randTags
    }
}
