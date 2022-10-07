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
    @IBOutlet weak var representImgView: UIView!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        self.files.layer.cornerRadius = 5
        self.files.clipsToBounds = true
        
        self.representImgView.clipsToBounds = true
        self.representImgView.layer.cornerRadius = 5
        self.representImgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
}
