//
//  UIViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/07/12.
//

import Alamofire
import Foundation
import UIKit

extension UIViewController {
    @discardableResult
    func sendRestRequest(url: String, params: Parameters?, isPost: Bool = true, response: @escaping (AFDataResponse<Data?>) -> Void) -> Request {
        AF.request(url, method: isPost ? .post : .get, parameters: params).response(completionHandler: response)
    }

    // writing post

    func postWritingData(url: String, params: [String: Any?], files: [UIImage?], completion _: @escaping (NetworkResult<Any>) -> Void) {
        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
        ]

        AF.upload(multipartFormData: { multipartFormData in

            for image in files {
                if let image = image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(image, withName: "files", fileName: "\(image).jpg", mimeType: "image/jpeg")
                }
            }

            for (key, value) in params {
                if let value = value {
                    multipartFormData.append("\(String(describing: value))".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                } else {
                    multipartFormData.append(Data(), withName: "\(key)")
                }
            }

        }, to: url, method: .post, headers: header)
            .response(completionHandler: { response in
                if let err = response.error { // 응답 에러
                    print(err)
                    return
                }
                print("success")
            })
    }

    func showProgress() {
        let progress = storyboard?.instantiateViewController(withIdentifier: "ProgressPopup") as! ProgressPopup
        ProgressPopup.instance = progress
        progress.modalPresentationStyle = .overCurrentContext
        present(progress, animated: false)
    }

    func dismissProgress(_ completion: (() -> Void)? = nil) {
        ProgressPopup.instance.dismiss(animated: false, completion: completion)
    }
}

class RoundedCornerView: UIView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15.0
        clipsToBounds = true
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
    }
}
