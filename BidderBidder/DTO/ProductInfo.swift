//
//  ProductInfo.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/08/27.
//

import Foundation

struct productInfo: Codable {
    let productTitle: String
    let productContent: String
    let hopePrice: Int64?
    let openingBid: Int64
    let tick: Int64
    let expirationDate: String
    let bidderCount: Int
    let images: [String]
    let bids: [Bidder]
}
