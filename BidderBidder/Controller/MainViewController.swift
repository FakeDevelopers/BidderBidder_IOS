//
//  MainViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit
import Alamofire

class MainViewController : UIViewController {
    static let identifier = "MainViewController"
    
    
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var loadMoreBtn: UIButton!
    
    var productList: [Product] = []
    var listCount: Int = 20
    var checkListCount: Int = 20
    var startNumber: Int64 = -1
    var checkNum: Int = 0
    var checkNumRefresh: Int = 0
    let refresh = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.dataSource = self
        productListTableView.delegate = self
        getProductList()
        self.initRefresh()
    }
    
    
    @IBAction func loadMore(_ sender: Any) {
        getProductList()
        checkNum += 1
        loadMoreBtn.isEnabled = false
        loadMoreBtn.tintColor = UIColor.clear
    }
    
    func getProductList() {
            sendRestRequest(url:"http://bidderbidderapi.kro.kr:8080/product/getPageProductList", params:["searchWord":"","listCount":listCount,"startNumber":startNumber,"serachType":2]  , isPost: false) { [self]
                response in
                switch response.result {
                case .success(let data):
                    let jsonData = data!
                    do {
                        let decoder = JSONDecoder()
                        let bringData = try decoder.decode([Product].self, from: jsonData)
                        self.productList.append(contentsOf: bringData)
                        self.listCount = bringData.count
                        self.startNumber = (bringData.last?.productId ?? 0)
                        self.productListTableView.reloadData()
                        if listCount < checkListCount {
                            loadMoreBtn.isEnabled = false
                            loadMoreBtn.tintColor = UIColor.clear
                        }
                    }
                    catch {
                        print(error)
                    }
                    
                case .failure(let error):
                    print("통신 실패 : ",(String(describing:
                                                error.errorDescription)))
                }
            }
        }
        
    }

// RefreshControl
extension MainViewController {
    
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.productListTableView.refreshControl = refresh
        if listCount > checkListCount {
            loadMoreBtn.isEnabled = true
            loadMoreBtn.tintColor = UIColor.black
        }
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("refreshTable")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 임시?
            self.productListTableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    // MARK: - UIRefreshControl of ScrollView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y < -0.1) {
            self.refreshTable(refresh: self.refresh)
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - 800
        if checkNum == 1{
            if offsetY > contentHeight - scrollView.frame.height {
                getProductList()
            }
        }
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCell.identifier) as? ProductViewCell else {
            return UITableViewCell()
        }
        
        cell.setCell(product: productList[indexPath.row])
        cell.selectionStyle = .none // 셀 선택시 회색으로 선택 표시해주는거 없애기
        return cell
    }
    
}






