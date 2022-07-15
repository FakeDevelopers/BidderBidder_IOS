//
//  ProductViewCell.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/06/03.
//

import UIKit

struct Product: Codable{
    var productId: Int64
    var thumbnail: String
    var productTitle: String
    var hopePrice: Int64?
    var openingBid: Int64
    var tick: Int64
    var expirationDate: String
    var bidderCount : Int
}

class ProductViewCell: UITableViewCell {
    static let identifier = "ProductViewCell"
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var hopePrice: UILabel!
    @IBOutlet weak var openingBid: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    
    @IBOutlet weak var bidder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(product: Product) {
        thumbnail.downloaded(from: Constant.domainURL+product.thumbnail)
        productName.text = product.productTitle
        if product.hopePrice == nil {
            hopePrice.text = " "
        } else {
            hopePrice.text = "희망입찰가: \(product.hopePrice!)원"
        }
        openingBid.text = "시작가: \(product.openingBid)원"
        expirationDate.text = product.expirationDate
        bidder.text = "\(product.bidderCount)명"
    }
}
