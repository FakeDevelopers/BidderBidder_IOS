//
//  RecentlySearchViewCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/12.
//

import UIKit

class RecentlySearchViewCell: UICollectionViewCell {
    private var collectionIndex: Int!

    private var parentVC: TagCollectionViewController!

    private lazy var collectionView = (superview as! UICollectionView)

    @IBOutlet var textLabel: UILabel!

    @IBAction func deleteCell(_: Any) {
        var histories = UserDefaults.standard.array(forKey: Constant.searchHistory)
        histories?.remove(at: collectionIndex)
        UserDefaults.standard.set(histories, forKey: Constant.searchHistory)
        parentVC.dataArr.remove(at: collectionIndex)
        collectionView.reloadData()
    }

    func setData(viewController: TagCollectionViewController, index: Int) {
        parentVC = viewController
        self.collectionIndex = index
        textLabel.text = parentVC.dataArr[index]
    }
}
