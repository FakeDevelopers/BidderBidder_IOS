//
//  TagCollectionViewCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/11.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var container: UIView!
    @IBOutlet var label: UILabel!

    var tags: Tag! {
        didSet {
            if let tag = tags {
                container.makeRoundedWithBorder(radius: container.frame.height / 2, color: UIColor.black.cgColor)
                container.backgroundColor = .white
                label.text = tag.name
            }
        }
    }
}
