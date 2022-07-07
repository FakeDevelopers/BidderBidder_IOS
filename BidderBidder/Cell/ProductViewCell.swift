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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
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
        thumbnail.downloaded(from: "http://bidderbidderapi.kro.kr:8080"+product.thumbnail)
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
