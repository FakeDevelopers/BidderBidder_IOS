//
//  WritingViewController.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/15.
//

import UIKit
import Alamofire
import YPImagePicker
import SwiftUI
import Foundation

class WritingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var hopePriceTextField: UITextField!
    @IBOutlet weak var openingBidTextField: UITextField!
    @IBOutlet weak var tickTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var productContentTextView: UITextView!
    
    @IBOutlet weak var imageFiles: UIImageView!
    @IBOutlet weak var filesSelectButton: UIButton!
    var arrFiles: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageFiles.layer.cornerRadius = 10
        self.filesSelectButton.addTarget(self, action: #selector(onFilesSelectButton), for: .touchUpInside)
    }

    @objc fileprivate func onFilesSelectButton() {
        print("ViewController - onFilesSelectButton() called")
        //카메라 라이브러리 setting
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 3
        
        // camera filter 없애기
        config.showsPhotoFilters = false
        //사진이 선택 되었을 때
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
    
                //선택한 이미지로 변경
                self.imageFiles.image = photo.image
                self.arrFiles.append(photo.image)
                
            }
            //사진 선택 창 닫기
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        let productTitle = productTitleTextField.text
        let hopePrice = Int(hopePriceTextField.text!)
        let openingBid = Int(openingBidTextField.text!)
        let tick = Int(tickTextField.text!)
        let expirationDate = Double(expirationDateTextField.text!)
        let productContent = productContentTextView.text
        //let files = imageFiles.image
        
        func timePlus() -> String{
            
            let now = Date()
            let oneHourLater = now.addingTimeInterval(+(expirationDate! * 3600))
            //TimeInterval은 초를 의미한다.
            //60 - 1분
            //3600 - 1시간
            //86400 - 24시간 하루
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: oneHourLater)
        }
        
        WritingPostService.shared.postWritingData(productTitle: productTitle!, category: "String", openingBid: openingBid!, tick: tick!, expirationDate: timePlus(), productContent: productTitle!, hopePrice: hopePrice!, files: arrFiles) { result in
            switch result {
                        case .success(let msg):
                            print("success", msg)
                        case .requestErr(let msg):
                            print("requestERR", msg)
                        case .pathErr:
                            print("pathERR")
                        case .serverErr:
                            print("serverERR")
                        case .networkFail:
                            print("networkFail")
                        }
        }
    }
}

