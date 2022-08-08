//
//  UIViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/07/12.
//

import Foundation
import UIKit
import Alamofire

extension UIViewController {
    func sendRestRequest(url: String, params: Parameters?, isPost: Bool = true, response: @escaping (AFDataResponse<Data?>) -> Void) -> Request {
        return AF.request(url, method: isPost ? .post : .get, parameters: params).response(completionHandler: response)
    }
    
    //writing post
    func postWritingData(url: String, params: Dictionary<String, Any?>, files: [UIImage?], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for image in files {
                if let image = image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(image, withName: "files", fileName: "\(files).jpg", mimeType: "image/jpeg") // jpeg 파일로 전송
                }
            }
            
            for (key, value) in params {
                if let value = value{
                    multipartFormData.append("\(String(describing: value))".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                } else {
                    multipartFormData.append(Data(), withName: "\(key)")
                }
            }
                
        }, to: url, method: .post, headers: header).response(completionHandler: { (response) in
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            print("success")
            print(response)
        })
    }
    
}
