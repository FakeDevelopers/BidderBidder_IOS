//
//  WritingViewController.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/07/15.
//

import Alamofire
import Foundation
import SwiftUI
import UIKit
import YPImagePicker

class WritingViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var productTitleTextField: UITextField!
    @IBOutlet var hopePriceTextField: UITextField!
    @IBOutlet var openingBidTextField: UITextField!
    @IBOutlet var tickTextField: UITextField!
    @IBOutlet var expirationDateTextField: UITextField!
    @IBOutlet var productContentTextView: UITextView!

    // imageFiles
    @IBOutlet var imageFiles: [UIImageView]!
    @IBOutlet var filesSelectButton: UIButton!
    var arrFiles: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        filesSelectButton.addTarget(self, action: #selector(onFilesSelectButton), for: .touchUpInside)
    }

    // MARK: - FilesSelectButton

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

        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            for index in 0 ..< items.count {
                switch items[index] {
                case let .photo(photo):
                    self.imageFiles[index].image = photo.image
                    self.arrFiles.append(photo.image)

                case let .video(video):
                    print(video)
                }
            }
            self.filesSelectButton.isHidden = true
            picker.dismiss(animated: true)
        }
        present(picker, animated: true, completion: nil)
    }

    // MARK: - tapSaveButton

    @IBAction func tapSaveButton(_: Any) {
        postServer()
    }
}

// MARK: - Server

extension WritingViewController {
    func postServer() {
        let productTitle = productTitleTextField.text
        let hopePrice: Int? = Int(hopePriceTextField.text ?? "")
        let openingBid = Int(openingBidTextField.text!)
        let tick = Int(tickTextField.text!)
        let expirationDate = Double(expirationDateTextField.text!)
        let productContent = productContentTextView.text

        // files
        var imgList: [UIImage] = []

        for imgView in imageFiles {
            if imgView.image != nil {
                imgList.append(imgView.image!)
            }
        }

        // expirationDate
        func timePlus() -> String {
            let now = Date()
            let addTime = now.addingTimeInterval(+(expirationDate! * 3600))
            let formatter = DateFormatter()

            formatter.dateFormat = Constant.dateTimeFormat
            print(formatter.string(from: addTime))

            return formatter.string(from: addTime)
        }

        let params: [String: Any?] = [
            "category": 0,
            "expirationDate": timePlus(),
            "hopePrice": hopePrice,
            "openingBid": openingBid,
            "productContent": productContent,
            "productTitle": productTitle,
            "representPicture": 0,
            "tick": tick,
        ]

        // MARK: - ServerPost code

        postWritingData(url: Constant.domainURL + Constant.writeURL, params: params, files: imgList) { result in
            switch result {
            case let .success(msg):
                print("success", msg)
            case let .requestErr(msg):
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
