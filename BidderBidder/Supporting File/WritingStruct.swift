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
    
    
    public init(productTitle: String?, openingBid: String?, tick: String?, expirationDate: String?, productContent: String?, hopePrice: String?){
        self.productTitle = productTitle
        self.openingBid = openingBid
        self.tick = tick
        self.expirationDate = expirationDate
        self.productContent = productContent
        self.hopePrice = hopePrice
    }
}
