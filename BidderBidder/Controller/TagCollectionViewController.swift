//
//  TagCollectionViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/11.
//

import UIKit

class TagCollectionViewController: UIViewController {
    @IBOutlet var tagCollectionView: UICollectionView!
    @IBOutlet var recentlyCollectionView: UICollectionView!
    let tags = Tag.load()
    var dataArr: [String] = []
    let sectionInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    let itemsPerRow: CGFloat = 2
    let itemsPerColumn: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.dataSource = self
        registerCell()
        if let data = UserDefaults.standard.object(forKey: Constant.searchHistory) as? [String] {
            dataArr = data
        }
    }

    func registerCell() {
        recentlyCollectionView.register(UINib(nibName: "RecentlySearchViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentlySearchViewCell")
    }

    @IBAction func clearCell(_: Any) {
        dataArr = []
        recentlyCollectionView.reloadData()
        UserDefaults.standard.removeObject(forKey: Constant.searchHistory)
    }
}

extension TagCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        collectionView == recentlyCollectionView ? dataArr.count : tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentlyCollectionView {
            let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlySearchViewCell", for: indexPath) as! RecentlySearchViewCell
            searchCell.setData(viewController: self, index: indexPath.row)
            return searchCell
        } else {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            categoryCell.tags = tags[indexPath.item]
            return categoryCell
        }
    }
}

extension TagCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        sectionInsets.left
    }
}
