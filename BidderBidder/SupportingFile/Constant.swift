//
//  Constant.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/15.
//

import Foundation
import UIKit

struct Constant {
    static let domainURL: String = Bundle.main.object(forInfoDictionaryKey: "domainURL") as! String
    static let writeURL: String = Bundle.main.object(forInfoDictionaryKey: "writeURL") as! String

    static let expiredMessage = "마감"

    static let dateTimeFormat = "yyyy-MM-dd HH:mm"

    static let searchHistory = "searchHistory"
}
