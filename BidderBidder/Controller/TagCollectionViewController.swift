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
    var dataArray: [String] = []
    let sectionInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.dataSource = self
        setUpRecentlyCollectionView()
        registerCell()
    }

    func setUpRecentlyCollectionView() {
        recentlyCollectionView.dataSource = self
    }

    func registerCell() {
        recentlyCollectionView.register(UINib(nibName: "RecentlySearchViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentlySearchViewCell")
    }

    @IBAction func clearCell(_: Any) {
        dataArray = []
        recentlyCollectionView.reloadData()
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: "searchHistory")
        }
    }
}

extension TagCollectionViewController: UICollectionViewDataSource {
    // Wie viele Objekete soll es geben?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == recentlyCollectionView {
            return dataArray.count
        }
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentlyCollectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlySearchViewCell", for: indexPath) as! RecentlySearchViewCell
            cellA.setData(text: dataArray[indexPath.row])
            cellA.delete = { [unowned self] in
                UserDefaults.standard.removeObject(forKey: "searchHistory")
                self.dataArray.remove(at: indexPath.row)
                self.recentlyCollectionView.reloadData()
            }

            return cellA
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            let tag = tags[indexPath.item]
            cell.tags = tag
            return cell
        }
    }
}

extension TagCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 10
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
