//
//  MainViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import Alamofire
import UIKit

class MainViewController: UIViewController {
    @IBOutlet var productListTableView: UITableView!
    @IBOutlet var loadMoreBtn: UIButton!

    var productList: [Product] = []
    var listCount: Int = 20
    let checkListCount: Int = 20
    var startNumber: Int64 = -1
    var checkBool: Bool = false
    let listInterval: CGFloat = 800
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.dataSource = self
        productListTableView.delegate = self
        getProductList()
        initRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func loadMore(_: Any) {
        getProductList()
        checkBool = true
        loadMoreBtn.isEnabled = false
        loadMoreBtn.tintColor = UIColor.clear
    }

    func getProductList() {
        sendRestRequest(url: Constant.domainURL + "/product/getInfiniteProductList", params: ["searchWord": "", "listCount": listCount, "startNumber": startNumber, "serachType": 2], isPost: false) { [self]
            response in
                switch response.result {
                case let .success(data):
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
                    } catch {
                        print(error)
                    }

                case let .failure(error):
                    print("통신 실패 : ", String(describing:
                        error.errorDescription))
                }
        }
    }
}

// RefreshControl
extension MainViewController {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        productListTableView.refreshControl = refresh
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

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < -0.1 {
            refreshTable(refresh: refresh)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height - listInterval
        if checkBool, scrollView.contentOffset.y > contentHeight - scrollView.frame.height {
            getProductList()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        productList.count
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
