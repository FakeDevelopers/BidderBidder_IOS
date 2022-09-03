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

    override func awakeFromNib() {
        super .awakeFromNib()
        self.files.layer.cornerRadius = 5
        self.files.clipsToBounds = true
    }
}
