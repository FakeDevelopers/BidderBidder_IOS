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
        filteredArr = childVC?.dataArr
        
        if let data = UserDefaults.standard.object(forKey: Constant.searchHistory) as? [String] {
            childVC?.dataArr = data
        }
    }
    
    private func setupSearchController() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width // 화면 너비
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 0))
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
    
    
    func findDuplicate(_ input: String) -> Bool {
        let dataArr = (childVC?.dataArr)!
        if dataArr.contains(input) {
            let indexNum = dataArr.firstIndex(of: input)
            childVC?.dataArr.remove(at: indexNum!)
            return false
        }
        return true
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uiImage = "magnifyingglass"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = filteredArr[indexPath.row]
        cell.imageView?.image = UIImage(systemName: uiImage)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        return cell
    }
    
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filteredArr = []
        
        if searchText == "" {
            filteredArr = childVC?.dataArr
            tableView.isHidden = true
            containerView.isHidden = false
        }
        else {
            for arrList in childVC?.dataArr ?? [] {
                if arrList.lowercased().contains(searchText.lowercased()) {
                    filteredArr.append(arrList)
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
        if findDuplicate(searchBar.text!) {
            childVC?.dataArr.insert(searchBar.text!, at: 0)
            UserDefaults.standard.set(childVC?.dataArr, forKey: Constant.searchHistory)
            childVC?.recentlyCollectionView.reloadData()
        }
        else {
            childVC?.dataArr.insert(searchBar.text!, at: 0)
            childVC?.recentlyCollectionView.reloadData()
        }
        
    }
}
