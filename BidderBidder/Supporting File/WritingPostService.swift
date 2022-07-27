//
//  WritingPostService.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/25.
//

import Foundation
import Alamofire
import UIKit


struct WritingPostService {
    
    static let shared = WritingPostService()
    
    func postWritingData(productTitle: String,
                         category: String,
                         openingBid: Int,
                         tick: Int,
                         expirationDate: String,
                         productContent: String,
                         hopePrice: Int,
                         files: [UIImage],
                         completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header : HTTPHeaders = [
                    "Content-Type" : "multipart/form-data"
        ]
        
        let params: [String: Any] = [
            "productTitle": productTitle,
            "hopePrice": hopePrice,
            "category": category,
            "openingBid": openingBid,
            "tick": tick,
            "expirationDate": expirationDate,
            "productContent": productTitle
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for image in files {
                            if let image = image.jpegData(compressionQuality: 1) {
                                multipartFormData.append(image, withName: "files", fileName: "\(files).jpg", mimeType: "image/jpeg") // jpeg 파일로 전송
                            }
            }
            
            for (key, value) in params {
                           
                                multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                        }
            
        }, to: Constant.domainURL + "/product/write"
                ,usingThreshold: UInt64.init()
                ,method: .post
                ,headers: header).response { response in
                    switch response.result {
                        case .success(_):
                            print("success")
                        case .failure(let error):
                            print("Error while querying database: \(String(describing: error))")
                        }
                    }
    }
}
