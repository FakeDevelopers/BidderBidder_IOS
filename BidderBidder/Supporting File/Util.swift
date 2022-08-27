//
//  Util.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/08/27.
//

import Foundation
class Util {
    static func intToMoneyFormat(_ value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: value))!
    }

    static func int64ToMoneyFormat(_ value: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: value))!
    }

    static func getRemainTime(_ remainSeconds: Int64) -> String {
        let day = remainSeconds / (24 * 60 * 60)
        let hour = (remainSeconds % (24 * 60 * 60)) / (60 * 60)
        let min = (remainSeconds % (60 * 60)) / 60
        let sec = remainSeconds % 60
        if day > 1 { // 1일 이상 남으면 일단위 출력
            return "\(day)일"
        } else if hour >= 3 { // 3시간 이상 남으면 시간단위 출력
            return "\(hour)시간"
        } else if hour > 0 || min >= 5 {
            if hour != 0 {
                return "\(hour)시간 \(min)분"
            }
            return "\(min)분"
        }
        if min > 0 || sec > 0 {
            if min != 0 {
                return "\(min)분 \(sec)초"
            }
            return "\(sec)초"
        }
        return Constant.EXPIRED_MESSAGE
    }
}
