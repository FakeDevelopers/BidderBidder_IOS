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
}
