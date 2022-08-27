//
//  UIImageView.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/07/12.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, completion: (() -> Void)? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data)
                    else {
                        return
                    }
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = image
                        if let completion = completion {
                            completion()
                        }
                    }
                }
                .resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, completion: (() -> Void)? = nil) {
        guard let url = URL(string: link) else {
            return
        }
        downloaded(from: url, contentMode: mode, completion: completion)
    }
}

class RoundedCornerImageView: UIImageView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
}
