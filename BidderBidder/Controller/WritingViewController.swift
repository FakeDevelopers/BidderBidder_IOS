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

class WritingViewController: UIViewController {
    
    //product Info
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var hopePriceTextField: UITextField!
    @IBOutlet weak var openingBidTextField: UITextField!
    @IBOutlet weak var tickTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var productContentTextView: UITextView!
    
    //'₩' label
    @IBOutlet weak var hopePriceLabel: UILabel!
    @IBOutlet weak var openingBidLabel: UILabel!
    @IBOutlet weak var tickLabel: UILabel!

    @IBOutlet weak var textCountLabel: UILabel! = {
        let label = UILabel()
        label.textColor = .placeholderText
        label.text = "0/1000"
        return label
    }()

    @IBOutlet weak var filesCountLabel: UILabel! = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0"
        return label
    }()

    var placeholderLabel : UILabel!

    // imageFiles
    var filesCount = 0
    
    @IBOutlet weak var filesSelectButtonView: UIView!
    @IBOutlet weak var filesSelectButton: UIButton!
    var arrFiles: [UIImage]! = []
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    // MARK: - textFieldDidChange
    @objc func textFieldDidChange(textField: UITextField) {
        if textField == hopePriceTextField {
            if textField.text == "" {
                hopePriceLabel.textColor = .placeholderText
            } else {
                hopePriceLabel.textColor = .black
            }
        }
        else if textField == openingBidTextField {
            if textField.text == "" {
                openingBidLabel.textColor = .placeholderText
            } else {
                openingBidLabel.textColor = .black
            }
        } else {
            if textField.text == "" {
                tickLabel.textColor = .placeholderText
            } else {
                tickLabel.textColor = .black
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // textField 변경 시 priceLabel 설정
        self.hopePriceTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.allEditingEvents)
        self.openingBidTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.tickTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

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

        filesSelectButtonView.layer.cornerRadius = 5
        filesSelectButtonView.layer.borderWidth = 1.5
        filesSelectButtonView.layer.borderColor = CGColor(red: 0.94, green: 0.94, blue: 0.94, alpha:1.00 )

        //filesSelectButton
        filesSelectButton.addTarget(self, action: #selector(onFilesSelectButton), for: .touchUpInside)
    }

    // MARK: - FilesSelectButton

    @objc fileprivate func onFilesSelectButton() {
        print("ViewController - onFilesSelectButton() called")

        //파일 첨부 개수 제한 및 alert
        if filesCount < 10 {
            filesPicker()
        } else {
            let alert = UIAlertController(title: "알림", message: "이미지는 최대 10장까지 첨부할 수 있어요", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "닫기", style: .default)
            alert.addAction(action)
            present(alert, animated: false, completion: nil)
        }
    }

    // MARK: - YPImagePicker

    func filesPicker() {
        var config = YPImagePickerConfiguration()

        config.showsPhotoFilters = false
        //이미지 선택 개수 제한
        config.library.maxNumberOfItems = {
            if self.filesCount < 10 {
                return (10-self.filesCount)
            } else {
                return 0
            }
                }()
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
            self.filesCount += items.count
            self.filesCountLabel.textColor = UIColor(red: 0.13, green: 0.81, blue: 1.00, alpha: 1.00)
            self.filesCountLabel.text = "\(self.filesCount)"
        }
        present(picker, animated: true, completion: nil)
    }

    // MARK: - tapSaveButton

    @IBAction func tapSaveButton(_: Any) {
        postServer()
    }
}

// MARK: - textView setting
extension WritingViewController: UITextViewDelegate {
    //글자 수
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        var currentText = textView.text ?? ""

        if currentText.count >= 1000 {
            currentText.removeLast()
            textCountLabel.text = "1000/1000"
            textCountLabel.textColor = .systemRed
        } else {
            textCountLabel.text = "\(currentText.count)/1000"
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newLength = textView.text.count - range.length + text.count
    if newLength > 1000 {
    return false
        }
    return true
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
        if indexPath.row != 0 {
            cell.representImgView.isHidden = true
        }
        return cell
    }
}
// MARK: - UITextFieldDelegate
extension WritingViewController: UITextFieldDelegate {
    // 숫자 콤마 입력
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0

        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{
                if string == "" {
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{
                    return false
                }
            }

        }

        return true
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
