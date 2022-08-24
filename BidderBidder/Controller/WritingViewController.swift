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

class WritingViewController: UIViewController {

    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var hopePriceTextField: UITextField!
    @IBOutlet weak var openingBidTextField: UITextField!
    @IBOutlet weak var tickTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var productContentTextView: UITextView!
    
    @IBOutlet weak var priceLable_1: UILabel!
    @IBOutlet weak var priceLable_2: UILabel!
    @IBOutlet weak var priceLable_3: UILabel!
    
    var placeholderLabel : UILabel!
    
    // imageFiles
    @IBOutlet weak var filesSelectButton: UIButton!
    var arrFiles: [UIImage]! = []
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    // MARK: - count text
        lazy var remainCountLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.text = "0/1000"
            label.font = .systemFont(ofSize: 30)
            label.textColor = .lightGray
            label.textAlignment = .center

            return label
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //textViewPlaceholder
        productContentTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "물품에 대한 정보를 작성해주세요!"
        placeholderLabel.font = .italicSystemFont(ofSize: (productContentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        productContentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (productContentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !productContentTextView.text.isEmpty
        
        //filesSelectButton
        self.filesSelectButton.addTarget(self, action: #selector(onFilesSelectButton), for: .touchUpInside)
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

            for index in 0..<items.count {

                switch items[index] {
                case .photo(let photo):
                    self.arrFiles.append(photo.image)
                    DispatchQueue.main.async {
                        self.filesCollectionView.reloadData()
                    }
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true, completion: nil)
    }

    // MARK: - tapSaveButton
    @IBAction func tapSaveButton(_ sender: Any) {
        postServer()
    }
}

// MARK: - placeHolder
extension WritingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
}

// MARK: - collectionViewDataSource
extension WritingViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingFilesCell", for: indexPath) as? WritingFilesCell else {
            return UICollectionViewCell()
        }
        cell.files.image = arrFiles[indexPath.row]
        return cell
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

        for img in arrFiles {

            if img != nil {
                imgList.append(img)
            }
        }

        // expirationDate
        func timePlus() -> String {

            let now = Date()
            let addTime = now.addingTimeInterval(+(expirationDate! * 3600))
            let formatter = DateFormatter()

            formatter.dateFormat = "yyyy-MM-dd HH:mm"
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
                    "tick": tick
                ]

        // MARK: - ServerPost code
        postWritingData(url: Constant.domainURL + Constant.writeURL, params: params, files: imgList) { result in
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
