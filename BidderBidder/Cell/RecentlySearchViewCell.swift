//
//  RecentlySearchViewCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/12.
//

import UIKit

class RecentlySearchViewCell: UICollectionViewCell {
    lazy var parentVC = TagCollectionViewController()
    var delete: (() -> Void) = {}

    @IBOutlet var textLabel: UILabel!

    @IBAction func deleteCell(_: Any) {
        delete()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(text: String) {
        textLabel.text = text
    }
}
