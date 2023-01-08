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
    
    @IBOutlet var files: RoundedCornerImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var representImgView: UIView!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        representImgView.layer.cornerRadius = 8
        representImgView.clipsToBounds = true
        self.representImgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }

}
