//
//  WritingStruct.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/15.
//

import Foundation
import UIKit

struct WritingStruct: Codable {
    let productTitle: String?
    let openingBid: String?
    let tick: String?
    let expirationDate: String?
    let productContent: String?
    
    let hopePrice: String?
    
    
    public init(productTitle: String?, hopePrice: String?, openingBid: String?, tick: String?, expirationDate: String?, productContent: String?){
        self.productTitle = productTitle
        self.hopePrice = hopePrice
        self.openingBid = openingBid
        self.tick = tick
        self.expirationDate = expirationDate
        self.productContent = productContent
    }
}
