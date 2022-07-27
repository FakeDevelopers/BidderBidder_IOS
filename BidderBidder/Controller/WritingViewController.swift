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
    
    //imageFiles
    @IBOutlet var imageFiles: [UIImageView]!
    @IBOutlet weak var filesSelectButton: UIButton!
    var arrFiles: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.imageFiles.layer.cornerRadius = 10
        self.filesSelectButton.addTarget(self, action: #selector(onFilesSelectButton), for: .touchUpInside)
    }

    @objc fileprivate func onFilesSelectButton() {
        print("ViewController - onFilesSelectButton() called")
        filesPicker()
    }
    
    // MARK: - YPImagePicker
    func filesPicker() {
        var config = YPImagePickerConfiguration()
        
        config.showsPhotoFilters = false
        config.library.maxNumberOfItems = 3
        config.shouldSaveNewPicturesToAlbum = true
        config.startOnScreen = .library
        config.wordings.libraryTitle = "갤러리"
        config.maxCameraZoomFactor = 2.0
        config.gallery.hidesRemoveButton = false
        config.hidesBottomBar = false
        config.hidesStatusBar = false
        //config.overlayView = UIView()
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            var i: Int = 0
            
            for item in items {
                switch item {
                case .photo(let photo):
                    self.imageFiles[i].image = photo.image
                    self.arrFiles.append(photo.image)
                    
                case .video(let video):
                    print(video)
                }
                
                i = i+1
            }
            self.filesSelectButton.isHidden = true
            picker.dismiss(animated: true)
        }
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - tapSaveButton
    @IBAction func tapSaveButton(_ sender: Any) {
        postServer()
    }
}


// MARK: - Server
extension WritingViewController {
    
    func postServer() {
        let productTitle = productTitleTextField.text
        let hopePrice = Int(hopePriceTextField.text!)
        let openingBid = Int(openingBidTextField.text!)
        let tick = Int(tickTextField.text!)
        let expirationDate = Double(expirationDateTextField.text!)
        let productContent = productContentTextView.text
        
        var imgList: [UIImage] = []
        for imgView in imageFiles {
            if imgView.image != nil {
                imgList.append(imgView.image!)
            }
        }
        
        //expirationDate
        func timePlus() -> String{
            
            let now = Date()
            let addTime = now.addingTimeInterval(+(expirationDate! * 3600))
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print(formatter.string(from: addTime))
            return formatter.string(from: addTime)
        }
        
        
        // MARK: - ServerPost code
        WritingPostService.shared.postWritingData(productTitle: productTitle!, category: "Food", openingBid: openingBid!, tick: tick!, expirationDate: timePlus(), productContent: productTitle!, hopePrice: hopePrice!, files: imgList, represidentPicture: 0) { result in
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
