//
//  BidderRankingCell.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/08/27.
//

import UIKit

class BidderRankingCell: UITableViewCell {
    static let identifier = "BidderRankingCell"
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var bidLabel: UILabel!

    func setCell(_ bidder: Bidder) {
        rankLabel.text = "\(bidder.index)"
        nicknameLabel.text = bidder.userNickname
        if bidder.bid == -1 {
            bidLabel.text = "비공개"
        } else {
            bidLabel.text = Util.int64ToMoneyFormat(bidder.bid)
        }
    }
}
