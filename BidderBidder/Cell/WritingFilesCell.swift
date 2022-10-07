//
//  WritingFilesCell.swift
//  BidderBidder
//
//  Created by 김예림 on 2022/09/04.
//

import Foundation
import SwiftUI
import UIKit


class WritingFilesCell: UICollectionViewCell {
    
    @IBOutlet weak var files: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet var representImgTextView: RoundedCornerView!
    @IBOutlet weak var representPictureTextView: UITextField!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        self.files.layer.cornerRadius = 5
        self.files.clipsToBounds = true
        
        self.representPictureTextView.clipsToBounds = true
        self.representPictureTextView.layer.cornerRadius = 5
        self.representPictureTextView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
}
