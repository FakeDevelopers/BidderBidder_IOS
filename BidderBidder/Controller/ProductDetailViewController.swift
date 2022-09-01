//
// Created by 김한빈 on 2022/08/25.
//

import Toast
import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!

    // Product Info
    @IBOutlet var productTitleLabel: UILabel!

    @IBOutlet var hopePriceLabel: UILabel!
    @IBOutlet var hopePriceContainerView: UIView!
    @IBOutlet var hopePriceConstraint: NSLayoutConstraint!

    @IBOutlet var minimumPriceLabel: UILabel!
    @IBOutlet var tickLabel: [UILabel]!
    @IBOutlet var bidderSizeLabel: UILabel!
    @IBOutlet var remainTimeLabel: UILabel!
    @IBOutlet var remainTimeStatusLabel: UILabel! // 마감이 되지 않으면 "마감까지"라고 뜨지만 마감이 되었으면 "마감"이라고 뜬다

    @IBOutlet var bidderListButtom: UIImageView!
    @IBOutlet var sellerNameLabel: UILabel!
    @IBOutlet var sellerLocationLabel: UILabel!

    @IBOutlet var explainTextView: UITextView!
    @IBOutlet var sellerProfileImageView: UIImageView!

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var mainImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet var bidButton: UIButton!

    // BidderRanking
    @IBOutlet var bidderRankingTableView: UITableView!
    @IBOutlet var bidView: RoundedCornerView!
    @IBOutlet var closeBidViewButton: UIImageView!

    @IBOutlet var bidMinimumPriceLabel: UILabel!
    @IBOutlet var rankingView: RoundedCornerView!

    // BidderView
    @IBOutlet var keyboardHeight0ViewContraint: NSLayoutConstraint? = nil
    weak var keyboardHeightViewContraint: NSLayoutConstraint?
    @IBOutlet var keyboardView: UIView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var bidTextField: UITextField!

    @IBOutlet var bidderViewContraint1: NSLayoutConstraint!
    @IBOutlet var bidderViewContraint2: NSLayoutConstraint!

    @IBOutlet var estimateBidLabel: UILabel!
    @IBOutlet var minusBidButton: UIImageView!
    @IBOutlet var addBidderButton: UIImageView!

    // private var
    private var productInfo: ProductInfo!
    private var maximumPrice: Int64!
    private var minimumPrice: Int64!
    private var tick: Int64!

    private var bidViewHeight: CGFloat!
    private var bidViewWidth: CGFloat!
    private var bidViewX: CGFloat!
    private var bidViewY: CGFloat!

    private var bottomPadding: CGFloat!

    private var remainSeconds: Int64!
    private var inited = false
    private var timer: Timer!
    private var bidders: [Bidder] = []

    private static let estimateBidPrefix = "최종 입찰가 "

    // public var
    var productId: Int64! = 15

    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        addEventListener()
    }

    override func viewDidAppear(_: Bool) {
        if !inited {
            inited = true
            showProgress()

            bidViewHeight = bidView.frame.size.height
            bidViewWidth = bidView.frame.size.width
            bidViewX = bidView.frame.origin.x
            bidViewY = bidView.frame.origin.y

            bottomPadding = view.safeAreaInsets.bottom

            bidderViewContraint2.constant = -bottomPadding
        }
    }

    private func initData() {
        sendRestRequest(url: Constant.domainURL + "/product/getProductInfo/\(productId!)", params: nil, isPost: false) { [self]
            response in

                sellerProfileImageView.downloaded(from: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg") // 요건 임시로 넣어둔 링크입니다! 일부로 상수로 안만든거예요 ㅋㅋㅋ

                switch response.result {
                case let .success(value):
                    initiallizeInfo(value!)
                default:
                    dismiss(animated: true)
                }
        }
    }

    private func addEventListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        var gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(closeBidView))
        closeBidViewButton.isUserInteractionEnabled = true
        closeBidViewButton.addGestureRecognizer(gesture)

        gesture = UITapGestureRecognizer(target: self, action: #selector(minusBid))
        minusBidButton.isUserInteractionEnabled = true
        minusBidButton.addGestureRecognizer(gesture)

        gesture = UITapGestureRecognizer(target: self, action: #selector(addBid))
        addBidderButton.isUserInteractionEnabled = true
        addBidderButton.addGestureRecognizer(gesture)
    }

    private func initiallizeInfo(_ value: Data) {
        productInfo = (try? JSONDecoder().decode(ProductInfo.self, from: value))!

        setMainImage()
        setPriceInfo()
        setBidInfo()
    }

    private func setMainImage() {
        if productInfo.images.count > 0 {
            mainImageView.downloaded(from: Constant.domainURL + productInfo.images[0]) { [self] in

                dismissProgress()

                mainImageHeightConstraint.isActive = false
                mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
            }
        } else {
            dismissProgress()
        }
    }

    private func setPriceInfo() {
        if productInfo.hopePrice == nil {
            hopePriceContainerView.isHidden = true
            hopePriceConstraint.isActive = false
            minimumPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.topAnchor, constant: 50).isActive = true
        } else {
            hopePriceLabel.text = Util.int64ToMoneyFormat(productInfo.hopePrice!) + "원"
        }

        setBiddersInfo()

        let minimumPriceText = Util.int64ToMoneyFormat(minimumPrice) + "원"

        minimumPriceLabel.text = minimumPriceText
        bidMinimumPriceLabel.text = minimumPriceText
        tickLabel.forEach { label in
            label.text = Util.int64ToMoneyFormat(tick) + "원"
        }
    }

    private func setBiddersInfo() {
        bidders = productInfo.bids

        if bidders.count > 0 {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(showBidderRanking))
            bidderListButtom.isUserInteractionEnabled = true
            bidderListButtom.gestureRecognizers?.forEach(bidderListButtom.removeGestureRecognizer(_:))
            bidderListButtom.addGestureRecognizer(gesture)
            bidderRankingTableView.reloadData()
        }

        if bidders.count > 3 {
            minimumPrice = bidders[3].bid + productInfo.tick
        } else if bidders.count > 0 {
            minimumPrice = productInfo.openingBid + productInfo.tick
        } else {
            minimumPrice = productInfo.openingBid
        }
        maximumPrice = productInfo.hopePrice ?? 1_000_000_000_000
        tick = productInfo.tick
    }

    private func setBidInfo() {
        productTitleLabel.text = productInfo.productTitle

        bidderSizeLabel.text = Util.intToMoneyFormat(productInfo.bidderCount) + "명"

        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateTimeFormat

        remainSeconds = Int64(formatter.date(from: productInfo.expirationDate)!.timeIntervalSinceNow)

        setTimer()

        explainTextView.text = productInfo.productContent
        explainTextView.sizeToFit()
    }

    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
            let reaminTime = Util.getRemainTime(remainSeconds)
            if reaminTime == Constant.expiredMessage {
                if bidderViewContraint1.isActive {
                    closeBidView()
                }
                remainTimeLabel.isHidden = true
                remainTimeStatusLabel.text = "마감"
                bidButton.isHidden = true
                timer.invalidate()
            } else {
                remainTimeLabel.text = reaminTime
            }
            remainSeconds -= 1
        })
    }

    private func getCloestBid() -> Int64 {
        let text = bidTextField.text?.replacingOccurrences(of: ",", with: "")
        var price: Int64
        if text == nil || text?.count == 0 {
            price = 0
        } else {
            price = Int64(text!)!
        }
        price = (max(price - minimumPrice, 0) / tick) * tick + minimumPrice

        return price
    }

    private func setBid(_ bid: Int64) {
        let bidText = "\(Util.int64ToMoneyFormat(bid))"
        bidTextField.text = bidText
        estimateBidLabel.text = ProductDetailViewController.estimateBidPrefix + bidText
    }

    private func refreshEstimateBidLabelText() {
        estimateBidLabel.text = ProductDetailViewController.estimateBidPrefix + "\(Util.int64ToMoneyFormat(getCloestBid()))"
    }

    deinit {
        if timer != nil, timer.isValid {
            timer.invalidate()
        }
    }
}

// Callbacks
extension ProductDetailViewController {
    @objc func showBidderRanking() {
        rankingView.isHidden = false
    }

    @objc func closeBidView() {
        bidderViewContraint1.isActive = false
        bidderViewContraint2.isActive = true

        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.bidView.frame = CGRect(x: bidViewX, y: bidViewY, width: bidViewWidth, height: bidViewHeight)
        })
        view.endEditing(true)
    }

    @IBAction func closeBidderRanking(_: Any) {
        rankingView.isHidden = true
    }

    @IBAction func showBidView(_: Any) {
        bidderViewContraint2.isActive = false
        bidderViewContraint1.isActive = true

        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.bidView.frame = CGRect(x: bidViewX, y: bidViewY - bidViewHeight, width: bidViewWidth, height: bidViewHeight)
        })
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard notification.userInfo != nil else { return }

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            var contentInset: UIEdgeInsets = scrollView.contentInset
            contentInset.bottom = keyboardHeight
            scrollView.contentInset = contentInset

            if keyboardHeight0ViewContraint != nil {
                keyboardHeight0ViewContraint!.isActive = false
            }

            if keyboardHeightViewContraint != nil {
                keyboardHeightViewContraint!.isActive = false
            }

            keyboardHeightViewContraint = keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight - bottomPadding)
            keyboardHeightViewContraint!.isActive = true
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset

        if keyboardHeightViewContraint != nil {
            keyboardHeightViewContraint!.isActive = false
        }

        if keyboardHeight0ViewContraint != nil {
            keyboardHeight0ViewContraint!.isActive = false
        }

        keyboardHeight0ViewContraint = keyboardView.heightAnchor.constraint(equalToConstant: 0)
        keyboardHeight0ViewContraint!.isActive = true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func sendBid(_: Any) {
        let cloestBid = getCloestBid()
        bidTextField.text = "\(Util.int64ToMoneyFormat(cloestBid))"

        if userIdTextField.text == nil || userIdTextField.text!.count == 0 {
            view.makeToast("유저Id를 입력해주세요", position: .top)
            return
        }
        closeBidView()

        let alertController = UIAlertController(title: "입찰확인", message: "\(bidTextField.text!)원에 입찰하시겠습니까?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "예", style: .default) { [self] _ in
            showProgress()
            sendRestRequest(url: Constant.domainURL + "/product/\(productId!)/bid", params: ["userId": userIdTextField.text!.replacingOccurrences(of: ",", with: ""), "bid": bidTextField.text!.replacingOccurrences(of: ",", with: "")] as Dictionary) { [self]
                response in
                    switch response.result {
                    case .success:
                        initData()
                        view.makeToast("등록되었습니다", position: .bottom)
                        userIdTextField.text = ""
                        bidTextField.text = ""

                    case let .failure(error):
                        print("통신 실패 : ", String(describing: error.errorDescription))
                        dismissProgress()
                    }
            }
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .default)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc func addBid() {
        let cloestBid = getCloestBid()
        let bid = min(cloestBid + tick, maximumPrice)
        setBid(bid)
    }

    @objc func minusBid() {
        let cloestBid = getCloestBid()
        let bid = max(cloestBid - tick, minimumPrice)
        setBid(bid)
    }
}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        bidders.count
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

extension ProductDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        guard var text = textField.text else {
            return true
        }

        text = text.replacingOccurrences(of: ",", with: "")

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if string.isEmpty {
            // delete
            if text.count > 1 {
                guard let price = Int64("\(text.prefix(text.count - 1))") else {
                    return true
                }

                textField.text = "\(Util.int64ToMoneyFormat(price))"

            } else {
                textField.text = ""
            }
        } else {
            // add
            guard let price = Int64("\(text)\(string)") else {
                return true
            }
            if textField == bidTextField, price > maximumPrice {
                setBid(maximumPrice)
                return false
            }

            textField.text = "\(Util.int64ToMoneyFormat(price))"
        }
        if textField == bidTextField {
            refreshEstimateBidLabelText()
        }

        return false
    }
}
