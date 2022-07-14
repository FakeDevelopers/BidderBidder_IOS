//
//  WritingViewController.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/09.
//

import UIKit
import Alamofire

class WritingViewController: UIViewController, UITextViewDelegate{
    
    struct Constant {
        static let DomainURL:String = "http://3.38.81.213:8080"
    }
    
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var hopePriceTextField: UITextField!
    @IBOutlet weak var openingBidTextField: UITextField!
    @IBOutlet weak var tickTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var productContentTextView: UITextView!
    
    
    @IBAction func tapSaveButton(_ sender: Any) {
        let productTitle = productTitleTextField.text
        let hopePrice = hopePriceTextField.text
        let openingBid = openingBidTextField.text
        let tick = tickTextField.text
        let expirationDate = expirationDateTextField.text
        let productContent = productContentTextView.text
        
        let writingStruct = WritingStruct(productTitle: productTitle, hopePrice: hopePrice, openingBid: openingBid, tick: tick, expirationDate: expirationDate, productContent: productContent)
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(writingStruct), forKey: "writingStruct")
        
        //저장 확인 코드
        if let data = UserDefaults.standard.value(forKey: "writingStruct") as? Data {
            let model = try? PropertyListDecoder().decode(WritingStruct.self, from: data)
            print(model)
        }
        
        let parameters: [String: Any] = [
            "productTitle": productTitle!,
            "hopePrice": hopePrice!,
            "openingBid": openingBid!,
            "tick": tick!,
            "expirationDate": expirationDate!,
            "productContent": productContent!
        ]
        
        sendRestRequest(url: Constant.DomainURL + "/product/write", params: parameters as Dictionary) {
                        response in
                        switch response.result {
                            
                        case .success:
                            print("통신 성공")
                            
                        case .failure(let error):
                            print("통신 실패 : ",(String(describing: error.errorDescription)))
                        }
            }
    }
}
