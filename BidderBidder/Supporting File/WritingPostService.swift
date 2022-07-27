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
                         represidentPicture: Int,
                         completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header : HTTPHeaders = [
                "Content-Type" : "multipart/form-data",
                "Content-Type" : "application/json",
                //"jwt" : UserDefaults.standard.value(forKey: "jwt") as! String
        ]
        
        let params: [String: Any] = [
            "productTitle": productTitle,
            "hopePrice": hopePrice,
            "category": category,
            "openingBid": openingBid,
            "tick": tick,
            "expirationDate": expirationDate,
            "productContent": productTitle,
            "represidentPicture": represidentPicture
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
            
        }, to: "\(Constant.domainURL)/product/write"
                ,usingThreshold: UInt64.init()
                ,method: .post
                  ,headers: header).responseString (completionHandler: { (response) in
            print(response)
            
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            print("success")
            
        })
    }
}
