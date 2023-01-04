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
        return tags.shuffled()
    }
}

enum TermsType {
    case main
    case sub
}

struct Terms {
    let termsID: String?
    let title: String
    let contents: String?
    let isMandatory: Bool
    var isAccept: Bool = false
    let type: TermsType

    static func loadSampleData() -> [[Terms]] {
        let terms1: [Terms] = [
            .init(
                termsID: "1",
                title: "비더비더 이용약관",
                contents: "blabla",
                isMandatory: true,
                type: .main
            ),
        ]

        let terms2: [Terms] = [
            .init(
                termsID: "2",
                title: "비더비더 이용약관2",
                contents: "blabla",
                isMandatory: true,
                type: .main
            ),
        ]

        let terms3: [Terms] = [
            .init(
                termsID: "3",
                title: "비더비더 이용약관3",
                contents: "blabla",
                isMandatory: true,
                type: .main
            ),
        ]
        let terms4: [Terms] = [
            .init(
                termsID: "4",
                title: "비더비더 이용약관4",
                contents: "blabla",
                isMandatory: false,
                type: .main
            ),
        ]

        return [terms1, terms2, terms3, terms4]
    }
}
