//
//  SearchViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/07/28.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var containerView: UIView!

    var arr = [String]()

    var filteredArr: [String]!

    lazy var childVC = children.first as? TagCollectionViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setTableViewLayout()
        setupBackButton()
        filteredArr = childVC?.dataArray

        if let data = UserDefaults.standard.object(forKey: "searchHistory") as? [String] {
            childVC?.dataArray = data
        }
    }

    private func setupSearchController() {
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width // 화면 너비
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
        searchBar.placeholder = "검색어를 입력해주세요."
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        searchBar.delegate = self
    }

    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func setTableViewLayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.separatorColor = .white
    }

    private func hideContainerView() {
        containerView.isHidden = true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell

        cell.textLabel?.text = filteredArr[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)

        return cell
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filteredArr = []

        if searchText == "" {
            filteredArr = childVC?.dataArray
            tableView.isHidden = true
            containerView.isHidden = false
        } else {
            for dj in childVC?.dataArray ?? [] {
                if dj.lowercased().contains(searchText.lowercased()) {
                    filteredArr.append(dj)
                }
            }
            tableView.isHidden = false
            containerView.isHidden = true
        }
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        tableView.isHidden = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        childVC?.dataArray.insert(searchBar.text!, at: 0)
        UserDefaults.standard.set(childVC?.dataArray, forKey: "searchHistory")
        print(childVC?.dataArray)
        childVC?.RecentlyCollectionView.reloadData()
        print(searchBar.text!)
    }
}
