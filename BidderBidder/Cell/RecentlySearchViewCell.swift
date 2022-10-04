//
//  RecentlySearchViewCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/12.
//

import UIKit

class RecentlySearchViewCell: UICollectionViewCell {
   
    private var index:Int!
    
    private var parentVC: TagCollectionViewController!
    
    private lazy var collectionView = (superview as! UICollectionView)
    
    @IBOutlet var textLabel: UILabel!

    @IBAction func deleteCell(_: Any) {
        var histories = UserDefaults.standard.array(forKey: Constant.searchHistory)
        histories?.remove(at: index)
        UserDefaults.standard.set(histories, forKey: Constant.searchHistory)
        parentVC.dataArr.remove(at: index)
        collectionView.reloadData()
    }

    func setData(viewController: TagCollectionViewController, index: Int) {
        parentVC = viewController
        self.index = index
        textLabel.text = parentVC.dataArr[index]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

