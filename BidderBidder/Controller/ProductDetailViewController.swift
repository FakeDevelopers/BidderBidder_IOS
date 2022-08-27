//
// Created by 김한빈 on 2022/08/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productTitleLabel: UILabel!

    @IBOutlet weak var hopePriceLabel: UILabel!
    @IBOutlet weak var hopePriceContainerView: UIView!
    @IBOutlet weak var hopePriceConstraint: NSLayoutConstraint!

    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var tickLabel: UILabel!
    @IBOutlet weak var bidderSizeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var remainTimeStatusLabel: UILabel! // 마감이 되지 않으면 "마감까지"라고 뜨지만 마감이 되었으면 "마감"이라고 뜬다

    @IBOutlet weak var bidderListButtom: UIImageView!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerLocationLabel: UILabel!

    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var sellerProfileImageView: UIImageView!

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var bidderRankingTableView: UITableView!

    @IBOutlet weak var rankingView: RoundedCornerView!
    var productId: Int64!
    var remainSeconds: Int64!
    var inited = false
    var timer: Timer!
    var bidders: [Bidder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        explainTextView.translatesAutoresizingMaskIntoConstraints = true
        explainTextView.isScrollEnabled = false


        sendRestRequest(url: Constant.domainURL + "/product/getProductInfo/\(productId!)", params: nil, isPost: false) { [self]
        response in

            sellerProfileImageView.downloaded(from: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg") // 요건 임시로 넣어둔 링크입니다! 일부로 상수로 안만든거예요 ㅋㅋㅋ

            switch response.result {
            case .success(let value):

                initiallizeInfo(value!)
                break;
            default:
                dismiss(animated: true)
                break;
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if (!inited) {
            showProgress()
            inited = true
        }
    }

    private func initiallizeInfo(_ value: Data) {
        let decoder = JSONDecoder()
        let productInfo = try! decoder.decode(productInfo.self, from: value)

        productTitleLabel.text = productInfo.productTitle

        if (productInfo.hopePrice == nil) {
            hopePriceContainerView.isHidden = true
            hopePriceConstraint.isActive = false
            minimumPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.topAnchor, constant: 50).isActive = true
        } else {
            hopePriceLabel.text = Util.int64ToMoneyFormat(productInfo.hopePrice!) + "원"
        }
        minimumPriceLabel.text = Util.int64ToMoneyFormat(productInfo.openingBid) + "원"
        tickLabel.text = Util.int64ToMoneyFormat(productInfo.tick) + "원"

        bidderSizeLabel.text = Util.intToMoneyFormat(productInfo.bidderCount) + "명"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        remainSeconds = Int64(formatter.date(from: productInfo.expirationDate)!.timeIntervalSinceNow)
        if (remainSeconds <= 0) {
            remainTimeLabel.isHidden = true
            remainTimeStatusLabel.text = "마감"
        } else {
            remainTimeLabel.text = Util.getRemainTime(remainSeconds)

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
                let reaminTime = Util.getRemainTime(remainSeconds)
                if (reaminTime == Constant.EXPIRED_MESSAGE) {
                    timer.invalidate()
                }
            })
        }

        explainTextView.text = productInfo.productContent
        bidders = productInfo.bids

        if (bidders.count > 0) {
            var gesture = UITapGestureRecognizer(target: self, action: #selector(showBidderRanking))
            bidderListButtom.isUserInteractionEnabled = true
            bidderListButtom.addGestureRecognizer(gesture)
            bidderRankingTableView.reloadData()
        }

        if (productInfo.images.count > 0) {
            mainImageView.downloaded(from: Constant.domainURL + productInfo.images[0]) { [self] in

                dismissProgress()

                mainImageHeightConstraint.isActive = false
                mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
            }
        } else {
            dismissProgress()
        }
    }

    deinit {
        if (timer != nil && timer.isValid) {
            timer.invalidate()
        }
    }

    @objc func showBidderRanking() {
        rankingView.isHidden = false
    }

    @IBAction func closeBidderRanking(_ sender: Any) {
        rankingView.isHidden = true
    }
}

extension ProductDetailViewController: UITableViewDelegate {

}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bidders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BidderRankingCell.identifier) as? BidderRankingCell else {
            return UITableViewCell()
        }

        cell.setCell(bidders[indexPath.row])
        cell.selectionStyle = .none // 셀 선택시 회색으로 선택 표시해주는거 없애기

        return cell
    }
}


