//
//  ColorManage.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/05/18.
//

import UIKit

extension UIColor {
    static let skyBlueColor = UIColor(rgb: 0x21CEFF).cgColor
    static let lightGrayColor = UIColor(rgb: 0xE9E9E9).cgColor

    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: UInt8((rgb >> 16) & 0xFF),
            green: UInt8((rgb >> 8) & 0xFF),
            blue: UInt8(rgb & 0xFF)
        )
    }
}
