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


struct Term {
    let id: String?
    let termName: String
    let term: String?
    let isRequired: Bool
    var isAccept: Bool = false
    
    static func loadSampleData() -> [Term] {
        let term1: Term = Term(
            id: "1",
            termName: "비더비더 이용약관1",
            term: "blabla",
            isRequired: true
        )
        
        let term2: Term = Term(
            id: "2",
            termName: "비더비더 이용약관2",
            term: "blabla",
            isRequired: true
        )
        
        let term3: Term = Term(
            id: "3",
            termName: "비더비더 이용약관3",
            term: "blabla",
            isRequired: true
        )
        
        let term4: Term = Term(
            id: "4",
            termName: "비더비더 이용약관4",
            term: "blabla",
            isRequired: false
        )
        
        
        return [term1, term2, term3, term4]
    }
}
